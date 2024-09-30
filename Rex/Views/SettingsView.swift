//
//  SettingsView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/30/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewViewModel
    @Binding var settingsViewPresented: Bool
    @State private var showDeleteAlert = false // Add state for alert

    init(settingsViewPresented: Binding<Bool>, userId: String) {
        _settingsViewPresented = settingsViewPresented
        self._viewModel = StateObject(
            wrappedValue:
                    SettingsViewViewModel(userId: userId)
            )
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    List {
                        Button("Log Out") {
                            viewModel.logOut()
                        }
                        Button("Delete Account") {
                            showDeleteAlert = true // Show alert on button click
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 20))
                }
                .alert("Are you sure?", isPresented: $showDeleteAlert) { // Add alert
                    Button("Cancel", role: .cancel) {
                        // Cancel action
                    }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteAccount() // Perform delete action
                    }
                } message: {
                    Text("This action will permanently delete your account.")
                }

                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CloseButton {
                            settingsViewPresented = false
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Settings")
                .padding()
            }
            .background { Color("MainColor").ignoresSafeArea() }
        }
    }
}

#Preview {
    SettingsView(settingsViewPresented: Binding(get: {
        return true
    }, set: { _ in }), userId: "123")
}
