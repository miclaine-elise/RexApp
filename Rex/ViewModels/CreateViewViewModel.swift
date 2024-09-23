//
//  CreateViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CreateViewViewModel: ObservableObject {
    public let userId : String
    @Published var nickname = ""
    let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        fetchNickname()
    }
    func fetchNickname(){
        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async { [self] in
                self?.nickname = data["nickname"] as? String ?? ""
                }

            }
    }
}
