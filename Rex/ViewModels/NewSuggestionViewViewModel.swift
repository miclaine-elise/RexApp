//
//  NewNoteViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewSuggestionViewViewModel: ObservableObject {
@Published var name = ""
@Published var type = ""
@Published var note = ""
@Published var link = ""
@Published var suggestedBy = ""
@Published var modifiedDate = Date()
@Published var createdDate = Date()
@Published var showAlert = false
@Published var nickname = ""
@Published var newSuggestion : Suggestion?

public let userId : String


    init(userId: String) {
        self.userId = userId
    }
func saveSuggestion(){
    guard canSave else {
        return
    }
    //Create model
    let newId = UUID().uuidString
    newSuggestion = Suggestion(
        id: newId,
        userId: userId,
        name: name,
        type: type,
        note: note,
        suggestedBy: suggestedBy,
        link: link,
        createdDate: Date().timeIntervalSince1970,
        modifiedDate: Date().timeIntervalSince1970
    )
    //Save model
    let db = Firestore.firestore()
    
    db.collection("users")
        .document(userId)
        .collection("suggestions")
        .document(newId)
        .setData(newSuggestion.asDictionary())
}

var canSave: Bool {
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
        return false
    }
    return true
}

}
