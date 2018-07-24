//
//  Questions.swift
//  GameForCities
//
//  Created by Sokol Vadym on 24.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

struct Questions: Codable {
    var capitalCities: [Question]
}

struct Question: Codable {
    var capitalCity: String
    var lat: String
    var long: String
}
