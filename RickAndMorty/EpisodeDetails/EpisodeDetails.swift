//
//  EpisodeDetails.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EpisodeDetails {
    @Dependency(\.episodeClient) var episodeClient
    
    @ObservableState
    struct State {
        var episodeUrl: String
        var episode: Episode?
        var isLoading: Bool = false
    }

    enum Action {
        case viewAppeared
        case reloadButtonTapped
        case episodeLoaded(Episode)
        case closeButtonTapped
        case errorOccureed
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewAppeared, .reloadButtonTapped:
                state.isLoading = true
                let url = state.episodeUrl
                return .run { send in
                    do {
                        let response = try await self.episodeClient.episodeDetails(url)
                        await send(.episodeLoaded(response))
                    } catch {
                        await send(.errorOccureed)
                    }
                }
                
            case let .episodeLoaded(response):
                state.episode = response
                state.isLoading = false
                return .none
                
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .errorOccureed:
                state.isLoading = false
                return .none
            }
        }
    }
}
