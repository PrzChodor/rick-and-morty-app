//
//  EpisodeClient.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct EpisodeClient {
    var episodeDetails: (_ url: String) async throws -> Episode
}

extension EpisodeClient: DependencyKey {
    static var liveValue: EpisodeClient = Self(
        episodeDetails: { url in
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let episode = try decoder.decode(Episode.self, from: data)
            return episode
        }
    )
}

extension DependencyValues {
  var episodeClient: EpisodeClient {
    get { self[EpisodeClient.self] }
    set { self[EpisodeClient.self] = newValue }
  }
}
