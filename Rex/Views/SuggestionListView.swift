//
//  SuggestionListView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import SwiftUI

struct SuggestionListView: View {
    let suggestion: Suggestion
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Text(suggestion.name)
                    .font(.system(size: 15))
                    .bold()
                Spacer()
                if suggestion.suggestedBy != ""{
                    Text("\(suggestion.type) by \(suggestion.suggestedBy)")
                        .font(.system(size: 10))
                }
            }
            Text("\(suggestion.note)")
                .font(.system(size: 15))
        }
        .padding()
        .frame(alignment: .leading )
        .foregroundColor(Color("TextColor"))
        .background(Color("SecondaryColor"))
        .cornerRadius(10)
        .shadow(radius: 4, x: 3, y: 4)
    
    }
}
#Preview {
    SuggestionListView(suggestion: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", name: "Moonrise Kingdom", type: "Movie", note: "So good", suggestedBy: "Brendan", link: "google.com", createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}
