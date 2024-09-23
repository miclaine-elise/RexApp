//
//  MainViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//
import FirebaseAuth
import Foundation
import FirebaseFirestore

class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
//    @Published var currentUser: User = (User(id: "", firstName: "", lastName: "", username: "", nickname: "", email: "", joined: Date().timeIntervalSince1970, followers: [], following: [], imageProfileUrl: ""))

    private var handler : AuthStateDidChangeListenerHandle?
    init() {
        let handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in DispatchQueue.main.async {       self?.currentUserId = user?.uid ?? ""
           // self?.fetchCurrentUser()

            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
//    func fetchCurrentUser() {
//        let db = Firestore.firestore()
//        db.collection("users")
//            .document(currentUserId)
//            .addSnapshotListener { querySnapshot, error in
//                guard let data = querySnapshot?.data() else {
//                    print(error)
//                    return
//                }
//                self.currentUser = User(
//                    id: data["id"] as? String ?? "",
//                    firstName: data["firstName"] as? String ?? "",
//                    lastName: data["lastName"] as? String ?? "",
//                    username: data["username"] as? String ?? "",
//                    nickname: data["nickname"] as? String ?? "",
//                    email: data["email"] as? String ?? "",
//                    joined: data["joined"] as? TimeInterval ?? 0,
//                    followers: data["followers"] as? Array<String> ?? [],
//                    following: data["following"] as? Array<String> ?? [],
//                    imageProfileUrl: data["imageProfileUrl"] as? String ?? "")
//            }
//    }
}
