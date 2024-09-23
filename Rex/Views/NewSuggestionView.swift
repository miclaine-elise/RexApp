//
//  NewNoteView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import SwiftUI

struct NewSuggestionView: View {
    @StateObject var viewModel: NewSuggestionViewViewModel
    @State private var isSuggestionSaved: Bool = false
    @State private var createdSuggestion: Suggestion?
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue:
                NewSuggestionViewViewModel(userId: userId)
        )
    }

    var body: some View {
            VStack {
                    Text("New Suggestion")
                    .padding(.leading)
                        .bold()
                        .font(.custom("BebasNeue-Regular", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                List {
                    TextField("Name", text: $viewModel.name)
                    TextField("Type", text: $viewModel.type)
                    TextField("Suggested By", text: $viewModel.suggestedBy)
                    TextField("Notes", text: $viewModel.note, axis: .vertical)
                        .lineLimit(5...10)
                    TextField("Link", text: $viewModel.link)
                }
                .background{Color("SecondaryColor")}
                .listStyle(.plain)
                .cornerRadius(15)
                .shadow(radius: 4, x: 3, y: 4)
                .padding(.bottom)
                Button {
                    viewModel.saveSuggestion()
                    if let newSuggestion = viewModel.newSuggestion {
                        self.createdSuggestion = viewModel.newSuggestion
                        self.isSuggestionSaved = true
                        viewModel.name = ""
                        viewModel.note = ""
                        viewModel.link = ""
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

            if let createdSuggestion = createdSuggestion {
                NavigationLink(destination:
                                SuggestionView(userId: viewModel.userId, suggestion: createdSuggestion), isActive: $isSuggestionSaved){
                    EmptyView()
                }
            }
        }
        .padding()
        .background{Color("MainColor")                .ignoresSafeArea()}
    }
}

#Preview {
    NewSuggestionView(userId:"123")
}
