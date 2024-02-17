//
//  Episode.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
}
