//
//  RegisterViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var nickname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var imageProfileUrl = ""
    
    @Published var errorMessage = ""   // To store error messages
    @Published var showAlert = false   // To trigger the alert

    init() {}

    func register() {
        guard validate() else {
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                self?.errorMessage = error?.localizedDescription ?? "Registration failed"
                self?.showAlert = true
                return
            }

            self?.insertUserRecord(id: userId)
        }
    }

    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           firstName: firstName,
                           lastName: lastName,
                           nickname: nickname,
                           email: email,
                           joined: Date().timeIntervalSince1970,
                           followers: [],
                           following: [],
                           imageProfileUrl: imageProfileUrl)
        
        let db = Firestore.firestore()

        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
        
        db.collection("users")
            .document(id)
            .updateData(["keywordsForLookup": newUser.keywordsForLookup])
    }

    private func validate() -> Bool {
        // Check for empty fields
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your first name."
            return false
        }
        
        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your last name."
            return false
        }

        guard !nickname.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a nickname."
            return false
        }

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email address."
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }

        return true
    }
}


