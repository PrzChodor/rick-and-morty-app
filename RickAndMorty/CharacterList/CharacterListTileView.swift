//
//  CharacterListTileView.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/18/24.
//

import SwiftUI

struct CharacterListTileView: View {
    let character: Character
    let isFavorite: Bool
    let onTileTap: () -> ()
    let onToggleFavorite: () -> ()
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .clipShape(.circle)
            .frame(width: 64, height: 64)
            
            Button {
                onTileTap()
            } label: {
                Text(character.name)
                    .padding()
            }
            
            Spacer()
            
            Button {
                onToggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
            .imageScale(.large)
            .foregroundColor(.red)
            .buttonStyle(.borderless)
            
            Image(systemName: "chevron.right")
                .padding(.leading)
                .opacity(0.3)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    CharacterListTileView(character: .mock, isFavorite: false, onTileTap: {}, onToggleFavorite: {})
}
