//
//  EditSuggestionView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import SwiftUI

struct EditSuggestionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditSuggestionViewViewModel
    @Binding var editSuggestionViewPresented: Bool
    init(editSuggestionViewPresented: Binding<Bool>, suggestion: Suggestion) {
        _editSuggestionViewPresented = editSuggestionViewPresented

        self._viewModel = StateObject(
            wrappedValue:
                EditSuggestionViewViewModel(suggestion: suggestion)
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
                editSuggestionViewPresented = false
                dismiss()
            }
            .bold()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButton {
                    editSuggestionViewPresented = false
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.saveSuggestion()
                    editSuggestionViewPresented = false
                } label: {
                    Text("Save")
                        .foregroundColor(Color("TextColor"))
                        .bold()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Suggestion")
        .padding()
        }
    }
}

#Preview {
    EditSuggestionView(editSuggestionViewPresented:Binding(get: {
        return true
    }, set: { _ in
    }), suggestion: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", name: "Moonrise Kingdom", type: "Movie", note: "So go000 00000ooo ooooooooooo00 0000000000000000000000od", suggestedBy: "brendan", link: "google.com", createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}

