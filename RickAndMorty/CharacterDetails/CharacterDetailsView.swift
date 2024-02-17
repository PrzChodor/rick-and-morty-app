//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    @Perception.Bindable var store: StoreOf<CharacterDetails>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                Form {
                    let character = store.character
                    Section {
                        VStack {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                                    .clipShape(.circle)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                            
                            Text(character.name)
                                .font(.title)
                                .padding(.bottom)
                            StatsRow(name: "Status", value: character.status, maxNameWidth: 100)
                            StatsRow(name: "Gender", value: character.gender, maxNameWidth: 100)
                            StatsRow(name: "Origin", value: character.origin.name, maxNameWidth: 100)
                            StatsRow(name: "Location", value: character.location.name, maxNameWidth: 100)
                                .padding(.bottom)
                        }
                        
                    }
                    Section("Featured in episodes") {
                        ForEach(character.episode, id: \.self) { episodeUrl in
                            let episodeNumber = episodeUrl.filter("0123456789".contains)
                            Button {
                                store.send(.episodeSelected(episodeUrl))
                            } label: {
                                Text("Episode \(episodeNumber)")
                            }
                        }
                    }
                }
                .navigationTitle("Character details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            store.send(.closeButtonTapped)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                .sheet(item: $store.scope(state: \.episodeDetails, action: \.episodeDetails)) { store in
                    EpisodeDetailsView(store: store)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    CharacterDetailsView(store: Store(initialState: CharacterDetails.State(character: .mock), reducer: {
        CharacterDetails()
    }))
}
