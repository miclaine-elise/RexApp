//
//  OtherUserProfileViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import FirebaseStorage

class OtherUserProfileViewViewModel: ObservableObject {
    @Published var isFollowing: Bool?
   // public let otherUser : User
    @Published var otherUser: User?
    public let otherUserId: String
    @Published var following = [String]()

    let db = Firestore.firestore()

    init(otherUserId: String) {
        self.otherUserId = otherUserId
        fetchOtherUser()
        checkFollowing()
    }
    
    func fetchOtherUser() {
        db.collection("users")
            .document(otherUserId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    print(error)
                    return
                }
                self.otherUser = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    nickname: data["nickname"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    followers: data["followers"] as? Array<String> ?? [],
                    following: data["following"] as? Array<String> ?? [],
                    imageProfileUrl: data["imageProfileUrl"] as? String ?? "")
            }
    
    }

    
    
    func checkFollowing() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        db.collection("users")
            .document(currentUserId)
            .getDocument { (document, error) in
                if let document = document, document.exists {    
                    print(document)
                    self.following = document.get("following") as? Array<String> ?? []
                    print(self.following)
                    if self.following.contains(self.otherUserId) {
                        self.isFollowing = true
                    } else {
                        self.isFollowing = false
                    }
                }
        }
    }
    func followUser(userToFollow: User){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
        .document(currentUserId).updateData([
            "following": FieldValue.arrayUnion([userToFollow.id])])
        db.collection("users")
            .document(userToFollow.id).updateData([
            "followers": FieldValue.arrayUnion([currentUserId])])
        checkFollowing()
    }
    func unfollowUser(userToUnfollow: User){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(currentUserId).updateData([
                "following": FieldValue.arrayRemove([userToUnfollow.id])])
        db.collection("users")
            .document(userToUnfollow.id)
            .updateData([
                "followers": FieldValue.arrayRemove([currentUserId])])
        checkFollowing()
}
}
