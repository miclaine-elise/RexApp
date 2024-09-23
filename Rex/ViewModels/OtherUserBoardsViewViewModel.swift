//
//  OtherUserBoardViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/14/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class OtherUserBoardsViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var boards = [Board]()
    @Published var filteredBoards: [Board] = []
    @Published var items = [Item]()
    @Published var searchBoards: String = "" {
        didSet {
            applySearchFilter()
        }
    }
    public let user : User
    let db = Firestore.firestore()

    init(user: User) {
        self.user = user
        fetchBoards()
    }
    
    func fetchBoards() {
        db.collection("users")
            .document(user.id)
            .collection("boards")
            .order(by: "modifiedDate")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error)
                return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No boards found")
                    return
                }
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
                self.applySearchFilter()
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
            .document(user.id)
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
}


