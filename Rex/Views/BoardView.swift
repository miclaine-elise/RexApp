//
//  BoardView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/31/24.
//

import SwiftUI

struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel : BoardViewViewModel
    @State var keyword: String = ""
    @State var draggedItem : Item?
    
    let board: Board
    let isOwner: Bool
    init(userId: String, board: Board, isOwner: Bool){
        self.board = board
        self.isOwner = isOwner
        self._viewModel = StateObject(
            wrappedValue:
                BoardViewViewModel(userId: userId, board: board)
        )
    }
    var body: some View {
        let keywordBinding = Binding<String>(
            get: {
                keyword
            },
            set: {
                keyword = $0
                viewModel.searchItems(from: keyword)
            }
        )
        ScrollView{
//            ZStack{
                VStack{
                    Text("\(board.nickname)'s \(board.name)")
                        .textCase(.uppercase)
                        .font(.custom("BebasNeue-Regular", size: 40))
                        .frame( maxWidth: .infinity,
                                alignment: .leading)
                        .padding(.leading)
                        .padding(.top, 20)
                    
                   // BoardSearchView(keyword: keywordBinding)
                    TopRexView(userId: viewModel.userId, board: board, isOwner: isOwner)
                    NotTopRexView(userId: viewModel.userId, board: board, isOwner: isOwner)
                }
                //                Spacer()
//                .background{Color("MainColor")
//                        .ignoresSafeArea()
//                }
 //           }
            .tint(Color("TextColor"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        viewModel.showingNewItemView = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("FunColor"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        viewModel.showingEditBoardView = true
                    } label: {
                        Text("...")
                            .foregroundColor(Color("FunColor"))
                            .bold()
                            .frame(width: 20, height: 20)
                            .font(.system(size: 30))
                            .offset(y: -8)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemInBoardView(newItemViewPresented: $viewModel.showingNewItemView, boardId: board.id, boardName: board.name, nickname: board.nickname, isPrivate: board.isPrivate)
            }
            .sheet(isPresented: $viewModel.showingEditBoardView, onDismiss: didDismiss) {
                EditBoardView(editBoardViewPresented: $viewModel.showingEditBoardView, board: board)
            }
        }
        .background{Color("MainColor")
                .ignoresSafeArea()
        }
    }
        func didDismiss() {
            dismiss()
        }
    }

struct BoardSearchView: View {
    @Binding var keyword: String
    
    var body: some View {
        
        TextField("Search", text: $keyword)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("TextColor"))
            )
            .frame( maxWidth: 350)
    }
}
struct TopRexView: View {
    @StateObject var viewModel : BoardViewViewModel
    @State var draggedItem : Item?
    @State private var showLimitAlert = false

    let board: Board
    let isOwner: Bool
    init(userId: String, board: Board, isOwner: Bool){
        self.board = board
        self.isOwner = isOwner
        self._viewModel = StateObject(
            wrappedValue:
                BoardViewViewModel(userId: userId, board: board)
        )}
    
    var body: some View {
        
        HStack{
            Text("TOP REX")
                .font(.custom("BebasNeue-Regular", size: 30))
                .frame(minHeight: 30,
                       alignment: .leading)
                .padding(.leading)
                .padding(.top)
            Image(systemName: "circle.fill")
                .resizable()
                .offset(y: 5)
                .frame(width: 20, height: 20)
                .foregroundColor(Color("FunColor"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        ZStack{
            Color("SecondaryColor")
            VStack {
                ForEach(viewModel.topFiveItems.indices, id: \.self) { index in
                    let item = viewModel.topFiveItems[index]
                    NavigationLink(destination: ItemView(userId: viewModel.userId, item: item, isOwner: isOwner)) {
                        ListItemView(item: item, isOwner: isOwner)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(id: item.id)
                                }.tint(.red)
                            }
                            .draggable(item)
                    }
                    // Add Divider except for the last item
                    if index != viewModel.topFiveItems.count - 1 {
                        Divider()
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .cornerRadius(15)
            .frame(maxWidth: 350, minHeight: 230)

        }
        .cornerRadius(15)
        .frame(height: 226)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .shadow(radius: 4, x: 3, y: 4)
        .dropDestination(for: Item.self) { droppedItems, location in
            // Ensure we only add if there are less than 5 items
            if viewModel.topFiveItems.count < 5 {
                viewModel.moveItem(items: droppedItems, isTopFive: true)
                return true
            } else {
                // Show an alert when the limit is reached
                showLimitAlert = true
                return false
            }
        }
//        .alert(isPresented: $showLimitAlert) {
//            Alert(
//                title: Text("Limit Reached"),
//                message: Text("You are limited to 5 top rex"),
//                dismissButton: .default(Text("OK"))
//            )
//        
//        }
    }
}
struct NotTopRexView: View {
    @StateObject var viewModel: BoardViewViewModel
    @State var draggedItem: Item?
    let board: Board
    let isOwner: Bool

    init(userId: String, board: Board, isOwner: Bool) {
        self.board = board
        self.isOwner = isOwner
        self._viewModel = StateObject(
            wrappedValue: BoardViewViewModel(userId: userId, board: board)
        )
    }

    var body: some View {
            ZStack {
                Color("MainColor")
                
                VStack {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: ItemView(userId: viewModel.userId, item: item, isOwner: isOwner)) {
                            ListItemView(item: item, isOwner: isOwner)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(id: item.id)
                                    }
                                    .tint(.red)
                                }
                                .draggable(item)
                        }
                        Divider()
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .frame(minHeight: 500, alignment: .top)
            .dropDestination(for: Item.self) { droppedItems, location in
                viewModel.moveItem(items: droppedItems, isTopFive: false)
                return true
        }
    }
}

#Preview {
    BoardView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", board: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", name: "Movies", isPrivate: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970), isOwner: true)
}
