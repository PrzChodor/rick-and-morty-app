//
//  CharacterClient.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct CharacterClient {
    var characterList: (_ url: String) async throws -> CharacterResponse
}

extension CharacterClient: DependencyKey {
    static var liveValue: CharacterClient = Self(
        characterList: { url in
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return response
        }
    )
}

extension DependencyValues {
  var characterClient: CharacterClient {
    get { self[CharacterClient.self] }
    set { self[CharacterClient.self] = newValue }
  }
}
