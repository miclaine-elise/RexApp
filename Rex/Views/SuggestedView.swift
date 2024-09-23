//
//  SuggestedView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import SwiftUI

struct SuggestedView: View {
    @StateObject var viewModel:  SuggestedViewViewModel

    init(userId: String){
        self._viewModel = StateObject(
            wrappedValue:
                SuggestedViewViewModel(userId: userId)
        )
    }
    var body: some View {
        VStack{
            ForEach(viewModel.suggestions) { suggestion in
                NavigationLink(destination: SuggestionView( userId: suggestion.userId, suggestion:suggestion)){
                    SuggestionListView(suggestion: suggestion)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    SuggestedView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2")
}
