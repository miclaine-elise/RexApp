//
//  SettingsView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/30/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewViewModel()
    @Binding var settingsViewPresented: Bool

    init(settingsViewPresented: Binding<Bool>) {
        _settingsViewPresented = settingsViewPresented
    }
    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    List(){
                        Button("Log Out") {
                            viewModel.logOut()
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 20))
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CloseButton{
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
    SettingsView(settingsViewPresented:Binding(get: {
        return true
    }, set: { _ in
    }))
}
