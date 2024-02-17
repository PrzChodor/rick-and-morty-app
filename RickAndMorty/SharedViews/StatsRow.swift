//
//  StatsRow.swift
//  RickAndMorty
//
//  Created by Przemyslaw Chodor on 2/17/24.
//

import SwiftUI

struct StatsRow: View {
    let name: String
    let value: String
    var maxNameWidth: Double = .infinity
    
    var body: some View {
        HStack(spacing: 2.0) {
            Text(name)
                .padding(10)
                .frame(maxWidth: maxNameWidth, maxHeight: .infinity)
                .background(.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
                Text(value)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(10)
                    .background(.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    StatsRow(name: "Name", value: "Value")
        .padding()
}
