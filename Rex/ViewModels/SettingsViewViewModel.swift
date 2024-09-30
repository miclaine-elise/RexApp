//
//  SettingsViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/30/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class SettingsViewViewModel: ObservableObject {
    let db = Firestore.firestore()
    private let userId: String

    init(userId: String) {
        self.userId = userId
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    func deleteAccount(){
        logOut()
        db.collection("users")
            .document(userId)
            .delete()
        
    }

}
