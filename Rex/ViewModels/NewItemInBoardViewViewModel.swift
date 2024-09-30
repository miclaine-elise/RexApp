//
//  NewItemViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemInBoardViewViewModel: ObservableObject {
@Published var name = ""
@Published var note = ""
@Published var link = ""
@Published var isTopFive = false
@Published var modifiedDate = Date()
@Published var createdDate = Date()
@Published var showAlert = false
@Published var nickname = ""
@Published var isPrivate = true

private let boardId : String
private let boardName : String

    init(boardId: String, boardName: String, nickname: String, isPrivate: Bool) {
        self.boardId = boardId
        self.boardName = boardName
        self.nickname = nickname
        self.isPrivate = isPrivate
    }

func saveItem(){
    guard canSave else {
        return
    }
    //Get current user id
    guard let uId = Auth.auth().currentUser?.uid else {
        return
    }
    //Create model
    let newId = UUID().uuidString
    let newItem = Item(
        id: newId,
        userId: uId,
        nickname: nickname,
        boardId: boardId,
        name: name,
        note: note,
        link: link,
        isTopFive: isTopFive,
        createdDate: Date().timeIntervalSince1970,
        modifiedDate: Date().timeIntervalSince1970
    )
    let newEventId = UUID().uuidString
    let newItemEvent = NewItemEvent(
        id: newEventId,
        userId: uId,
        itemId: newItem.id,
        boardId: boardId,
        nickname: nickname,
        boardName: boardName,
        isPrivate: isPrivate,
        eventDate: Date().timeIntervalSince1970,
        likes: []
    )
    
    //Save model
    let db = Firestore.firestore()
    
    db.collection("users")
        .document(uId)
        .collection("boards")
        .document(boardId)
        .collection("items")
        .document(newItem.id)
        .setData(newItem.asDictionary())
    if !newItemEvent.isPrivate {
        db.collection("users")
            .document(uId)
            .collection("newItemEvents")
            .document(newItemEvent.id)
            .setData(newItemEvent.asDictionary())
    }
}

var canSave: Bool {
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
        return false
    }
    return true
}

}
