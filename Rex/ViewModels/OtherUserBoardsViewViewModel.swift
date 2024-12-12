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
            .whereField("isPrivate", isEqualTo: false) // Only fetch boards where isPrivate is false
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
        let searchQuery = searchBoards.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchQuery.isEmpty {
            self.filteredBoards = boards
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var matchingBoards = [Board]()
        
        for board in boards {
            let boardMatches = board.name.localizedCaseInsensitiveContains(searchQuery)
            
            if boardMatches {
                matchingBoards.append(board)
            } else {
                dispatchGroup.enter()
                fetchItems(for: board) { items in
                    let matchingItems = items.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
                    if !matchingItems.isEmpty {
                        matchingBoards.append(board)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.filteredBoards = matchingBoards
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


