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
    }

    enum Action {
        case episodeDetails(PresentationAction<EpisodeDetails.Action>)
        case episodeSelected(String)
        case closeButtonTapped
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
                
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetails()
        }
    }
}
