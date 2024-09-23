//
//  SuggestedViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/11/24.
//

import Foundation
import FirebaseFirestore

class SuggestedViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var searchSuggested = ""
    @Published var suggestions = [Suggestion]()
    public let userId : String
    let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
        fetchSuggestions()
    }
    func fetchSuggestions(){
        db.collection("users")
            .document(userId)
            .collection("suggestions")
            .order(by: "modifiedDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                return
                }
                querySnapshot?.documentChanges.forEach({change in
                    if change.type == .added {
                        let data = change.document.data()
                        let suggestion = Suggestion(
                            id: data["id"] as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            name: data["name"] as? String ?? "",
                            type: data["type"] as? String ?? "",
                            note: data["note"] as? String ?? "",
                            suggestedBy: data["suggestedBy"] as? String ?? "",
                            link: data["link"] as? String ?? "",
                            createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                            modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                        )
                        self.suggestions.append(suggestion)
                    }
                        if change.type == .removed {
                            let data = change.document.data()
                            let id = data["id"] as? String ?? ""
                            self.suggestions = self.suggestions.filter {$0.id != id}
                        }
                        if change.type == .modified {
                            let data = change.document.data()
                            let suggestion = Suggestion(
                                id: data["id"] as? String ?? "",
                                userId: data["userId"] as? String ?? "",
                                name: data["name"] as? String ?? "",
                                type: data["type"] as? String ?? "",
                                note: data["note"] as? String ?? "",
                                suggestedBy: data["suggestedBy"] as? String ?? "",
                                link: data["link"] as? String ?? "",
                                createdDate: data["createdDate"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                modifiedDate: data["modifiedDate"] as? TimeInterval ?? Date().timeIntervalSince1970
                            )
                                self.suggestions.append(suggestion)
                        }
                    })
                }
            }
}
