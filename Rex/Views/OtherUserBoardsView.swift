//
//  OtherUserBoardsView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/14/24.
//

import SwiftUI

struct OtherUserBoardsView: View {
    @StateObject var viewModel:  OtherUserBoardsViewViewModel
    let user: User
    init(user: User){
        self.user = user
        self._viewModel = StateObject(
            wrappedValue:
                OtherUserBoardsViewViewModel(user: user)
        )
    }
//    private let fixedColumn = [
//        GridItem(.fixed(200)),
//        GridItem(.fixed(200))
//    ]
//    var body: some View {
//        HStack {
//            TextField("Search", text: $viewModel.searchBoards)
//                .padding(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color("TextColor"))
//                )
//            Button {
//                //Action
//            } label: {
//                Image(systemName: "plus")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(Color("FunColor"))
//            }
//        }
//        LazyVGrid(columns: fixedColumn, spacing: 20) {
//            ForEach(viewModel.boards) { board in
//                NavigationLink(destination: OtherUserBoardView( userId: user.id, board: board, isOwner: false)){
//                    ListBoardView(userId: user.id, board: board, isOwner: false)
//                }
//            }
//        }
//    }
//}


//#Preview {
//    OtherUserBoardsView()
//}


    var body: some View {
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
        HStack(alignment: .top, spacing: 20) {
            // Left Column
            LazyVStack {
                ForEach(viewModel.filteredBoards.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                    NavigationLink(destination: OtherUserBoardView( userId: user.id, board: viewModel.filteredBoards[index], isOwner: false)){
                        ListBoardView(userId: user.id, board: viewModel.filteredBoards[index], isOwner: false)
                    }
                }
            }
            
            // Right Column
            LazyVStack {
                ForEach(viewModel.filteredBoards.indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                    NavigationLink(destination: OtherUserBoardView( userId: user.id, board: viewModel.filteredBoards[index], isOwner: false)){
                        ListBoardView(userId: user.id, board: viewModel.filteredBoards[index], isOwner: false)
                    }
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)

    }
}
