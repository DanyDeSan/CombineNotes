//
//  CatInfoModel.swift
//  Kittinder
//
//  Created by L Daniel De San Pedro on 24/07/23.
//

import Foundation

// MARK: - CatInfoModel
struct CatInfoModel: Codable {
    // MARK: Attributes
    let breeds: [BreedModel]?
    let id: String
    let url: String
    let width, height: Int
}
