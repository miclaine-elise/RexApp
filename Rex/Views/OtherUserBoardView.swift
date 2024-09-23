//
//  OtherUserBoardView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/31/24.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct OtherUserBoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel : BoardViewViewModel
    @State var keyword: String = ""
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
        ZStack{
            VStack{
                Text("\(board.nickname)'s \(board.name)")
                    .textCase(.uppercase)
                    .font(.custom("BebasNeue-Regular", size: 40))
                    .frame( maxWidth: .infinity,
                            alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 20)
                
               // OtherUserBoardSearchView(keyword: keywordBinding)
                OtherUserTopRexView(userId: viewModel.userId, board: board, isOwner: isOwner)
                OtherUserNotTopRexView(userId: viewModel.userId, board: board, isOwner: isOwner)
            }
            .background{Color("MainColor")
                    .ignoresSafeArea()
            }
        }
        .tint(Color("TextColor"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: OtherUserProfileView(otherUserId: board.userId)){
                        HStack {
                            if viewModel.imageProfileUrl != "" {
                                WebImage(url: URL(string: viewModel.imageProfileUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color("TextColor"))
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("TextColor"))
                                    .frame(width: 20, height: 20)
                                    .padding()
                            }
                        }
                    }
                }
                            ToolbarItem(placement: .navigationBarTrailing){
                                if(viewModel.savedBoards.contains(board.id)){
                                    Button {
                                        //viewModel.unsaveBoard()
                                    } label: {
                                        Image(systemName: "bookmark.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color("FunColor"))
                                    }                                } else {
                                Button {
                                    viewModel.saveBoard()
                                } label: {
                                    Image(systemName: "bookmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color("FunColor"))
                                }
                                }
                            }
                        }
                    }
    func didDismiss() {
        dismiss()    }
}

struct OtherUserBoardSearchView: View {
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
struct OtherUserTopRexView: View {
    @StateObject var viewModel : BoardViewViewModel
   // @State var draggedItem : Item?
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
                .frame(width: 20, height: 20)
                .foregroundColor(Color("FunColor"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        ZStack{
            Color("SecondaryColor")
            VStack{
                ForEach(viewModel.topFiveItems) { item in
                    NavigationLink(destination: OtherUserItemView(userId: viewModel.userId, item: item, isOwner: isOwner)){
                        ListItemView(item: item, isOwner: isOwner)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(id: item.id)
                                }.tint(.red)
                            }
                    }
                    Divider()
                }
                Spacer()
            }
            .padding(.top, 10)
            .cornerRadius(15)
            .frame(maxWidth: 350, minHeight: 226)
        }
        .cornerRadius(15)
        .frame(maxWidth: 350, minHeight: 226)
        .shadow(radius: 4, x: 3, y: 4)
        .dropDestination(for: Item.self) { droppedItems, location in
            viewModel.moveItem(items: droppedItems, isTopFive: true)
            return true
        }
    }
}
struct OtherUserNotTopRexView: View {
    @StateObject var viewModel : BoardViewViewModel
   // @State var draggedItem : Item?
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
        VStack{
            ForEach(viewModel.items) { item in
                NavigationLink(destination: OtherUserItemView(userId: viewModel.userId, item: item, isOwner: isOwner)){
                    ListItemView(item: item, isOwner: isOwner)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(id: item.id)
                            }.tint(.red)
                        }
                }

                Divider()
            }
            Spacer()
        }
        .padding(.top, 10)
        .frame(maxWidth: 350, minHeight: 300)
    }
}
#Preview {
    OtherUserBoardView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", board: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", name: "Movies", isPrivate: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970), isOwner: true)
}
