//
//  CharacterList.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterList {
    @Dependency(\.characterClient) var characterClient
    private enum CancelID { case characterListRequest }
    private let baseUrl = "https://rickandmortyapi.com/api/character"
    private let defaults = UserDefaults.standard
    
    @ObservableState
    struct State {
        var nextPageUrl: String?
        var characters: [Character] = []
        var favoriteCharacters: [Character.ID] = []
        var isLoading: Bool = false
        var hasErrorOccured: Bool = false
        @Presents var characterDetails: CharacterDetails.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case clearButtonTapped
        case loadButtonTapped
        case endOfPageReached
        case loadMoreButtonTapped
        case viewAppeared
        case errorOccureed
        case favoritesButtonTapped(Character.ID)
        case charactersFetched(CharacterResponse)
        case characterSelected(Character)
        case characterDetails(PresentationAction<CharacterDetails.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert {
            case okButtonTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .clearButtonTapped:
                state.characters = []
                state.isLoading = false
                state.nextPageUrl = nil
                return .cancel(id: CancelID.characterListRequest)
                
            case .loadButtonTapped:
                return fetchCharacters(state: &state, url: baseUrl)
                
            case .endOfPageReached, .loadMoreButtonTapped:
                if let url = state.nextPageUrl {
                    return fetchCharacters(state: &state, url: url)
                }
                return .none
                
            case let .charactersFetched(response):
                state.nextPageUrl = response.info.next
                state.characters.append(contentsOf: response.results)
                state.isLoading = false
                return .none
                
            case let .characterSelected(character):
                state.characterDetails = CharacterDetails.State(character: character)
                return .none
                
            case .characterDetails:
                return .none
                
            case let .favoritesButtonTapped(id):
                if state.favoriteCharacters.contains(id) {
                    state.favoriteCharacters.removeAll { $0 == id }
                } else {
                    state.favoriteCharacters.append(id)
                }
                defaults.set(state.favoriteCharacters, forKey: "favorites")
                return .none
                
            case .viewAppeared:
                state.favoriteCharacters = defaults.array(forKey: "favorites") as? [Character.ID] ?? []
                return .none
                
            case .errorOccureed:
                state.isLoading = false
                state.hasErrorOccured = true
                state.alert = AlertState {
                    TextState("Error occured while loading data!\nTry again later.")
                } actions: {
                    ButtonState(action: .okButtonTapped) {
                        TextState("OK")
                    }
                }
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$characterDetails, action: \.characterDetails) {
            CharacterDetails()
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    func fetchCharacters(state: inout State, url: String) -> Effect<Action> {
        state.isLoading = true
        state.hasErrorOccured = false
        return .run { send in
            do {
                let response = try await self.characterClient.characterList(url)
                await send(.charactersFetched(response))
            } catch {
                await send(.errorOccureed)
            }
        }
        .cancellable(id: CancelID.characterListRequest)
    }
}
