//
//  Repository.swift
//  GameForCities
//
//  Created by Sokol Vadym on 17.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import Foundation

class Repository {
    
    static var shared = Repository()

    var pathToFileWithQuestions: String!
    var jsonDataQuestions: Data!
    
    private init () {
        pathToFileWithQuestions = Bundle.main.path(forResource: "capitalCities", ofType: "json")
        jsonDataQuestions = try? Data(contentsOf: URL(fileURLWithPath: pathToFileWithQuestions!), options: Data.ReadingOptions.dataReadingMapped)
    }
    
    func parseJsonData() -> [Question] {
        let decoder = JSONDecoder()
        let jsonDataDict = try! decoder.decode([String:[JSONdata]].self, from: jsonDataQuestions)
        var jsonData: [JSONdata] = []
        for (_, value) in jsonDataDict {
            jsonData.append(contentsOf: value)
        }
        return convertJsonDataToWorkModel(jsonData)
    }
    
    func convertJsonDataToWorkModel(_ jsonData: [JSONdata]) -> [Question] {
        var questions: [Question] = []
        for jsonQuestion in jsonData {
            if let latitude = Double(jsonQuestion.lat), let longitude = Double(jsonQuestion.long) {
                questions.append(Question(capitalCity: jsonQuestion.capitalCity, latitude: latitude, longitude: longitude))
            }
        }
        return questions
    }
}
