//
//  CreateView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel:  CreateViewViewModel
    @State var selectedTab: Tab = .suggestion

    enum Tab {
        case suggestion
        case rex
        case board
    }
    init(userId: String){
        self._viewModel = StateObject(
            wrappedValue:
                CreateViewViewModel(userId: userId)
        )
    }
    var body: some View {
        NavigationView{
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        selectedTab = .suggestion
                    }) {
                        Text("Suggestion")
                            .fontWeight(selectedTab == .suggestion ? .bold : .regular)
                            .padding()
                            .cornerRadius(20)
                            .overlay( selectedTab == .suggestion ?                         RoundedRectangle(cornerRadius:10).stroke(Color("TextColor"), lineWidth: 2) :                         RoundedRectangle(cornerRadius:10).stroke(Color.clear, lineWidth: 0))
                    }
                    Button(action: {
                        selectedTab = .rex
                    }) {
                        Text("Rex")
                            .fontWeight(selectedTab == .rex ? .bold : .regular)
                            .padding()
                            .cornerRadius(20)
                            .overlay( selectedTab == .rex ?                         RoundedRectangle(cornerRadius:10).stroke(Color("TextColor"), lineWidth: 2) :                         RoundedRectangle(cornerRadius:10).stroke(Color.clear, lineWidth: 0))
                    }
                    Button(action: {
                        selectedTab = .board
                    }) {
                        Text("Board")
                            .fontWeight(selectedTab == .board ? .bold : .regular)
                            .padding()
                            .cornerRadius(20)
                            .overlay( selectedTab == .board ?                         RoundedRectangle(cornerRadius:10).stroke(Color("TextColor"), lineWidth: 2) :                         RoundedRectangle(cornerRadius:10).stroke(Color.clear, lineWidth: 0))
                    }
                }
                // Content based on selected tab
                if selectedTab == .suggestion {
                    NewSuggestionView(userId: viewModel.userId)
                } else if selectedTab == .rex {
                    NewItemView(userId: viewModel.userId, nickname: viewModel.nickname)
                } else {
                    NewBoardView(userId: viewModel.userId, nickname: viewModel.nickname, isDirectNavigation: true, onSave: { _ in })
                }
            }
            .background{Color("MainColor")                .ignoresSafeArea()}
        }
    }
}


#Preview {
    CreateView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2")
}
