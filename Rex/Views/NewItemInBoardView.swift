//
//  NewRecView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct NewItemInBoardView: View {
    @StateObject var viewModel: NewItemInBoardViewViewModel
    @Binding var newItemViewPresented: Bool

    
    init(newItemViewPresented: Binding<Bool>, boardId: String, boardName: String, nickname: String, isPrivate: Bool) {
        _newItemViewPresented = newItemViewPresented
        self._viewModel = StateObject(
            wrappedValue:
                NewItemInBoardViewViewModel(boardId: boardId, boardName: boardName, nickname: nickname, isPrivate: isPrivate)
        )
    }
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name", text: $viewModel.name)
                TextField("Notes", text: $viewModel.note, axis: .vertical)
                    .lineLimit(5...10)
                TextField("Link", text: $viewModel.link)

            }
            .scrollContentBackground(.hidden)

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButton {
                    newItemViewPresented = false
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.saveItem()
                    newItemViewPresented = false
                } label: {
                    Text("Create")
                        .foregroundColor(Color("TextColor"))
                        .bold()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("New Rex")
        .padding()
        }
    }
}

#Preview {
    NewItemInBoardView(newItemViewPresented:Binding(get: {
        return true
    }, set: { _ in
    }), boardId: "123", boardName: "Movies", nickname: "mic", isPrivate: false)
}
