//
//  LoginViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var showAlert = false
    init() {
       
    }
    
    func login() {
        guard validate() else {
            return
        }
        //Try log in
        Auth.auth().signIn(withEmail: email, password: password)
        { [weak self] result, error in
            guard let userId = result?.user.uid else {
                self?.errorMessage = error?.localizedDescription ?? "Login failed"
                self?.showAlert = true
                return
            }
        }
    }
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        guard email.contains("@") && email.contains(".") else { errorMessage = "Please enter valid email."
        return false}
        return true

    }
}
