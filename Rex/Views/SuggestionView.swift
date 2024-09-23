//
//  NotesView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import SwiftUI

struct SuggestionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SuggestionViewViewModel
    let suggestion: Suggestion
    
    init(userId: String, suggestion: Suggestion){
        self.suggestion = suggestion
        self._viewModel = StateObject(
            wrappedValue:
                SuggestionViewViewModel(userId: userId, suggestion: suggestion)
        )
    }
    
    var body: some View {
        ZStack{
            Color(Color("MainColor"))
                .ignoresSafeArea()
            VStack{
                VStack(alignment: .leading){
                    Text(suggestion.name)
                        .font(.custom("BebasNeue-Regular", size: 40))

                    if suggestion.suggestedBy != ""{
                        Text("\(suggestion.type) by \(suggestion.suggestedBy)")
                            .font(.custom("BebasNeue-Regular", size: 20))
                    }
                }
                .padding(.top)
                .frame(maxWidth: 350, alignment: .leading)
                ZStack{
                    Color("SecondaryColor")
                        Text(suggestion.note)
                    .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
                .cornerRadius(15)
                .frame(maxWidth: 350)
                .shadow(radius: 4, x: 3, y: 4)
                Spacer()
                ZStack{
                    if suggestion.link.isEmpty == false {
                        Color(Color("FunColor"))
                        Link("Visit",
                             destination: URL(string: "\(suggestion.link)")!)
                        .bold()
                        .foregroundColor(.white)
                    }
                }
                .cornerRadius(20)
                .frame(maxWidth: 100, maxHeight: 50)
                .shadow(radius: 4, x: 3, y: 4)
                .padding()
            }

            }
        .toolbar {
            Button {
                //Action
                viewModel.showingEditSuggestionView = true
            } label: {
                Text("...")
                    .foregroundColor(Color("FunColor"))
                    .bold()
                    .font(.system(size: 30))
            }
        }
        .sheet(isPresented: $viewModel.showingEditSuggestionView, onDismiss: didDismiss) {
            EditSuggestionView(editSuggestionViewPresented: $viewModel.showingEditSuggestionView, suggestion: suggestion)
        }
    }
    func didDismiss() {
        dismiss()    }

}

#Preview {
    SuggestionView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", suggestion: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", name: "Moonrise Kingdom", type: "Movie", note: "So go000 00000ooo ooooooooooo00 0000000000000000000000od", suggestedBy: "Brendan", link: "google.com", createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}

