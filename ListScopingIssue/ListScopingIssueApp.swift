//
//  ListScopingIssueApp.swift
//  ListScopingIssue
//
//  Created by Denys Danyliuk on 18.02.2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        @Presents var searchFeature: SearchFeature.State?
    }
    
    enum Action {
        case searchButtonTapped
        case searchFeature(PresentationAction<SearchFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .searchButtonTapped:
                state.searchFeature = .init()
                return .none
                
            case .searchFeature:
                return .none
            }
        }
        .ifLet(\.$searchFeature, action: \.searchFeature) {
            SearchFeature()
        }
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        VStack {
            Button("Open search") {
                store.send(.searchButtonTapped)
            }
        }
        .sheet(
            item: $store.scope(state: \.searchFeature, action: \.searchFeature)
        ) { store in
            SearchView(store: store)
        }
    }
}

@main
struct ListScopingIssueApp: App {
    @State var store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
