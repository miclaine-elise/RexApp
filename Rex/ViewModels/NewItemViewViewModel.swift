//
//  NewItemViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject {
    @Published var error = ""
    @Published var name = ""
    @Published var note = ""
    @Published var link = ""
    @Published var isTopFive = false
    @Published var modifiedDate = Date()
    @Published var createdDate = Date()
    @Published var showAlert = false // Added for showing the alert
    @Published var nickname: String
    @Published var isPrivate = true
    @Published var selectedBoardId = ""
    @Published var boards = [Board]()
    @Published var showingNewBoardView = false
    @Published var newItem: Item?

    public let userId: String
    let db = Firestore.firestore()

    init(userId: String, nickname: String) {
        self.userId = userId
        self.nickname = nickname
        fetchBoards()
    }

    func fetchBoards() {
        db.collection("users")
            .document(userId)
            .collection("boards")
            .order(by: "modifiedDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching boards: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No boards found")
                    return
                }

                // Map documents to Board objects
                self.boards = documents.map { document in
                    let data = document.data()
                    return Board(
                        id: data["id"] as? String ?? "",
                        userId: data["userId"] as? String ?? "",
                        nickname: data["nickname"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        isPrivate: data["isPrivate"] as? Bool ?? false,
                        createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                        modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                    )
                }
            }
    }


    // Updated canSave logic
    func saveItem() {
        guard canSave else {
            showAlert = true // Show alert when save is not possible
            return
        }
        
        let selectedBoard = boards.first { $0.id == selectedBoardId }
        print(selectedBoardId)
        if let board = selectedBoard {
            let newId = UUID().uuidString
            newItem = Item(
                id: newId,
                userId: userId,
                nickname: nickname,
                boardId: board.id,
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
                userId: userId,
                itemId: newId,
                boardId: board.id,
                nickname: nickname,
                boardName: board.name,
                isPrivate: isPrivate,
                eventDate: Date().timeIntervalSince1970,
                likes: []
            )
            db.collection("users")
                .document(userId)
                .collection("boards")
                .document(board.id)
                .collection("items")
                .document(newId)
                .setData(newItem!.asDictionary())
            if !board.isPrivate{
                db.collection("users")
                    .document(userId)
                    .collection("newItemEvents")
                    .document(newItemEvent.id)
                    .setData(newItemEvent.asDictionary())
            }
        } else {
            showAlert = true // Show alert if no board is selected
        }
    }

    var canSave: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Please enter a name"
            return false
        }

        guard !selectedBoardId.isEmpty else {
            error = "Please select a board"
            return false
        }
        
        return true
    }
}
