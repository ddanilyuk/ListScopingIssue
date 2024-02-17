//
//  SearchFeature.swift
//  ListScopingIssue
//
//  Created by Denys Danyliuk on 18.02.2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var rows: IdentifiedArrayOf<RowFeature.State>
        
        init() {
            @Dependency(\.uuid) var uuid
            let array = (0..<1_000).map { _ in
                RowFeature.State(id: uuid())
            }
            rows = IdentifiedArray(uniqueElements: array)
        }
    }
    
    enum Action {
        case rows(IdentifiedActionOf<RowFeature>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .rows:
                return .none
            }
        }
        .forEach(\.rows, action: \.rows) {
            RowFeature()
        }
    }
}

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    
    var body: some View {
        VStack {
            Text("Search")
            
            List {
                ForEach(
                    store.scope(state: \.rows, action: \.rows),
                    id: \.state.id
                ) { childStore in
                    RowView(store: childStore)
                }
            }
        }
    }
}
