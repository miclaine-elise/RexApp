//
//  NewItemView.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel: NewItemViewViewModel
    @State private var isItemSaved: Bool = false
    @State private var createdItem: Item?
    @State private var showingBoardPicker = false
    @State private var selectedBoardName: String = "Pick a board"

    init(userId: String, nickname: String) {
        self._viewModel = StateObject(
            wrappedValue:
                NewItemViewViewModel(userId: userId, nickname: nickname)
        )
    }
    
    var body: some View {
        VStack {
            Text("New Rex")
                .padding(.leading)
                .bold()
                .font(.custom("BebasNeue-Regular", size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)

            List {
                TextField("Name", text: $viewModel.name)

                Button(action: {
                    showingBoardPicker = true
                }) {
                    HStack {
                        Text(selectedBoardName)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $showingBoardPicker) {
                    BoardPickerView(boards: viewModel.boards, selectedBoardId: $viewModel.selectedBoardId, selectedBoardName: $selectedBoardName, userId: viewModel.userId, nickname: viewModel.nickname)
                }

                TextField("Notes", text: $viewModel.note, axis: .vertical)
                    .lineLimit(5...10)
                TextField("Link", text: $viewModel.link)
            }
            .background { Color("SecondaryColor") }
            .listStyle(.plain)
            .cornerRadius(15)
            .shadow(radius: 4, x: 3, y: 4)
            .padding(.bottom)

            Button {
                viewModel.saveItem()
                if let newItem = viewModel.newItem {
                    self.createdItem = viewModel.newItem
                    self.isItemSaved = true
                    viewModel.name = ""
                    viewModel.note = ""
                    viewModel.link = ""
                }
            } label: {
                Text("Create")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .background(Color("FunColor"))
                    .cornerRadius(20)
                    .shadow(radius: 4, x: 3, y: 4)

            }
            .padding()

            if let createdItem = createdItem {
                NavigationLink(destination: ItemView(userId: viewModel.userId, item: createdItem, isOwner: true), isActive: $isItemSaved) {
                    EmptyView()
                }
            }
        }
        .padding()
        .background { Color("MainColor").ignoresSafeArea() }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

