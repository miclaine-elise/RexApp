//
//  NewBoardViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewBoardViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var isPrivate = false
    @Published var modifiedDate = Date()
    @Published var createdDate = Date()
    @Published var showAlert = false
   // @Published var topFive = []
    public let userId: String
    private let nickname: String
    @Published var newBoard : Board?

    
    init(userId: String, nickname: String) {
        self.userId = userId
        self.nickname = nickname
        print(nickname)
    }
    func saveBoard(){
        guard canSave else {
            return
        }
        //Create model
        let newId = UUID().uuidString
        newBoard = Board(
            id: newId,
            userId: userId,
            nickname: nickname,
            name: name,
            isPrivate: isPrivate,
            createdDate: Date().timeIntervalSince1970,
            modifiedDate: Date().timeIntervalSince1970
        )
        let newEventId = UUID().uuidString
        let newBoardEvent = NewBoardEvent(
            id: newEventId,
            userId: userId,
            boardId: newId,
            nickname: nickname,
            isPrivate: isPrivate,
            eventDate: Date().timeIntervalSince1970,
            likes: []
        )
        //Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(newId)
            .setData(newBoard.asDictionary())
        if !newBoardEvent.isPrivate{
            db.collection("users")
                .document(userId)
                .collection("newBoardEvents")
                .document(newBoardEvent.id)
                .setData(newBoardEvent.asDictionary())
        }
    }
    
    var canSave: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
    
}
