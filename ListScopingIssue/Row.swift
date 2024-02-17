//
//  Row.swift
//  ListScopingIssue
//
//  Created by Denys Danyliuk on 18.02.2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RowFeature: Reducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        var counter: Int = 0
    }
    
    enum Action: Equatable {
        case increment
        case decrement
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.counter += 1
                return .none
                
            case .decrement:
                state.counter -= 1
                return .none
            }
        }
    }
}

struct RowView: View {
    let store: StoreOf<RowFeature>
    
    var body: some View {
        VStack(alignment: .center) {
            Text(store.id.uuidString)
                .font(.system(.caption2))
            
            Text("Count: \(store.counter)")
            
            HStack {
                Button("Decrement") { store.send(.decrement) }
                    .buttonStyle(.borderedProminent)
                
                Button("Increment") { store.send(.increment) }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
