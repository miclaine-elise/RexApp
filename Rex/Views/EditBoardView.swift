//
//  EditBoardView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import SwiftUI

struct EditBoardView: View {
    @StateObject var viewModel: EditBoardViewViewModel
    @Binding var editBoardViewPresented: Bool

    init(editBoardViewPresented: Binding<Bool>, board: Board) {
        _editBoardViewPresented = editBoardViewPresented
        self._viewModel = StateObject(
            wrappedValue:
                EditBoardViewViewModel(board: board)
        )
    }
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name", text: $viewModel.name)
                Toggle("Make this board private", isOn: $viewModel.isPrivate)
                    .tint(.gray)
            }
            .scrollContentBackground(.hidden)

                Button ("Delete") {
                    viewModel.delete()
                    editBoardViewPresented = false
                }
                .foregroundColor(.white)
                .bold()
                .padding()
                .background(.black)
                .cornerRadius(20)

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CloseButton {
                        editBoardViewPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        viewModel.saveBoard()
                        editBoardViewPresented = false
                    } label: {
                        Text("Save")
                            .foregroundColor(Color("TextColor"))
                            .bold()
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Board")
            .padding()
        }
    }
}

#Preview {
    EditBoardView(editBoardViewPresented:Binding(get: {
        return true
    }, set: { _ in
    }), board: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", name: "Movies", isPrivate: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}

