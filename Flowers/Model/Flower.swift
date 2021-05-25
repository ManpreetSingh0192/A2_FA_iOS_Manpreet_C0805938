//
//  Flower.swift
//  Flowers
//
//  Created by Mister on 23/05/2021.
//

import Foundation

class Flower {
    var flower_id: String
    var name: String
    var price: Double
    var provider: String
    var description: String
    
    init(flower_id: String, name: String,  price: Double, provider: String,description: String) {
        self.flower_id = flower_id
        self.name = name
        self.price = price
        self.provider = provider
        self.description = description
    }
}
