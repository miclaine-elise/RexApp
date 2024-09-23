//
//  ContentView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        let customColor = UIColor(Color("MainColor"))
        appearance.backgroundColor = customColor
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        if viewModel.isSignedIn, viewModel.currentUserId != "" {
            TabView() {
                FeedView(currentUserId: viewModel.currentUserId)
                    .tabItem {
                            Image(systemName: "house")
                    }
                
                CreateView(userId: viewModel.currentUserId)
                    .tabItem {
                            Image(systemName: "plus.square")
                    }

                ProfileView(userId: viewModel.currentUserId)
                    .tabItem {
                            Image(systemName: "person.circle")
                    }
            }
        } else {
            LoginView()
        }
    }
}


#Preview {
    MainView()
}
