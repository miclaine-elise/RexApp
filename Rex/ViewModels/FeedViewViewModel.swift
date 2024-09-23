//
//  FeedViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore


class FeedViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var showingSettingsView = true
    @Published var following = [String]()
    @Published var combinedEvents: [EventWrapper] = []
    @Published var searchIsSelected = false

   // @Published var events = [any Event]()
    let db = Firestore.firestore()
    public let currentUserId : String

    init(currentUserId: String){
        self.currentUserId = currentUserId
        fetchFollowing()
    }
    @Published var boardEvents = [NewBoardEvent]()
    @Published var itemEvents = [NewItemEvent]()
    
    private func updateCombinedEvents(with newEvent: EventWrapper) {
        combinedEvents.append(newEvent)
        combinedEvents.sort { $0.eventDate > $1.eventDate }
    }
    
    func fetchFollowing () {
        db.collection("users")
            .document(currentUserId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                    return
                }
                self.following = data["following"] as? Array<String> ?? []
                self.following.append(self.currentUserId)
                self.fetchEvents() //This is where you left off. because its asyncronous, you have to call the fetch events once you have actually fetched following. Next you should test if this breaks once you follow more than one person.
            }
    }
    func fetchEvents() {
            for userId in following {
                db.collection("users")
                .document(userId)
                .collection("newBoardEvents")
                .order(by: "eventDate")
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to listen for new events: \(error)"
                        print(self.errorMessage)
                        return
                    }
                    querySnapshot?.documentChanges.forEach({change in
                        if change.type == .added {
                            let data = change.document.data()
                            let boardEvent = NewBoardEvent (
                                id: data["id"] as? String ?? "",
                                userId: data["userId"] as? String ?? "",
                                boardId: data["boardId"] as? String ?? "",
                                nickname: data["nickname"] as? String ?? "",
                                isPrivate: data["isPrivate"] as? Bool ?? false,
                                eventDate: data["eventDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                likes: data["likes"] as? Array<String> ?? []
                            )
                            
                            self.boardEvents.append(boardEvent)
                            let wrappedBoardEvent = EventWrapper.board(boardEvent)
                           // DispatchQueue.main.async {
                                self.updateCombinedEvents(with: wrappedBoardEvent)
                         //   }
                        }
                    })
                }
                db.collection("users")
                    .document(userId)
                    .collection("newItemEvents")
                    .order(by: "eventDate")
                    .addSnapshotListener { querySnapshot, error in
                        if let error = error {
                            self.errorMessage = "Failed to listen for new events: \(error)"
                            print(self.errorMessage)
                            return
                        }
                        querySnapshot?.documentChanges.forEach({change in
                            if change.type == .added {
                                let data = change.document.data()
                                let itemEvent = NewItemEvent (
                                        id: data["id"] as? String ?? "",
                                        userId: data["userId"] as? String ?? "",
                                        itemId: data["itemId"] as? String ?? "",
                                        boardId: data["boardId"] as? String ?? "",
                                        nickname: data["nickname"] as? String ?? "",
                                        boardName: data["boardName"] as? String ?? "",
                                        isPrivate: data["isPrivate"] as? Bool ?? false,
                                        eventDate: data["eventDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                        likes: data["likes"] as? Array<String> ?? []
                                    )
                                self.itemEvents.append(itemEvent)
                                let wrappedItemEvent = EventWrapper.item(itemEvent)
                              //  DispatchQueue.main.async {
                                    self.updateCombinedEvents(with: wrappedItemEvent)
                             //   }
                            }
                        })
                    }
        }
        //self.events.sort { $0.eventDate < $1.eventDate }

    }

    }

