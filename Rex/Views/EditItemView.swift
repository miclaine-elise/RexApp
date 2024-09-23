//
//  ItemEditView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditItemViewViewModel
    @Binding var editItemViewPresented: Bool
//    let item: Item
//    let boardId: String
    init(editItemViewPresented: Binding<Bool>, item: Item) {
        _editItemViewPresented = editItemViewPresented
//        self.item = item
//        self.boardId = boardId
        self._viewModel = StateObject(
            wrappedValue:
                EditItemViewViewModel(item: item)
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

            Button ("Delete") {
                viewModel.delete()
                editItemViewPresented = false
                dismiss()
            }
            .bold()
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButton {
                    editItemViewPresented = false
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.saveItem()
                    editItemViewPresented = false
                } label: {
                    Text("Save")
                        .foregroundColor(Color("TextColor"))
                        .bold()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Rex")
        .padding()
        }
    }
}

#Preview {
    EditItemView(editItemViewPresented:Binding(get: {
        return true
    }, set: { _ in
    }), item: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", boardId: "123", name: "Moonrise Kingdom", note: "So go000 00000ooo ooooooooooo00 0000000000000000000000od", link: "google.com", isTopFive: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}
