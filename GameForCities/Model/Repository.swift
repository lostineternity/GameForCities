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
        let questionsDict = try! decoder.decode([String:[Question]].self, from: jsonDataQuestions)
        var questions: [Question] = []
        for (_, value) in questionsDict {
            questions.append(contentsOf: value as [Question])
        }
        return questions
    }
    
}
