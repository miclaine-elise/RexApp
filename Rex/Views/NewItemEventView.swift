//
//  NewRexEventView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/21/24.
//

import SwiftUI

struct NewItemEventView: View {
    @StateObject var viewModel: NewItemEventViewViewModel
    init(newItemEvent: NewItemEvent, currentUserId: String){
        self._viewModel = StateObject(
            wrappedValue:
                NewItemEventViewViewModel(currentUserId: currentUserId, newItemEvent: newItemEvent)
        )
    }
    var body: some View {
        ZStack{
            Color("SecondaryColor")

        VStack (alignment: .leading) {
            NavigationLink(destination: ItemView(userId: viewModel.newItemEvent.userId, item: viewModel.eventItemFetched, isOwner: false)){
                VStack{
                    HStack{
                        Text("\(viewModel.newItemEvent.nickname) added a new rex, \(Text(viewModel.eventItemFetched.name).bold()), to \(viewModel.newItemEvent.boardName)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if viewModel.eventItemFetched.note != "" {
                        Text("\(viewModel.eventItemFetched.note)")
                            .font(.system(size: 15))
                           // .foregroundColor(Color(.gray))
                            .padding(2)
                    }
                }
            }
            HStack{
                if(viewModel.newItemEvent.likes.contains(viewModel.currentUserId)){
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
                if viewModel.newItemEvent.likes.count == 0 {
                    Text(" ")
                } else if viewModel.newItemEvent.likes.count == 1 {
                    Text("\(viewModel.newItemEvent.likes.count) like")
                } else {
                    Text("\(viewModel.newItemEvent.likes.count) likes")
                }
            }
        }
        .padding()
    }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
       // .overlay(RoundedRectangle(cornerRadius:10).stroke(Color("TextColor"), lineWidth: 0.5))
        .shadow(radius: 4, x: 3, y: 4)

    }
}

#Preview {
    NewItemEventView(newItemEvent: .init(id:"123", userId: "123", itemId: "123", boardId: "123", nickname: "mikey", boardName: "Movies", isPrivate: false, eventDate: Date().timeIntervalSince1970, likes: ["123"]), currentUserId: "123")
}



