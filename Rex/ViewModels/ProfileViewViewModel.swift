//
//  ProfileViewViewModel.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import FirebaseStorage

class ProfileViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var currentUser: User?
    @Published var showingSettingsView = false
    @Published var showingNewBoardView = false
    @Published var showingUserBoardsView = true
    @Published var showingSavedRexView = false
    @Published var selectedProfileView = "UserBoardsView"
    @Published var searchBoards = ""
    @Published var boards = [Board]()
    @Published var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil
    //DO NOT DELETE THESE COMMENTS, WILL NEED FOR UPDATING PROFILE IMAGE
{
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self){
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    saveImage()
                    return
                }
            }
        }
    }
    func saveImage() {
        let storage = Storage.storage()
        let ref = storage.reference(withPath: userId)
        guard let imageData = self.selectedImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.errorMessage = "Failed to push image to storage: \(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    self.errorMessage = "Failed to retriece downloadURL: \(err)"
                    return
                }
                guard let url = url else { return }
                self.updateProfilePhoto(imageProfileUrl: url)
            }
        }
    }
    private func updateProfilePhoto(imageProfileUrl: URL) {
            db.collection("users")
            .document(userId).updateData([
                "imageProfileUrl": imageProfileUrl.absoluteString])
    }
    public let userId : String
    let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        db.collection("users")
            .document(userId)
            .addSnapshotListener { querySnapshot, error in
                guard let data = querySnapshot?.data() else {
                    self.errorMessage = "Failed to listen for new Boards: \(error)"
                    print(error)
                    return
                }
                self.currentUser = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    nickname: data["nickname"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    followers: data["followers"] as? Array<String> ?? [],
                    following: data["following"] as? Array<String> ?? [],
                    imageProfileUrl: data["imageProfileUrl"] as? String ?? "")
            }
    }
                                                       
    func delete(id: String){
        
        db.collection("users")
            .document(userId)
            .collection("boards")
            .document(id)
            .delete()
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
