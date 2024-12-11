//
//  ItemViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class ItemViewViewModel: ObservableObject {
    @Published var showingEditItemView = false
    @Published var savedItems = [String]()
    @Published var imageProfileUrl = ""

    public let userId : String
    public let item: Item
    let db = Firestore.firestore()
    
    init(userId: String, item: Item) {
        self.userId = userId
        self.item = item
        fetchProfilePhoto()
    }
    func saveItem() {
        let newId = UUID().uuidString
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        print(uId)
        db.collection("users")
            .document(uId)
            .collection("savedItems")
            .document(newId)
            .setData(item.asDictionary())
        self.savedItems.append(item.id)

    }
    func fetchProfilePhoto(){
        db.collection("users")
            .document(userId)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    self.imageProfileUrl = document.get("imageProfileUrl") as? String ?? ""
                }
            }
    }
}
