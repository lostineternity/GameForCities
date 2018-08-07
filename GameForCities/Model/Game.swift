//
//  Game.swift
//  GameForCities
//
//  Created by Sokol Vadym on 17.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import GoogleMaps

class Game {
    
    static let shared = Game()
    
    var delegate: GameViewController?
    
    var repositorium = Repository.shared
    var distanceLeft = defaultGameDistance
    
    var questions: Questions?
    var currentQuestion: Question? {
        guard !isQuestionsListEnd, let array = questions else { return nil }
        return array.capitalCities[numberOfQuestion]
    }
    var currentQuestionPosition: CLLocationCoordinate2D? {
        guard let question = currentQuestion else { return nil }
        return CLLocationCoordinate2D(latitude: Double(question.lat)!, longitude: Double(question.long)!)
    }
    
    var answerReceived = false
    var numberOfQuestion = 0
    var citiesPlaced = 0

    var isQuestionsListEnd = false {
        didSet {
            if isQuestionsListEnd { delegate?.didFinishGame() }
        }
    }
    var isGameOver = false {
        didSet {
            if isGameOver { delegate?.didFinishGame() }
        }
    }
    
    private init() {
        fetchQuestionsFromRepository()
    }
    
    func fetchQuestionsFromRepository() {
        questions = repositorium.parseJsonData()
    }
    
    func NextQuestion() {
        guard !(isGameOver || isQuestionsListEnd), let array = questions else { return }
        numberOfQuestion += 1
        if array.capitalCities.endIndex <= numberOfQuestion {
            isQuestionsListEnd = true
        }
        answerReceived = false
    }
    
    func update(answerPosition: CLLocationCoordinate2D, rightPosition: CLLocationCoordinate2D) {
        answerReceived = true
        let coordinateAnswer = CLLocation(latitude: answerPosition.latitude, longitude: answerPosition.longitude)
        let coordinateRightPosition = CLLocation(latitude: rightPosition.latitude, longitude: rightPosition.longitude)
        let distanceInMeters = coordinateAnswer.distance(from: coordinateRightPosition)
        
        guard distanceInMeters > rightAnswerRadius else {
            citiesPlaced += 1
            return
        }
        let countedDistance = distanceLeft - Int(distanceInMeters)/1000
        if countedDistance < 0 {
            distanceLeft = 0
            isGameOver = true
        }
        else {
            distanceLeft = countedDistance
        }
    }
    
    func startNewGame() {
        Game.shared.dispose()
        fetchQuestionsFromRepository()
    }
    
    private func dispose() {
        distanceLeft = defaultGameDistance
        answerReceived = false
        numberOfQuestion = 0
        citiesPlaced = 0
        questions = nil
        isQuestionsListEnd = false
        isGameOver = false
    }
    
}
