//
//  OtherUserProfileView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct OtherUserProfileView: View {
    @StateObject var viewModel:  OtherUserProfileViewViewModel
    @Binding var isFollowing: Bool?
    let otherUserId: String
    init(otherUserId: String, isFollowing: Binding<Bool?> = .constant(nil)){
        _isFollowing = isFollowing
            self.otherUserId = otherUserId
            self._viewModel = StateObject(
                wrappedValue:
                    OtherUserProfileViewViewModel(otherUserId: otherUserId)
            )
        }
    var body: some View {
        ScrollView{
            VStack{
                if let user = viewModel.otherUser {
                    
                    VStack{
                        if user.imageProfileUrl != "" {
                            WebImage(url: URL(string: user.imageProfileUrl))
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(Color("TextColor"))
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                                .padding()
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("TextColor"))
                                .frame(width: 125, height: 125)
                                .padding()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        Text("\(user.firstName) \(user.lastName)")
                            .bold()
                            .font(.custom("BebasNeue-Regular", size: 40))
                            .foregroundColor(Color("TextColor"))
                        
                        HStack {
                            NavigationLink( destination: FollowingView(currentUser: user)){
                                Text("\(user.following.count) following")
                                .bold()}
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 5, height: 5)
                                .foregroundColor(Color("FunColor"))
                            NavigationLink( destination: FollowersView(currentUser: user)){
                                Text("\(user.followers.count) followers")
                                    .bold()
                            }
                        }
                        .foregroundColor(Color("TextColor"))
                        if let followingStatus = viewModel.isFollowing {
                            if viewModel.isFollowing == true {
                                Button {
                                    viewModel.unfollowUser(userToUnfollow: user)
                                    viewModel.isFollowing = false
                                } label: {
                                    Text("Following")
                                        .bold()
                                        .frame(width: 100, height: 50)
                                        .background(Color("TextColor"))
                                        .foregroundColor(Color("MainColor"))
                                        .cornerRadius(20)
                                        .shadow(radius: 4, x: 3, y: 4)
                                }
                                .padding()
                            } else {
                                Button {
                                    viewModel.followUser(userToFollow: user)
                                    viewModel.isFollowing = true
                                    
                                } label: {
                                    Text("Follow")
                                    // .font(.system(size: 20))
                                    // .bold()
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 45)
                                        .background(Color("FunColor"))
                                        .cornerRadius(20)
                                        .shadow(radius: 4, x: 3, y: 4)
                                }
                                .padding()
                            }
                        }
                        OtherUserBoardsView(user: user)
                    }
                    .toolbar {
                        Button {
                            //Action
                            //    viewModel.showingSettingsView = true
                        } label: {
                            Text("...")
                                .foregroundColor(Color("FunColor"))
                                .bold()
                                .font(.system(size: 30))
                        }
                    }
                }
                //                        .sheet(isPresented: $viewModel.showingSettingsView) {
                //                            SettingsView(settingsViewPresented: $viewModel.showingSettingsView)
                //                        }
                //                    } else {
                //                        Text("Loading profile...")
                //                    }
                Spacer()
            }
        }
        .background{Color("MainColor")
            .ignoresSafeArea()}
    }
}
        
    
#Preview {
    OtherUserProfileView(otherUserId:"123", isFollowing:Binding(get: {
        return true
    }, set: { _ in
    }))
}

