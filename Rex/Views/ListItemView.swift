//
//  ListItemView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/31/24.
//

import SwiftUI

struct ListItemView: View {
    @StateObject var viewModel = ListItemViewViewModel()
    let item: Item
    let isOwner: Bool
    var body: some View {
        VStack{
            HStack{
                Text(item.name)
                    .font(.system(size: 20))
                    .frame( maxWidth: .infinity,
                            minHeight: 30,
                            alignment: .leading )
                    .foregroundColor(Color("TextColor"))
            }
        }
        .padding(.leading)
    }
}
#Preview {
    ListItemView(item: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", boardId: "123", name: "Moonrise Kingdom", note: "So good", link: "google.com", isTopFive: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970), isOwner: true)
}
