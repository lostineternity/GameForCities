//
//  Questions.swift
//  GameForCities
//
//  Created by Sokol Vadym on 24.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

struct JSONdata: Codable {
    var capitalCity: String
    var lat: String
    var long: String
}

struct Question {
    var capitalCity: String
    var latitude: Double
    var longitude: Double
}
