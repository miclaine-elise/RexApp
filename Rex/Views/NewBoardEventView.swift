//
//  FeedEventView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/15/24.
//

import SwiftUI

struct NewBoardEventView: View {
    @StateObject var viewModel: NewBoardEventViewViewModel
    init(newBoardEvent: NewBoardEvent, currentUserId: String){
        self._viewModel = StateObject(
            wrappedValue:
                NewBoardEventViewViewModel(currentUserId: currentUserId, newBoardEvent: newBoardEvent)
        )
    }
    var body: some View {
        ZStack{
            Color("SecondaryColor")
            VStack (alignment: .leading) {
                if viewModel.newBoardEvent.userId != viewModel.currentUserId {
                    NavigationLink(destination: OtherUserBoardView(userId: viewModel.newBoardEvent.userId, board: viewModel.eventBoardFetched, isOwner: false)){
                        HStack{
                            Text("\(viewModel.newBoardEvent.nickname) created a new board, \(viewModel.eventBoardFetched.name)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                } else {
                    NavigationLink(destination: BoardView(userId: viewModel.newBoardEvent.userId, board: viewModel.eventBoardFetched, isOwner: true)){
                        HStack{
                            Text("\(viewModel.newBoardEvent.nickname) created a new board, \(Text(viewModel.eventBoardFetched.name).bold())")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }
                HStack{
                    if(viewModel.newBoardEvent.likes.contains(viewModel.currentUserId)){
                        Button {
                            viewModel.unlikeEvent()
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color("FunColor"))
                        }
                    } else {
                        Button {
                            viewModel.likeEvent()
                        } label: {
                            Image(systemName: "heart")
                        }
                    }
                    if viewModel.newBoardEvent.likes.count == 0 {
                        Text(" ")
                    } else if viewModel.newBoardEvent.likes.count == 1 {
                        Text("\(viewModel.newBoardEvent.likes.count) like")
                    } else {
                        Text("\(viewModel.newBoardEvent.likes.count) likes")
                    }
                }
            }
            .padding()
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        //.overlay(RoundedRectangle(cornerRadius:10).stroke(Color("TextColor"), lineWidth: 0.5))
        .shadow(radius: 4, x: 3, y: 4)
    }
}

#Preview {
    NewBoardEventView(newBoardEvent: .init(id:"123", userId: "123", boardId: "123", nickname: "", isPrivate: false, eventDate: Date().timeIntervalSince1970, likes: []), currentUserId: "123")
}


