//
//  FollowersViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/16/24.
//

import Foundation
import FirebaseFirestore
class FollowersViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var currentUser : User
    @Published var followers = [User]()
    private let db = Firestore.firestore()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        fetchFollowers()
    }
    
    func fetchFollowers(){
        for userId in currentUser.followers {
            db.collection("users")
                .document(userId)
                .getDocument { querySnapshot, error in
                    guard let data = querySnapshot?.data() else {
                        self.errorMessage = "Failed to listen for current user: \(error)"
                        print(error)
                        return
                    }
                    let user = User(
                        id: data["id"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        nickname: data["nickname"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? 0,
                        followers: data["followers"] as? Array<String> ?? [],
                        following: data["following"] as? Array<String> ?? [],
                        imageProfileUrl: data["imageProfileUrl"] as? String ?? "")
                    self.followers.append(user)
                    
                }
        }
    }
}
