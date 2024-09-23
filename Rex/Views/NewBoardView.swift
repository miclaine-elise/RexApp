//
//  NewBoardView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct NewBoardView: View {
    @StateObject var viewModel: NewBoardViewViewModel
    @Environment(\.presentationMode) var presentationMode
    var isDirectNavigation: Bool = false
    @State private var isBoardSaved: Bool = false
    @State private var createdBoard: Board?
    var onSave: (Board) -> Void
    
    init(userId: String, nickname: String, isDirectNavigation: Bool, onSave: @escaping (Board) -> Void) {
        self._viewModel = StateObject(wrappedValue: NewBoardViewViewModel(userId: userId, nickname: nickname))
        self.isDirectNavigation = isDirectNavigation
        self.onSave = onSave
    }
    
    var body: some View {
        VStack {
            Text("New Board")
                .padding(.leading)
                .bold()
                .font(.custom("BebasNeue-Regular", size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                TextField("Board Name", text: $viewModel.name)

                Toggle("Make this board private", isOn: $viewModel.isPrivate)
                    .tint(.gray)
            }
            .background { Color("SecondaryColor") }
            .cornerRadius(15)
            .listStyle(.plain)
            .shadow(radius: 4, x: 3, y: 4)
            .padding(.bottom)

            Button {
                viewModel.saveBoard()
                if let newBoard = viewModel.newBoard {
                    self.isBoardSaved = true
                    self.createdBoard = newBoard
                    viewModel.name = ""
                    onSave(newBoard)
                }
            } label: {
                Text("Create")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .background(Color("FunColor"))
                    .cornerRadius(20)
                    .shadow(radius: 4, x: 3, y: 4)

            }
            .padding()
            if let board = createdBoard {
                NavigationLink(destination: BoardView(userId: viewModel.userId, board: board, isOwner: true), isActive: $isBoardSaved) {
                    EmptyView()
                }
            }
        }
        .padding()
        .background { Color("MainColor").ignoresSafeArea() }
    }
}


