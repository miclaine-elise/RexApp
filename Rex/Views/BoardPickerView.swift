//
//  BoardPickerView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/17/24.
//

import SwiftUI

struct BoardPickerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingNewBoardView = false
    var boards: [Board]
    @Binding var selectedBoardId: String
    @Binding var selectedBoardName: String
    let userId: String
    let nickname: String
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading){
                    Text("Save to board")
                        .font(.custom("BebasNeue-Regular", size: 30))
                        .padding()
                    Button(action: {
                        showingNewBoardView = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("FunColor"))
                            Text("Create New Board")
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding()
                        Divider()
                    }
                    VStack {
                        ForEach(boards) { board in
                            Button(action: {
                                selectedBoardId = board.id
                                selectedBoardName = board.name
                                dismiss()
                            }) {
                                VStack(alignment: .leading){
                                    Text(board.name)
                                        .font(.system(size: 20))
                                        .bold()
                                        .padding(5)
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background{Color("MainColor")
            .ignoresSafeArea()}
            .sheet(isPresented: $showingNewBoardView) {
                NewBoardView(userId: userId, nickname: nickname, isDirectNavigation: false, onSave: { newBoard in
                    selectedBoardId = newBoard.id
                    selectedBoardName = newBoard.name
                    dismiss()
                })
            }
        

    }
}
