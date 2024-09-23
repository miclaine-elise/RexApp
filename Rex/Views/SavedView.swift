//
//  SavedRexView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import SwiftUI

struct SavedView: View {
    @StateObject var viewModel:  SavedViewViewModel

    private let fixedColumn = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    init(userId: String){
        self._viewModel = StateObject(
            wrappedValue:
                SavedViewViewModel(userId: userId)
        )
    }
    var body: some View {
        VStack{
            Menu("\(viewModel.selectedSavedView) \(Image(systemName: "chevron.down"))") {
                Button("Boards", action : {
                    viewModel.selectedSavedView = "Boards"
                })
                Button("Rex", action : {
                    viewModel.selectedSavedView = "Rex"
                })
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .overlay(RoundedRectangle(cornerRadius:20).stroke(Color("TextColor")))
            .bold()
            .padding(.leading)
            .padding(.trailing)
            VStack{
                if viewModel.selectedSavedView == "Boards" {
                    HStack(alignment: .top, spacing: 20) {
                        // Left Column
                        LazyVStack {
                            ForEach(viewModel.savedBoards.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                                NavigationLink(destination: OtherUserBoardView( userId: viewModel.savedBoards[index].userId, board: viewModel.savedBoards[index], isOwner: false)){
                                    ListBoardView(userId: viewModel.savedBoards[index].userId, board: viewModel.savedBoards[index], isOwner: false)
                                }
                            }
                        }
                        // Right Column
                        LazyVStack {
                            ForEach(viewModel.savedBoards.indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                                NavigationLink(destination: OtherUserBoardView( userId: viewModel.savedBoards[index].userId, board: viewModel.savedBoards[index], isOwner: false)){
                                    ListBoardView(userId: viewModel.savedBoards[index].userId, board: viewModel.savedBoards[index], isOwner: false)
                                }
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)

                } else {
                    VStack{
                        ForEach(viewModel.savedItems) { item in
                            NavigationLink(destination: ItemView( userId: item.userId, item: item, isOwner: false)){
                                SavedListItemView(item: item)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    SavedView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2")
}
