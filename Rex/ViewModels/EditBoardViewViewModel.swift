//
//  EditBoardViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class EditBoardViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var isPrivate = false
    @Published var modifiedDate = Date()
    @Published var showAlert = false
    private let board : Board
    let db = Firestore.firestore()

    init(board: Board) {
        self.board = board
        name = board.name
        isPrivate = board.isPrivate
        name = board.name
        isPrivate = isPrivate
    }
    
func saveBoard(){
    guard canSave else {
        return
    }
    //Get current user id
    guard let uId = Auth.auth().currentUser?.uid else {
        return
    }
    var boardCopy = board
    boardCopy.setName(name)
    boardCopy.setIsPrivate(isPrivate)
    boardCopy.setModifiedDate(Date().timeIntervalSince1970)
        
        db.collection("users")
            .document(uId)
            .collection("boards")
            .document(board.id)
            .setData(boardCopy.asDictionary())

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
        let boardRef = db.collection("users")
            .document(uId)
            .collection("boards")
            .document(board.id)
            
            // Delete the board itself after items are deleted
            boardRef.delete { error in
                if let error = error {
                    print("Failed to delete board: \(error)")
                } else {
                    print("Board successfully deleted")
                }
            }
        db.collection("users")
            .document(uId)
            .collection("newBoardEvents")
            .whereField("boardId", isEqualTo: board.id) // Query for documents where boardId matches
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
        db.collection("users")
            .document(uId)
            .collection("newItemEvents")
            .whereField("boardId", isEqualTo: board.id) // Query for documents where boardId matches
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
