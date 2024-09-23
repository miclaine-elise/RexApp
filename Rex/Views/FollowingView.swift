//
//  FollowingView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/16/24.
//

import SwiftUI

struct FollowingView: View {
    @StateObject var viewModel:  FollowingViewViewModel

    init(currentUser: User){
        self._viewModel = StateObject(
            wrappedValue:
                FollowingViewViewModel(currentUser: currentUser)
        )
    }
    var body: some View {
        NavigationView{
            VStack{
                ForEach(viewModel.following) { user in
                    ProfileBarView(otherUser: user, currentUser: viewModel.currentUser)
                    Divider()
                }
                Spacer()

            }
            .background { Color("MainColor").ignoresSafeArea() }

        }
        .navigationTitle("Following")
    }
}

#Preview {
    FollowingView(currentUser: .init(id: "", firstName: "Mic", lastName: "Emtman", nickname: "mic", email: "", joined: 1333, followers: [], following: [], imageProfileUrl: "google.com"))
}
