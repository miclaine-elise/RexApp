//
//  UserBoardsView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class UserBoardsViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var showingNewBoardView = false
    @Published var boards = [Board]()
    @Published var items = [Item]()
    @Published var filteredBoards: [Board] = []
    @Published var searchBoards: String = "" {
        didSet {
            applySearchFilter()
        }
    }
    public let userId : String
    public let nickname : String

    let db = Firestore.firestore()

    init(userId: String, nickname: String) {
        self.userId = userId
        self.nickname = nickname
        fetchBoards()
    }
    func fetchItems(board: Board) {
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(board.id)
            .collection("items")
            .order(by: "createdDate")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No items found")
                    return
                }
                for document in documents {
                    let data = document.data()
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
                    self.items.append(item)
                }
            }
    }
    
    func fetchBoards() {
        db.collection("users")
            .document(userId)
            .collection("boards")
            .order(by: "modifiedDate", descending: true)
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
                        self.boards.append(board)
                        self.applySearchFilter()

                    }
                        if change.type == .removed {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.boards = self.boards.filter {$0.id != id}
                            self.applySearchFilter()

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
                            if let index = self.boards.firstIndex(where: {$0.id == board.id}){
                                self.boards[index] = board
                            }
//                            self.boards = self.boards.filter { $0.id != board.id }
//                            self.boards.append(board)
                            self.applySearchFilter()
                        }
                    })
                }
            }
    func applySearchFilter() {
        self.filteredBoards.removeAll()
        if searchBoards.isEmpty {
            self.filteredBoards = boards
        } else {
            for board in boards {
                let boardMatches = board.name.localizedCaseInsensitiveContains(searchBoards)
                
                if boardMatches {
                    // If the board name matches, directly add it to filteredBoards
                    self.filteredBoards.append(board)
                } else {
                    // If the board name doesn't match, check its items
                    fetchItems(for: board) { items in
                        // Filter the items based on the search query
                        let matchingItems = items.filter { $0.name.localizedCaseInsensitiveContains(self.searchBoards) }
                        
                        if !matchingItems.isEmpty {
                            // If there are matching items, create a new Board with those items and add it to filteredBoards
                            self.filteredBoards.append(board)
                        }
                    }
                }
            }
        }
    }
    private func fetchItems(for board: Board, completion: @escaping ([Item]) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(board.id)
            .collection("items")
            .order(by: "modifiedDate", descending: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Failed to fetch items for board \(board.id): \(error)")
                    completion([]) // Return an empty array in case of error
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No items found for board \(board.id)")
                    completion([]) // Return an empty array if no documents
                    return
                }
                
                let items = documents.compactMap { document -> Item? in
                    let data = document.data()
                    return Item(
                        id: data["id"] as? String ?? "",
                        userId: data["userId"] as? String ?? "",
                        nickname: data["nickname"] as? String ?? "",
                        boardId: board.id,
                        name: data["name"] as? String ?? "",
                        note: data["note"] as? String ?? "",
                        link: data["link"] as? String ?? "",
                        isTopFive: data["isTopFive"] as? Bool ?? false,
                        createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                        modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                    )
                }
                
                completion(items)
            }
    }
                                                       
    func delete(id: String){
        
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(id)
            .delete()
    }
}

