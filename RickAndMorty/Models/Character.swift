//
//  Character.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import Foundation

struct CharacterResponse: Codable {
    let info: CharacterResponseInfo
    let results: [Character]
}

struct CharacterResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let origin: NameWithUrl
    let location: NameWithUrl
    let image: String
    let episode: [String]
}

struct NameWithUrl: Codable {
    let name: String
    let url: String
}

extension Character {
    static let mock = Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        gender: "Male",
        origin: NameWithUrl(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
        location: NameWithUrl(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            "https://rickandmortyapi.com/api/episode/3",
            "https://rickandmortyapi.com/api/episode/4",
            "https://rickandmortyapi.com/api/episode/5",
            "https://rickandmortyapi.com/api/episode/6",
            "https://rickandmortyapi.com/api/episode/7",
            "https://rickandmortyapi.com/api/episode/8",
            "https://rickandmortyapi.com/api/episode/9",
            "https://rickandmortyapi.com/api/episode/10"
        ]
    )
}
