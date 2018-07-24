//
//  Game.swift
//  GameForCities
//
//  Created by Sokol Vadym on 17.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import Foundation
import GoogleMaps

struct Questions: Codable {
    var capitalCities: [Question]
}
struct Question: Codable {
    var capitalCity: String
    var lat: String
    var long: String
}

class Game {
    
    static let shared = Game()
    
    var repositorium = Repositorium.shared
    var distanceLeft = defaultGameDistance
    var currentQuestion: Question!
    var currentQuestionPosition: CLLocationCoordinate2D!
    var answerReceived = false
    var numberOfQuestion = 0
    var citiesPlaced = 0
    var questions: Questions!
    var isQuestionsListEnd = false
    var isGameOver = false
    
    func fetchQuestionsFromRepositorium(){
        questions = repositorium.parseJsonData()
        currentQuestion = questions.capitalCities[numberOfQuestion]
        currentQuestionPosition = CLLocationCoordinate2D(latitude: Double(currentQuestion.lat)!, longitude: Double(currentQuestion.long)!)
    }
    
    func getNextQuestion(){
        numberOfQuestion += 1
        if questions.capitalCities.endIndex > numberOfQuestion {
            currentQuestion = questions.capitalCities[numberOfQuestion]
            currentQuestionPosition = CLLocationCoordinate2D(latitude: Double(currentQuestion.lat)!, longitude: Double(currentQuestion.long)!)
        }
        else {
            currentQuestion = nil
            currentQuestion = nil
            isQuestionsListEnd = true
        }
        answerReceived = false
    }
    
    func countResult(answerPosition: CLLocationCoordinate2D, rightPosition: CLLocationCoordinate2D){
        answerReceived = true
        let coordinateAnswer = CLLocation(latitude: answerPosition.latitude, longitude: answerPosition.longitude)
        let coordinateRightPosition = CLLocation(latitude: rightPosition.latitude, longitude: rightPosition.longitude)
        let distanceInMeters = coordinateAnswer.distance(from: coordinateRightPosition)
        if distanceInMeters > rightAnswerRadius {
            let countedDistance = distanceLeft - Int(distanceInMeters)/1000
            if countedDistance < 0 {
                distanceLeft = 0
                isGameOver = true
            }
            else {
                distanceLeft = countedDistance
            }
        }
        else {
            citiesPlaced += 1
        }
    }
    
    func startNewGame(){
        Game.shared.dispose()
        fetchQuestionsFromRepositorium()
    }
    
    private func dispose(){
        distanceLeft = defaultGameDistance
        currentQuestion = nil
        currentQuestionPosition = nil
        answerReceived = false
        numberOfQuestion = 0
        citiesPlaced = 0
        questions = nil
        isQuestionsListEnd = false
        isGameOver = false
    }
    
}
