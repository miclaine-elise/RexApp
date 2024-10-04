//
//  ContentView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @State private var selectedTab: Int = 0 // Track the currently selected tab
    @State private var previousSelectedTab: Int = 0 // Track the previous tab to detect re-selection

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
            TabView(selection: $selectedTab) {
                FeedView(currentUserId: viewModel.currentUserId)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                    .onAppear {
                        if selectedTab == previousSelectedTab {
                           
                        }
                        previousSelectedTab = selectedTab
                    }

                CreateView(userId: viewModel.currentUserId)
                    .tabItem {
                        Image(systemName: "plus.square")
                    }
                    .tag(1)
                    .onAppear {
                        previousSelectedTab = selectedTab
                    }

                ProfileView(userId: viewModel.currentUserId)
                    .tabItem {
                        Image(systemName: "person.circle")
                    }
                    .tag(2)
                    .onAppear {
                        previousSelectedTab = selectedTab
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
