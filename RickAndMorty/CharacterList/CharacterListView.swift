//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import SwiftUI
import ComposableArchitecture

struct CharacterListView: View {
    @Perception.Bindable var store: StoreOf<CharacterList>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                VStack {
                    if !store.characters.isEmpty {
                        List {
                            ForEach(store.characters, id: \.id) { character in
                                WithPerceptionTracking {
                                    CharacterListTileView(
                                        character: character,
                                        isFavorite: store.favoriteCharacters.contains(character.id),
                                        onTileTap: { store.send(.characterSelected(character)) },
                                        onToggleFavorite: { store.send(.favoritesButtonTapped(character.id)) }
                                    )
                                }
                            }
                            
                            if store.nextPageUrl != nil {
                                if store.hasErrorOccured {
                                    Button {
                                        store.send(.loadMoreButtonTapped)
                                    } label: {
                                        Text("Load more")
                                            .frame(maxWidth: .infinity)
                                    }
                                } else {
                                    ProgressView().id(UUID())
                                        .onAppear {
                                            if !store.isLoading {
                                                store.send(.endOfPageReached)
                                            }
                                        }
                                }
                            }
                        }
                        .navigationTitle("Characters")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    store.send(.clearButtonTapped)
                                } label: {
                                    Text("Clear")
                                }
                            }
                        }
                    } else if !store.isLoading {
                        VStack(alignment: .center) {
                            Text("Press the button below to load character list")
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Load characters") {
                                store.send(.loadButtonTapped)
                            }.buttonStyle(.borderedProminent)
                        }
                    } else {
                        ProgressView()
                    }
                    
                    NavigationLink(item: $store.scope(state: \.characterDetails, action: \.characterDetails)) { store in
                        CharacterDetailsView(store: store)
                    } label: {
                        EmptyView()
                    }
                }
                .alert($store.scope(state: \.alert, action: \.alert))
                .onAppear {
                    store.send(.viewAppeared)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    CharacterListView(store: Store(initialState: CharacterList.State(), reducer: {
        CharacterList()
    }))
}
