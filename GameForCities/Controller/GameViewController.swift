//
//  GameViewController.swift
//  GameForCities
//
//  Created by Sokol Vadym on 16.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import UIKit
import GoogleMaps

class GameViewController: UIViewController {

    let game = Game.shared
    
    var currentCameraPosition: GMSCameraPosition!
    var currentCursorCoordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var capitalCity: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var placeMarkerButton: UIButton!
    @IBOutlet weak var nextGameButton: UIButton!
    
    @IBOutlet weak var citiesPlaced: UILabel!
    @IBOutlet weak var kilometersLeft: UILabel!
    @IBOutlet weak var cityToPlace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstVCloadSetup()
        update()
    }
    
    func firstVCloadSetup() {
        
        game.delegate = self
        mapView.delegate = self
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.black.cgColor
        
        let camera = GMSCameraPosition.camera(withLatitude: 48.728592, longitude: 21.240559, zoom: 3.0)
        mapView.camera = camera
        do {
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
            else {
                print("Unable to find mapStyle.json")
            }
        }
        catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true
        
        capitalCity.text = game.currentQuestion?.capitalCity
    }
    
    func update() {
        nextQuestionButtonUpdate()
        citiesPlaced.text = "Cities placed: \(game.citiesPlaced)"
        kilometersLeft.text = "Kilometers left: \(game.distanceLeft)"
        cityToPlace.text = game.currentQuestion?.capitalCity
    }
    
    func nextQuestionButtonUpdate() {
        if game.isQuestionsListEnd || game.isGameOver {
            nextGameButton.setTitle("Start new game", for: .normal)
        } else {
            nextGameButton.setTitle("Next question", for: .normal)
        }
    }
    
    func didFinishGame() {
        nextQuestionButtonUpdate()
        currentCursorCoordinate = nil
        if game.isQuestionsListEnd || game.isGameOver {
            let title = "Game over"
            let message = "Lets check your result"
            let okAction = UIAlertAction(title: "Ok", style: .default){ [weak self] _ in
                self?.resultAlert()
            }
            let gameOverAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            gameOverAlert.addAction(okAction)
            self.present(gameOverAlert, animated: true)
        }
    }
    
    func resultAlert() {
        let title = "Your result"
        let message = "Cities placed:  \(game.citiesPlaced) \n Kilometers left: \(game.distanceLeft)"
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let startNewGameAction = UIAlertAction(title: "Start new game", style: .default) { [weak self] _ in
            self?.mapView.clear()
            self?.game.startNewGame()
            self?.update()
        }
        let resultAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        resultAlert.addAction(okAction)
        resultAlert.addAction(startNewGameAction)
        self.present(resultAlert, animated: true)
    }
    
    @IBAction private func placeMarkerButtonAction(_ sender: Any) {
        if let selectedPosition = currentCursorCoordinate {
            placeMarker(title: "Your answer", color: .red, position: selectedPosition)
            guard let currentQuestion = game.currentQuestion else { return }
            guard let currentQuestionPosition = game.currentQuestionPosition else { return }
            placeMarker(title: currentQuestion.capitalCity, color: .blue, position: currentQuestionPosition)
            rightAnswerCircle(radius: rightAnswerRadius, position: currentQuestionPosition)
            placeLine(answerPosition: selectedPosition, rightPosition: currentQuestionPosition)
            game.update(answerPosition: selectedPosition, rightPosition: currentQuestionPosition)
            update()
        }
    }
    
    @IBAction private func nextQuestionButtonPress(_ sender: Any) {
        if game.isQuestionsListEnd || game.isGameOver {
            game.startNewGame()
            mapView.clear()
            update()
        } else {
            guard let _ = currentCursorCoordinate, game.answerReceived else { return }
            game.nextQuestion()
            mapView.clear()
            update()
        }
    }
}

// MARK: Map tuning
extension GameViewController {
    
    func placeMarker(title: String, color: UIColor, position: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.icon     = GMSMarker.markerImage(with: color)
        marker.position = position
        marker.title    = title
        marker.snippet  = "lat: \(String(format: "%.3f", position.latitude)) \n long: \(String(format: "%.3f", position.longitude))"
        marker.map = mapView
    }
    
    func rightAnswerCircle(radius: Double, position: CLLocationCoordinate2D) {
        let circleCenter = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
        let circle = GMSCircle(position: circleCenter, radius: radius)
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
        circle.strokeWidth = 1
        circle.strokeColor = UIColor.red
        circle.map = mapView
    }
    
    func placeLine(answerPosition: CLLocationCoordinate2D, rightPosition: CLLocationCoordinate2D){
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: answerPosition.latitude, longitude: answerPosition.longitude))
        path.add(CLLocationCoordinate2D(latitude: rightPosition.latitude, longitude: rightPosition.longitude))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
    }
    
}

// MARK: GMSMapViewDelegate
extension GameViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        currentCameraPosition = position
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        currentCursorCoordinate = coordinate
        if let selectedPosition = currentCursorCoordinate {
            mapView.clear()
            placeMarker(title: "Your answer", color: .red, position: selectedPosition)
            update()
        }
    }
}
