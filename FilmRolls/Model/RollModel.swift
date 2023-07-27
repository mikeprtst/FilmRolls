//
//  RollModel.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit


class RollModel{
    
    init (data: RollData){
        imageURL = data.staticImageUrl
        brand = data.brand
        name = data.name
        description = data.description
        infoSetUp(data)
    }


    let imageURL: String!
    var brand: String!
    var name: String!
    var description: String!
    var info: [[String]] = []
    var image: UIImage? {
        get async throws {
            try await NetworkManager.shared.loadImage(string: imageURL)
        }
    }
    var thumbnail: UIImage? {
        get async throws {
            if let thumb = thumb{
                return thumb
            } else {
                let thumb = try await NetworkManager.shared.loadThumb(string: imageURL)
                self.thumb = thumb
                return thumb
            }
        }
    }
    private var thumb: UIImage?
    
    private func infoSetUp(_ data: RollData){
        info.append(["Format", data.formatThirtyFive && data.formatOneTwenty ? "35 & 120" : "\(data.formatThirtyFive ? "35" : "")\(data.formatOneTwenty ? "120" : "")"])
        info.append(["Color", data.color ? "Color Film" : "Black and White Film"])
        info.append(["ISO", "\(Int(data.iso))"])
        info.append(["Process", data.process])
        for i in data.keyFeatures{
            info.append([i.feature])
        }
    }
}
