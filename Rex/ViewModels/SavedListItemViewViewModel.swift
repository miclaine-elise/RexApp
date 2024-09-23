//
//  SavedListItemViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/2/24.
//

import Foundation
import FirebaseFirestore
class SavedListItemViewViewModel: ObservableObject {
    @Published var nickName = ""
    @Published var boardName = ""
    public let item: Item
    let db = Firestore.firestore()
    
    init(item: Item){
        self.item = item
        fetchItemInfo()
        print(item.boardId)
    }
    func fetchItemInfo(){
        db.collection("users")
            .document(item.userId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    print(error)
                    return
                }
                self.nickName =  data["nickname"] as? String ?? ""
            }
        db.collection("users")
            .document(item.userId)
            .collection("boards")
            .document(item.boardId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    print(error)
                    return
                }
                
                self.boardName =  data["name"] as? String ?? ""
            }
        
    }
}
