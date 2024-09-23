//
//  NewItemEventViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/21/24.
//

import Foundation
import FirebaseFirestore
class NewItemEventViewViewModel: ObservableObject {
    
    @Published var newItemEvent: NewItemEvent
    let currentUserId: String
    @Published var eventItemFetched: Item
  //  @Published var newItemEventFetched: NewItemEvent

    let db = Firestore.firestore()
    
    init(currentUserId: String, newItemEvent: NewItemEvent) {
        self.currentUserId = currentUserId
        self.newItemEvent = newItemEvent
      //  self.newItemEventFetched = newItemEvent
        self.eventItemFetched = Item(id: "", userId: "", nickname: "", boardId: "", name: "", note: "", link: "", isTopFive: false, createdDate: Date().timeIntervalSince1970, modifiedDate: Date().timeIntervalSince1970)
        fetchItem()
    }
//    func fetchNewItemEvent() {
//        db.collection("users")
//            .document(newItemEvent.userId)
//            .collection("newItemEvents")
//            .document(newItemEvent.id)
//            .addSnapshotListener { querySnapshot, error in
//                guard let data = querySnapshot?.data() else {
//                    print(error)
//                    return
//                }
//                self.newItemEventFetched = NewItemEvent (
//                        id: data["id"] as? String ?? "",
//                        userId: data["userId"] as? String ?? "",
//                        itemId: data[""] as? String ?? "",
//                        boardId: data[""] as? String ?? "",
//                        nickname: data["nickname"] as? String ?? "",
//                        boardName: data["boardName"] as? String ?? "",
//                        isPrivate: data["isPrivate"] as? Bool ?? false,
//                        eventDate: data["eventDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
//                        likes: data["likes"] as? Array<String> ?? []
//                    )
//                self.fetchItem(itemId: self.newItemEventFetched.itemId)
//            }
//        
//    }
    func fetchItem() {
        db.collection("users")
            .document(newItemEvent.userId)
            .collection("boards")
            .document(newItemEvent.boardId)
            .collection("items")
            .document(newItemEvent.itemId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    print(error)
                    return
                }
                self.eventItemFetched = Item (
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
            }
    }
    func likeEvent(){
        let otherUserId = newItemEvent.userId
        db.collection("users")
        .document(otherUserId)
        .collection("newItemEvents")
        .document(newItemEvent.id)
        .updateData([
            "likes": FieldValue.arrayUnion([currentUserId])])
        self.newItemEvent.likes.append(currentUserId)
    }
    func unlikeEvent(){
        let otherUserId = newItemEvent.userId
        db.collection("users")
        .document(otherUserId)
        .collection("newItemEvents")
        .document(newItemEvent.id)
        .updateData([
            "likes": FieldValue.arrayRemove([currentUserId])])
        self.newItemEvent.likes = self.newItemEvent.likes.filter { $0 != currentUserId }
    }
}

