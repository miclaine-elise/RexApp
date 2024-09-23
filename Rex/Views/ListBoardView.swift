//
//  BoardView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct ListBoardView: View {
    @StateObject var viewModel:  BoardViewViewModel

    let board: Board
    let isOwner: Bool
   // let topFiveItems : [Item]
    init(userId: String, board: Board, isOwner: Bool){
        self.board = board
        self.isOwner = isOwner
        self._viewModel = StateObject(
            wrappedValue:
                BoardViewViewModel(userId: userId, board: board)
        )
    }
    
    var body: some View {
                VStack(alignment: .leading){
                    HStack(alignment: .bottom){
                        Text(board.name)
                            .font(.system(size: 15))
                            .foregroundColor(Color("TextColor"))
                            .bold()
                            .offset(x:6, y:1)
                        if board.isPrivate {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 2)

                        }
                        Spacer()
                        Text("\(viewModel.items.count + viewModel.topFiveItems.count) rex")
                            .font(.system(size: 12))
                            .foregroundColor(Color("TextColor"))
                            .offset(x:-6, y:1)
                            .padding(.leading, 2)

                    }
                    .frame(height: 25, alignment: .leading)
                    .offset(y:10)
                    ZStack{
                        Color("SecondaryColor")
                        VStack{
                            if viewModel.topFiveItems.count == 0 {
                                Text("no rex in top 5")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.gray))
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ForEach(viewModel.topFiveItems) {item in
                                Text(item.name)
                                    .font(.subheadline)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                            }
                            Spacer()
                        }
                        .padding(.top, 6)
                    }
                        .cornerRadius(10)
                        .frame(minHeight: 10)
                        .shadow(radius: 4, x: 3, y: 4)
                    
                }
                .padding(.bottom, 3)

            }
        }
    

#Preview {
    ListBoardView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", board: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", name: "Movieees hh hhhh hh", isPrivate: true, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970), isOwner: true)
}
