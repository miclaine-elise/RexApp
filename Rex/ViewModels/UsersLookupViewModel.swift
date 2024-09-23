//
//  UsersLookupViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UsersLookupViewModel: ObservableObject {
    @Published var errorMessage = ""

    @Published var queriedUsers: [User] = []
    @Published var currentUser: User?

    private let db = Firestore.firestore()
    private let currentUserId: String
    init(currentUserId: String) {
        self.currentUserId = currentUserId
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        db.collection("users")
            .document(currentUserId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    self.errorMessage = "Failed to listen for current user: \(error)"
                    print(error)
                    return
                }
                self.currentUser = User(
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
    func fetchUsers(from keyword: String) {
        db.collection("users").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {return}
            self.queriedUsers = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)}}
    }
}
