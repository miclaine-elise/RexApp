//
//  ItemView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct ItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ItemViewViewModel
    let item: Item
    let isOwner: Bool
    
    init(userId: String, item: Item, isOwner: Bool){
        self.item = item
        self.isOwner = isOwner
        self._viewModel = StateObject(
            wrappedValue:
                ItemViewViewModel(userId: userId, item: item)
        )
    }
    
    var body: some View {
        ZStack{
            Color(Color("MainColor"))
                .ignoresSafeArea()
            VStack{
                Text(item.name)
                    .font(.custom("BebasNeue-Regular", size: 40))
                    .padding(.top)
                    .frame(maxWidth: 350, alignment: .leading)
                Text("\(item.nickname)'s Notes:")
                    .font(.custom("BebasNeue-Regular", size: 25))
                    .frame(maxWidth: 350, alignment: .leading)
                    .offset(y:15)
                
                ZStack{
                    Color("SecondaryColor")
                        Text(item.note)
                    .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
                .cornerRadius(15)
                .frame(maxWidth: 350)
                .shadow(radius: 4, x: 3, y: 4)
                Spacer()
                ZStack{
                    if item.link.isEmpty == false {
                        Color(Color("FunColor"))
                        Link("Visit",
                             destination: URL(string: "\(item.link)")!)
                        .bold()
                        .foregroundColor(.white)
                    }
                }
                .cornerRadius(20)
                .frame(maxWidth: 100, maxHeight: 50)
                .shadow(radius: 4, x: 3, y: 4)
                .padding()
                
            }

            }
        .toolbar {
            Button {
                //Action
                viewModel.showingEditItemView = true
            } label: {
                Text("...")
                    .foregroundColor(Color("FunColor"))
                    .bold()
                    .font(.system(size: 30))
            }
        }
        .sheet(isPresented: $viewModel.showingEditItemView, onDismiss: didDismiss) {
            EditItemView(editItemViewPresented: $viewModel.showingEditItemView, item: item)
        }
    }
    func didDismiss() {
        dismiss()    }

}

#Preview {
    ItemView(userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", item: .init(id:"123", userId: "kTZQwY0G59avj86FpWnjTCBTnvK2", nickname: "mic", boardId: "123", name: "Moonrise Kingdom", note: "So go000 00000ooo ooooooooooo00 0000000000000000000000od", link: "google.com", isTopFive: false, createdDate: Date().timeIntervalSince1970,  modifiedDate: Date().timeIntervalSince1970), isOwner: true)
}
