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
        
        game.delegate = self
        
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
        mapView.delegate = self
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true
        
        capitalCity.text = game.currentQuestion?.capitalCity
        
        update()
    }
    
    func update() {
        citiesPlaced.text = "Cities placed: \(game.citiesPlaced)"
        kilometersLeft.text = "Kilometers left: \(game.distanceLeft)"
        cityToPlace.text = game.currentQuestion?.capitalCity
        if game.answerReceived {
            placeMarkerButton.alpha = 0
            nextGameButton.alpha = 1
        }
        else {
            placeMarkerButton.alpha = 1
            nextGameButton.alpha = 0
        }
        
    }
    
    func didFinishGame() {
        if game.isQuestionsListEnd || game.isGameOver {
            let title = "Game over"
            let message = "Lets check your result"
            let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                self.resultAlert()
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
        game.NextQuestion()
        guard (game.isQuestionsListEnd || game.isGameOver) else {
            mapView.clear()
            update()
            return
        }
    }
    
}
