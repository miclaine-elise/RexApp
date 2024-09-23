//
//  RexApp.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//
import FirebaseCore
import Firebase
import SwiftUI

@main
struct RexApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
