//
//  ProfileSearchView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/13/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileSearchView: View {
    @StateObject var viewModel: UsersLookupViewModel
    @Binding var searchIsSelected: Bool
    @State var keyword: String = ""

    let currentUserId: String

    init(currentUserId: String, searchIsSelected: Binding<Bool>) {
        self.currentUserId = currentUserId
        _searchIsSelected = searchIsSelected
        self._viewModel = StateObject(
            wrappedValue: UsersLookupViewModel(currentUserId: currentUserId)
        )
    }

    var body: some View {
        VStack {
            if let currentUser = viewModel.currentUser {
                let keywordBinding = Binding<String>(
                    get: {
                        keyword
                    },
                    set: {
                        keyword = $0
                        viewModel.fetchUsers(from: keyword)
                    }
                )

                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("TextColor"))
                        SearchBarView(keyword: keywordBinding)
                            .onTapGesture {
                                self.searchIsSelected = true
                            }

                        if searchIsSelected {
                            Button {
                                searchIsSelected = false
                                keyword = ""
                                viewModel.queriedUsers = []
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                                Text("Cancel")
                            }
                            .transition(.move(edge: .trailing))
                            .animation(.default)
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)

                    ForEach(viewModel.queriedUsers) { user in
                        ProfileBarView(otherUser: user, currentUser: currentUser)
                        Divider()
                    }
                }
            } else {
                Text("Loading")
            }
        }
        .background { Color("MainColor").ignoresSafeArea() }
    }
}
struct SearchBarView: View {
    @Binding var keyword: String
    
    var body: some View {
        
        TextField("Search Users", text: $keyword)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .disableAutocorrection(true)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("TextColor"))
            )
    }
}

struct ProfileBarView: View {
    var otherUser: User
    var currentUser: User

    var body: some View {
        NavigationLink(destination: OtherUserProfileView(otherUserId: otherUser.id)){
                HStack {
                    if otherUser.imageProfileUrl != "" {
                        WebImage(url: URL(string: otherUser.imageProfileUrl))
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color("TextColor"))
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding()
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("TextColor"))
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    VStack(alignment: .leading){
                        Text("\(otherUser.firstName) \(otherUser.lastName)")
                            .font(.system(size: 20))
                            .bold()
                        Text("\(otherUser.nickname)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            //.padding()
        }
    }
}
#Preview {
    ProfileSearchView(currentUserId: "kTZQwY0G59avj86FpWnjTCBTnvK2", searchIsSelected: Binding(get: {
        return true
    }, set: { _ in
    }))}
