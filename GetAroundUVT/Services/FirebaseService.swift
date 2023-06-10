//
//  FirebaseService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 27.05.2023.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class Loader : ObservableObject {
    @Published var data: Data? = nil

    init(_ id: String){
        // the path to the image
        let url = "\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

struct FirebaseImage : View {
    let placeholder = UIImage(named: "DefaultProfilePicture")!

    init(id: String) {
        self.imageLoader = Loader(id)
    }

    @ObservedObject private var imageLoader : Loader

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        Image(uiImage: image ?? placeholder)
            .resizable()
    }
}

struct FirebaseUserProfileImage : View {
    private var id: String
    
    init(id: String? = nil) {
        let userId = id ?? Auth.auth().currentUser?.uid
        guard let userId = userId else {
            self.id = ""
            return
        }
        self.id = "\(userId)_profile_pic.png"
    }
    
    var body: some View {
        FirebaseImage(id: id)
    }
}

class FirebaseUser {
    public var uid: String
    public var name: String?
    public var email: String?
    
    init(uid: String) {
        self.uid = uid
    }
}

class FirebaseService {
    private static var instance: FirebaseService?
    
    public static func Instance() -> FirebaseService {
        if (instance == nil) {
            instance = FirebaseService()
        }
        return instance!
    }
    
    func createUser(name: String, email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await Firestore.firestore().collection("users").document(authResult.user.uid).setData([
            "name": name,
            "email": email
        ])
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func addAuthListener(lambda: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            lambda(user != nil)
        }
    }
    
    func getCurrentUserData() async throws -> FirebaseUser? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        let db = Firestore.firestore()
        guard let userData = try await db.collection("users").document(user.uid).getDocument().data() else {
            return nil
        }
        
        let firebaseUser = FirebaseUser(uid: user.uid)
        userData.forEach { el in
            if el.key == "name" {
                firebaseUser.name = el.value as? String
            } else if el.key == "email" {
                firebaseUser.email = el.value as? String
            }
        }
        return firebaseUser
    }
}
