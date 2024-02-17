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
                if !store.characters.isEmpty {
                    List {
                        ForEach(store.characters, id: \.id) { character in
                            WithPerceptionTracking {
                                HStack {
                                    AsyncImage(url: URL(string: character.image)) { image in
                                        image.resizable()
                                            .clipShape(.circle)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 64, height: 64)
                                    
                                    Button {
                                        store.send(.characterSelected(character))
                                    } label: {
                                        Text(character.name)
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                    Button {
                                        store.send(.favoritesButtonTapped(character.id))
                                    } label: {
                                        if store.favoriteCharacters.contains(character.id) {
                                            Image(systemName: "heart.fill")
                                        } else {
                                            Image(systemName: "heart")
                                        }
                                    }
                                    .buttonStyle(.borderless)
                                }
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
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .sheet(item: $store.scope(state: \.characterDetails, action: \.characterDetails)) { store in
                CharacterDetailsView(store: store)
            }
            .onAppear {
                store.send(.viewAppeared)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CharacterListView(store: Store(initialState: CharacterList.State(), reducer: {
        CharacterList()
    }))
}
