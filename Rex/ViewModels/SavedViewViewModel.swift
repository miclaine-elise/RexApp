//
//  SavedRexViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import Foundation
import FirebaseFirestore

class SavedViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var searchSaved = ""
    @Published var selectedSavedView = "Boards"
    @Published var savedBoards = [Board]()
    @Published var savedItems = [Item]()
    public let userId : String
    let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
        fetchSavedBoards()
        fetchSavedItems()
    }
    func fetchSavedBoards(){
        db.collection("users")
            .document(userId)
            .collection("savedBoards")
            .order(by: "modifiedDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                return
                }
                querySnapshot?.documentChanges.forEach({change in
                    if change.type == .added {
                        let data = change.document.data()
                        let board = Board(
                            id: data["id"] as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            nickname: data["nickname"] as? String ?? "",
                            name: data["name"] as? String ?? "",
                            isPrivate: data["isPrivate"] as? Bool ?? false,
                            createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                            modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                        )
                        self.savedBoards.append(board)
                    }
                        if change.type == .removed {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.savedBoards = self.savedBoards.filter {$0.id != id}
                        }
                        if change.type == .modified {
                            let data = change.document.data()
                            let board = Board(
                                id: data["id"] as? String ?? "",
                                userId: data["userId"] as? String ?? "",
                                nickname: data["nickname"] as? String ?? "",
                                name: data["name"] as? String ?? "",
                                isPrivate: data["isPrivate"] as? Bool ?? false,
                                createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                                )
                                self.savedBoards.append(board)
                        }
                    })
                }
            }

    func fetchSavedItems(){
        db.collection("users")
            .document(userId)
            .collection("savedItems")
            .order(by: "modifiedDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                return
                }
                querySnapshot?.documentChanges.forEach({change in
                    if change.type == .added {
                        let data = change.document.data()
                        let item = Item(
                            id: data["id"] as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            nickname: data["nickname"] as? String ?? "",
                            boardId: data["boardId"] as? String ?? "",
                            name: data["name"] as? String ?? "",
                            note: data["note"] as? String ?? "",
                            link: data["link"] as? String ?? "",
                            isTopFive: data["isTopFive"] as? Bool ?? false,
                            createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                            modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                            )
                            self.savedItems.append(item)
                    }
                        if change.type == .removed {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.savedItems = self.savedItems.filter {$0.id != id}
                        }
                        if change.type == .modified {
                            let data = change.document.data()
                            let item = Item(
                                id: data["id"] as? String ?? "",
                                userId: data["userId"] as? String ?? "",
                                nickname: data["nickname"] as? String ?? "",
                                boardId: data["boardId"] as? String ?? "",
                                name: data["name"] as? String ?? "",
                                note: data["note"] as? String ?? "",
                                link: data["link"] as? String ?? "",
                                isTopFive: data["isTopFive"] as? Bool ?? false,
                                createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                                )
                                self.savedItems.append(item)
                            
                        }
                    })
                }
    }
    
}
