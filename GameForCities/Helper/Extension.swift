//
//  Extension.swift
//  GameForCities
//
//  Created by Sokol Vadym on 22.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import Foundation
import GoogleMaps

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
    }
}
