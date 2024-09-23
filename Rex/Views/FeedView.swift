//
//  FeedView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel: FeedViewViewModel

    init(currentUserId: String) {
        self._viewModel = StateObject(
            wrappedValue: FeedViewViewModel(currentUserId: currentUserId)
        )
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileSearchView(currentUserId: viewModel.currentUserId, searchIsSelected: $viewModel.searchIsSelected)
                        .padding(.top)
                    if !viewModel.searchIsSelected {
                        ForEach(viewModel.combinedEvents) { event in
                            switch event {
                            case .board(let boardEvent):
                                NewBoardEventView(newBoardEvent: boardEvent, currentUserId: viewModel.currentUserId)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(4)
                            case .item(let itemEvent):
                                NewItemEventView(newItemEvent: itemEvent, currentUserId: viewModel.currentUserId)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(4)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("TextColor"))
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .background {
                Color("MainColor")
                    .ignoresSafeArea()
            }
        }
    }
}
