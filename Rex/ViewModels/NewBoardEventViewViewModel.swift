//
//  FeedEventViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/21/24.
//

import Foundation
import FirebaseFirestore
class NewBoardEventViewViewModel: ObservableObject {
    //Previously I was refetching the board event so I could add a snapshot listener but I feel like thats not necessary for "events". They dont have to be up to date.
@Published var newBoardEvent: NewBoardEvent
    let currentUserId: String
    @Published var eventBoardFetched: Board
   // @Published var newBoardEventFetched: NewBoardEvent

    let db = Firestore.firestore()
    
    init(currentUserId: String, newBoardEvent: NewBoardEvent) {
        self.currentUserId = currentUserId
        self.newBoardEvent = newBoardEvent
       // self.newBoardEventFetched = newBoardEvent
        self.eventBoardFetched = Board(id: "", userId: "", nickname: "", name: "", isPrivate: false, createdDate: Date().timeIntervalSince1970, modifiedDate: Date().timeIntervalSince1970)
      //  fetchNewBoardEvent()
        fetchBoard()

    }
    
//    func fetchNewBoardEvent() {
//        let db = Firestore.firestore()
//        db.collection("users")
//            .document(newBoardEvent.userId)
//            .collection("events")
//            .document(newBoardEvent.id)
//            .addSnapshotListener { querySnapshot, error in
//                guard let data = querySnapshot?.data() else {
//                    print(error)
//                    return
//                }
//                self.newBoardEventFetched = NewBoardEvent (
//                        id: data["id"] as? String ?? "",
//                        userId: data["userId"] as? String ?? "",
//                        boardId: data["boardId"] as? String ?? "",
//                        nickname: data["nickname"] as? String ?? "",
//                        isPrivate: data["isPrivate"] as? Bool ?? false,
//                        eventDate: data["eventDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
//                        likes: data["likes"] as? Array<String> ?? []
//                    )
//                print("inside fetchNewBoardEvent")
//                self.fetchBoard(boardId: self.newBoardEventFetched.boardId)
//            }
//    }

    func fetchBoard(){
        db.collection("users")
            .document(newBoardEvent.userId)
            .collection("boards")
            .document(newBoardEvent.boardId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    print(error)
                return
                }
                self.eventBoardFetched = Board (
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
    //this no longer works because Im no longer using an event listener for the event
    func likeEvent(){
        let otherUserId = newBoardEvent.userId
        db.collection("users")
        .document(otherUserId)
        .collection("newBoardEvents")
        .document(newBoardEvent.id)
        .updateData([
            "likes": FieldValue.arrayUnion([currentUserId])])
        self.newBoardEvent.likes.append(currentUserId)
    }
    func unlikeEvent(){
        let otherUserId = newBoardEvent.userId
        db.collection("users")
        .document(otherUserId)
        .collection("newBoardEvents")
        .document(newBoardEvent.id)
        .updateData([
            "likes": FieldValue.arrayRemove([currentUserId])])
        self.newBoardEvent.likes = self.newBoardEvent.likes.filter { $0 != currentUserId }
    }
}
