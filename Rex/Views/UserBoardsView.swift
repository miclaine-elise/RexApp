//
//  UserBoardsView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import SwiftUI

struct UserBoardsView: View {
    @StateObject var viewModel: UserBoardsViewViewModel

    init(userId: String, nickname: String) {
        self._viewModel = StateObject(
            wrappedValue: UserBoardsViewViewModel(userId: userId, nickname: nickname)
        )
    }

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search", text: $viewModel.searchBoards)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("TextColor"))
                    )
            }
            .padding(.leading)
            .padding(.trailing)

            // Boards Display
            HStack(alignment: .top, spacing: 20) {
                // Left Column
                LazyVStack {
                    ForEach(viewModel.filteredBoards.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                        NavigationLink(destination: BoardView(userId: viewModel.userId, board: viewModel.filteredBoards[index], isOwner: true)) {
                            ListBoardView(
                                userId: viewModel.userId,
                                board: viewModel.filteredBoards[index],
                                isOwner: true
                            )
                            .id(viewModel.filteredBoards[index].id)
                        }
                    }
                }

                // Right Column
                LazyVStack {
                    ForEach(viewModel.filteredBoards.indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                        NavigationLink(destination: BoardView(userId: viewModel.userId, board: viewModel.filteredBoards[index], isOwner: true)) {
                            ListBoardView(
                                userId: viewModel.userId,
                                board: viewModel.filteredBoards[index],
                                isOwner: true
                            )
                            .id(viewModel.filteredBoards[index].id) // Force re-render
                        }
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}



#Preview {
    UserBoardsView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "Mic")
}
