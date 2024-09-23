//
//  ListSavedView.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/8/24.
//

import SwiftUI

struct SavedListItemView: View {
    @StateObject var viewModel: SavedListItemViewViewModel
    init(item: Item){
        self._viewModel = StateObject(
            wrappedValue:
                SavedListItemViewViewModel(item: item))
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(viewModel.item.name)
                    .font(.system(size: 15))
                    .bold()
                Spacer()
                Text("\(viewModel.nickName)'s \(viewModel.boardName)")
                    .font(.system(size: 10))

            }
            if viewModel.item.note != "" {
                Text("\(viewModel.item.note)")
                    .font(.system(size: 15))
            }
        }
        .padding()
        .frame(alignment: .leading )
        .foregroundColor(Color("TextColor"))
        .background(Color("SecondaryColor"))
        .cornerRadius(10)
        .shadow(radius: 4, x: 3, y: 4)
        .padding(.leading)
        .padding(.trailing)
    }
}

#Preview {
    SavedListItemView(item: .init(id:"7F7107E7-2FDD-4D88-B2A3-4D9E2FE2DFDE", userId: "ICuGPsFKXRMMCLCRge9gEJTAUfJ3", nickname: "mic", boardId: "7F7107E7-2FDD-4D88-B2A3-4D9E2FE2DFDE", name: "Moonrise Kingdom", note: "So good", link: "google.com", isTopFive: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970))
}
