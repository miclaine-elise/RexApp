//
//  FollowersView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/16/24.
//

import SwiftUI

struct FollowersView: View {
    @StateObject var viewModel:  FollowersViewViewModel

    init(currentUser: User){
        self._viewModel = StateObject(
            wrappedValue:
                FollowersViewViewModel(currentUser: currentUser)
        )
    }
    var body: some View {
        NavigationView{
            VStack{
                ForEach(viewModel.followers) { user in
                    ProfileBarView(otherUser: user, currentUser: viewModel.currentUser)
                    Divider()
                }
                Spacer()

            }
            .background { Color("MainColor").ignoresSafeArea() }

        }
        .navigationTitle("Followers")
    }
}

#Preview {
    FollowersView(currentUser: .init(id: "", firstName: "Mic", lastName: "Emtman", nickname: "mic", email: "", joined: 1333, followers: [], following: [], imageProfileUrl: "google.com"))
}
