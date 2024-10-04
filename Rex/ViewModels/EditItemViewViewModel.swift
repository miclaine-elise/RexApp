//
//  EditItemViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EditItemViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var note = ""
    @Published var link = ""
    @Published var modifiedDate = Date()
    @Published var showAlert = false
    private let item : Item
    let db = Firestore.firestore()

    init(item: Item) {
        self.item = item
        name = item.name
        note = item.note
        link = item.link
    }
    
func saveItem(){
    guard canSave else {
        return
    }
    //Get current user id
    guard let uId = Auth.auth().currentUser?.uid else {
        return
    }
    var itemCopy = item
    itemCopy.setName(name)
    itemCopy.setNote(note)
    itemCopy.setLink(link)
    itemCopy.setModifiedDate(Date().timeIntervalSince1970)
        
        db.collection("users")
            .document(uId)
            .collection("boards")
            .document(item.boardId)
            .collection("items")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
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
            .collection("boards")
            .document(item.boardId)
            .collection("items")
            .document(item.id)
            .delete()
        
        db.collection("users")
            .document(uId)
            .collection("newItemEvents")
            .whereField("itemId", isEqualTo: item.id) // Query for documents where boardId matches
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Failed to fetch newBoardEvents for deletion: \(error)")
                    return
                }

                // Delete each document in the newBoardEvents collection that matches the query
                querySnapshot?.documents.forEach { document in
                    document.reference.delete { error in
                        if let error = error {
                            print("Failed to delete newBoardEvent \(document.documentID): \(error)")
                        } else {
                            print("newBoardEvent \(document.documentID) successfully deleted")
                        }
                    }
                }
            }
    }
}

