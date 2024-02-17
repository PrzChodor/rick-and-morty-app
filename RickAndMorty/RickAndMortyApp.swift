//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/16/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickAndMortyApp: App {
    private static let store = Store(initialState: CharacterList.State()) {
        CharacterList()
    }
    
    var body: some Scene {
        WindowGroup {
            CharacterListView(store: RickAndMortyApp.store)
        }
    }
}
