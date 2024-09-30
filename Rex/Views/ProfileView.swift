//
//  ProfileView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var viewModel:  ProfileViewViewModel
    @State private var selectedTab: Tab = .created

    enum Tab {
        case created
        case suggested
        case saved
    }
    init(userId: String){
        self._viewModel = StateObject(
            wrappedValue:
                ProfileViewViewModel(userId: userId)
        )
    }
    var body: some View {
        NavigationView {
            ScrollView{
                VStack{
                    if let user = viewModel.currentUser {
                        PhotosPicker(selection: $viewModel.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared()) {
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
                            .padding(.bottom)
                            VStack {
                                HStack(spacing: 0) {
                                    Button(action: {
                                        selectedTab = .created
                                    }) {
                                        Text("Mine")
                                            .fontWeight(selectedTab == .created ? .bold : .regular)
                                            .foregroundColor(selectedTab == .created ? .white : .black)
                                            .padding()
                                            .background(selectedTab == .created ? Color("FunColor") : Color.clear)
                                            .cornerRadius(20)
                                    }
                                    Button(action: {
                                        selectedTab = .suggested
                                    }) {
                                        Text("Suggested")
                                            .fontWeight(selectedTab == .suggested ? .bold : .regular)
                                            .foregroundColor(selectedTab == .suggested ? .white : .black)
                                            .padding()
                                            .background(selectedTab == .suggested ? Color("FunColor") : Color.clear)
                                            .cornerRadius(20)
                                    }
                                    Button(action: {
                                        selectedTab = .saved
                                    }) {
                                        Text("Saved")
                                            .fontWeight(selectedTab == .saved ? .bold : .regular)
                                            .foregroundColor(selectedTab == .saved ? .white : .black)
                                            .padding()
                                            //.frame(maxWidth: .infinity)
                                            .background(selectedTab == .saved ? Color("FunColor") : Color.clear)
                                            .cornerRadius(20)
                                    }
                                }
                                // Content based on selected tab
                                if selectedTab == .created {
                                    UserBoardsView(/*showingNewBoardView: $viewModel.showingNewBoardView, */userId: viewModel.userId, nickname: user.nickname)
                                } else if selectedTab == .suggested{
                                    SuggestedView(userId: viewModel.userId)
                                } else {
                                    SavedView(userId: viewModel.userId)
                                }
                          }
                        }
                        .toolbar {
                            Button {
                                //Action
                                viewModel.showingSettingsView = true
                            } label: {
                                Text("...")
                                    .foregroundColor(Color("FunColor"))
                                    .bold()
                                    .font(.system(size: 40))
                            }
                        }
                        .sheet(isPresented: $viewModel.showingSettingsView) {
                            SettingsView(settingsViewPresented: $viewModel.showingSettingsView, userId: viewModel.userId)
                        }
//                        .sheet(isPresented: $viewModel.showingNewBoardView) {
//                            NewBoardView(newBoardViewPresented: $viewModel.showingNewBoardView, userId: viewModel.userId, nickname: user.nickname)
//                        }
                        Spacer()
                    } else {
                        Text("Beep Boop...")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .background{Color("MainColor")                .ignoresSafeArea()}
        }
    }
}


#Preview {
    ProfileView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2")
}
