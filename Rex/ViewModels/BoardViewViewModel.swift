//
//  BoardViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/31/24.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation
class BoardViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var showingNewItemView = false
    @Published var items = [Item]()
    @Published var topFiveItems = [Item]()
    @Published var searchItems = ""
    @Published var showingEditBoardView = false
    @Published var imageProfileUrl = ""
    @Published var savedBoards = [String]()

    public let userId : String
    public let board : Board
    let db = Firestore.firestore()

    init(userId: String, board: Board) {
        self.userId = userId
        self.board = board
        fetchItems()
        fetchProfilePhoto()
    }
    func fetchItems() {
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(board.id)
            .collection("items")
            .order(by: "createdDate")
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
                        if item.isTopFive {
                            self.topFiveItems.append(item)
                        } else {
                            self.items.append(item)
                        }
                    }
                        if change.type == .removed {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.items = self.items.filter {$0.id != id}
                            self.topFiveItems = self.topFiveItems.filter {$0.id != id}
                        }
                        if change.type == .modified {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.items = self.items.filter {$0.id != id}
                            self.topFiveItems = self.topFiveItems.filter {$0.id != id}
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
                            if item.isTopFive {
                                self.topFiveItems.append(item)
                            } else {
                                self.items.append(item)
                            }
                        }
                        
                    })
                }
    }

    func moveItem(items: [Item], isTopFive: Bool) {
        let db = Firestore.firestore()
        for item in items {
            var itemCopy = item
            itemCopy.setTopFive(isTopFive)
            
            db.collection("users")
                .document(userId)
                .collection("boards")
                .document(board.id)
                .collection("items")
                .document(itemCopy.id)
                .setData(itemCopy.asDictionary())
        }
    }
    func searchItems(from keyword: String){}

    func fetchProfilePhoto(){
        db.collection("users")
            .document(userId)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    self.imageProfileUrl = document.get("imageProfileUrl") as? String ?? ""
                }
            }
    }
    func saveBoard() {
        let newId = UUID().uuidString
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("users")
            .document(uId)
            .collection("savedBoards")
            .document(board.id)
            .setData(board.asDictionary())
        self.savedBoards.append(board.id)
//        print(self.savedBoards)

    }
    func unsaveBoard() {
        let newId = UUID().uuidString
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("users")
            .document(uId)
            .collection("savedBoards")
            .document(board.id)
            .delete()
//        self.savedBoards = self.savedBoards.filter { $0 != board.id}
//        print(self.savedBoards)

    }
    func delete(id: String){
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(board.id)
            .collection("items")
            .document(id)
            .delete()
    }

}



