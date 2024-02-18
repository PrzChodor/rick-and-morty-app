//
//  CharacterDetails.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterDetails {
    
    @ObservableState
    struct State {
        @Presents var episodeDetails: EpisodeDetails.State?
        var character: Character
        var isFavorite: Bool
    }

    enum Action {
        case episodeDetails(PresentationAction<EpisodeDetails.Action>)
        case episodeSelected(String)
        case favoriteButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .episodeSelected(episodeUrl):
                state.episodeDetails = EpisodeDetails.State(episodeUrl: episodeUrl)
                return .none
                
            case .episodeDetails:
                return .none
                
            case .favoriteButtonTapped:
                state.isFavorite.toggle()
                return .none
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetails()
        }
    }
}
