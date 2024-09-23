//
//  EditSuggestionViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EditSuggestionViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var suggestedBy = ""
    @Published var type = ""
    @Published var note = ""
    @Published var link = ""
    @Published var modifiedDate = Date()
    @Published var showAlert = false
    private let suggestion : Suggestion
    let db = Firestore.firestore()

    init(suggestion: Suggestion) {
        self.suggestion = suggestion
        name = suggestion.name
        suggestedBy = suggestion.suggestedBy
        type = suggestion.type
        note = suggestion.note
        link = suggestion.link
    }
    
func saveSuggestion(){
    guard canSave else {
        return
    }
    //Get current user id
    guard let uId = Auth.auth().currentUser?.uid else {
        return
    }
    var suggestionCopy = suggestion
    suggestionCopy.setName(name)
    suggestionCopy.setSuggestedBy(suggestedBy)
    suggestionCopy.setType(type)
    suggestionCopy.setNote(note)
    suggestionCopy.setLink(link)
    suggestionCopy.setModifiedDate(Date().timeIntervalSince1970)
        
        db.collection("users")
            .document(uId)
            .collection("suggestions")
            .document(suggestionCopy.id)
            .setData(suggestionCopy.asDictionary())
}

var canSave: Bool {
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
        return false
    }
    return true
}

    func delete(){
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        db.collection("users")
            .document(uId)
            .collection("suggestions")
            .document(suggestion.id)
            .delete()
    }
}


