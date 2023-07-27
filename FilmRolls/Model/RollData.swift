//
//  RollData.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import Foundation


struct RollData: Codable{
    
    let brand: String
    let name: String
    let staticImageUrl: String
    let description: String
    let iso: Float
    let formatThirtyFive: Bool
    let formatOneTwenty: Bool
    let color: Bool
    let process: String
    let keyFeatures: [Features]
}


struct Features: Codable{
    let feature: String
}
