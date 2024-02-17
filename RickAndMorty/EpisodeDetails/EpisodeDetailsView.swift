//
//  EpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/17/24.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {
    @Perception.Bindable var store: StoreOf<EpisodeDetails>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                VStack(spacing: 16) {
                    if store.isLoading {
                        ProgressView()
                    } else if let episode = store.episode {
                        Text("\(episode.episode)")
                            .font(.title)
                            .bold()
                        Text("\(episode.name)")
                            .font(.title)
                            .multilineTextAlignment(.center)
                        VStack {
                            StatsRow(name: "Aired", value: episode.airDate)
                            StatsRow(name: "Featured characters", value: String(episode.characters.count))
                        }
                    } else {
                        Text("Error occured while loading data")
                        Button("Reload") {
                            store.send(.reloadButtonTapped)
                        }.buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .navigationTitle("Episode details")
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
                .onAppear {
                    if !store.isLoading {
                        store.send(.viewAppeared)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    EpisodeDetailsView(store: Store(initialState: EpisodeDetails.State(episodeUrl: "https://rickandmortyapi.com/api/episode/13"), reducer: {
        EpisodeDetails()
    }))
}
