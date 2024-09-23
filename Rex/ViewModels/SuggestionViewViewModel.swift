//
//  SuggestionViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class SuggestionViewViewModel: ObservableObject {
    @Published var showingEditSuggestionView = false
    
    public let userId : String
    public let suggestion: Suggestion
    let db = Firestore.firestore()
    
    init(userId: String, suggestion: Suggestion) {
        self.userId = userId
        self.suggestion = suggestion
    }
}
