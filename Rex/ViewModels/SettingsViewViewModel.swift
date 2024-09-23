//
//  SettingsViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/30/24.
//

import Foundation
import FirebaseAuth
class SettingsViewViewModel: ObservableObject {
    
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }

}
