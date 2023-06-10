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
    private let id: String
    
    init(_ id: String) {
        self.id = id
        let service = FirebaseService.Instance()
        service.registerEventListener(event: .storageProfileImageUpload) {
            self.loadImageData()
        }
    }
    
    func loadImageData() {
        // the path to the image
        let url = "\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 100 * 1024 * 1024) { data, error in
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
    @ObservedObject private var imageLoader : Loader
    let placeholder = UIImage(named: "DefaultProfilePicture")!

    init(id: String) {
        imageLoader = Loader(id)
        imageLoader.loadImageData()
    }

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        if image != nil {
            Image(uiImage: image!)
                .resizable()
//                .rotationEffect(.degrees(90))
        } else {
            Image(uiImage: placeholder)
                .resizable()
        }
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

class Location {
    public var lat: Double
    public var long: Double
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}

class FirebaseUser {
    public var uid: String
    public var name: String?
    public var email: String?
    public var friends: [String] = []
    public var location: Location?
    
    init(uid: String) {
        self.uid = uid
    }
}

enum FirebaseServiceError: Error {
    case storageError(String)
}

enum FirebaseServiceEvent {
    case storageProfileImageUpload
}

class FirebaseService {
    private static var instance: FirebaseService?
    
    public static func Instance() -> FirebaseService {
        if (instance == nil) {
            instance = FirebaseService()
        }
        return instance!
    }
    
    private var listeners: Dictionary<FirebaseServiceEvent, [() -> Void]> = Dictionary()
    
    func registerEventListener(event: FirebaseServiceEvent, lambda: @escaping () -> Void) {
        listeners[event, default: []].append(lambda)
    }
    
    func createUser(name: String, email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await Firestore.firestore().collection("users").document(authResult.user.uid).setData([
            "name": name,
            "email": email,
            "friends": [String]()
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
    
    private func toFirebaseUser(uid: String, attrs: Dictionary<String, Any>) -> FirebaseUser {
        let firebaseUser = FirebaseUser(uid: uid)
        attrs.forEach { el in
            if el.key == "name" {
                firebaseUser.name = el.value as? String
            } else if el.key == "email" {
                firebaseUser.email = el.value as? String
            } else if el.key == "friends" {
                firebaseUser.friends = el.value as? [String] ?? []
            } else if el.key == "location" {
                let dic = el.value as! Dictionary<String, Double>
                firebaseUser.location = Location(lat: dic["lat"]!, long: dic["long"]!)
            }
        }
        return firebaseUser
    }
    
    func getCurrentUserData() async throws -> FirebaseUser? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        let db = Firestore.firestore()
        guard let userData = try await db.collection("users").document(user.uid).getDocument().data() else {
            return nil
        }
        
        return toFirebaseUser(uid: user.uid, attrs: userData)
    }
    
    func uploadCurrentUserProfileImage(data: Data) async throws -> StorageMetadata? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        let ref = Storage.storage().reference().child("\(user.uid)_profile_pic.png")
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<StorageMetadata, Error>) in
            ref.putData(data, metadata: StorageMetadata(dictionary: [
                "contentType": "image/png"
            ])) { (metadata, error) in
                guard let metadata = metadata else {
                    continuation.resume(throwing: FirebaseServiceError.storageError("uploadCurrentUserProfileImage: No metadata received."))
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let _ = metadata.size
                // You can also access to download URL after upload.
                ref.downloadURL { (url, error) in
                    guard let _ = url else {
                        continuation.resume(throwing: FirebaseServiceError.storageError("uploadCurrentUserProfileImage: No download url link available."))
                        return
                    }
                    self.listeners[.storageProfileImageUpload, default: []].forEach { l in
                        l()
                    }
                    continuation.resume(returning: metadata)
                }
            }
        })
    }
    
//    func getFriends() async throws -> [FirebaseUser] {
//
//    }
//
//    func getOtherPeople() async throws -> [FirebaseUser] {
//
//    }
    
    func getAllUsers() async throws -> [FirebaseUser] {
        let db = Firestore.firestore()
        let usersData = try await db.collection("users").getDocuments().documents
        var users: [FirebaseUser] = []
        usersData.forEach { el in
            let data = el.data()
            users.append(toFirebaseUser(uid: el.documentID, attrs: data))
        }
        return users
    }
    
    func addFriend(uid: String) async throws {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let currentUser = try await getCurrentUserData()
        guard let currentUser = currentUser else {
            return
        }
        let db = Firestore.firestore()
        currentUser.friends.append(uid)
        try await db.collection("users").document(user.uid).updateData([
            "friends": currentUser.friends
        ])
    }
    
    func updateCurrentUserLocation(location: Location) async throws {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let db = Firestore.firestore()
        try await db.collection("users").document(user.uid).updateData([
            "location": [
                "lat": location.lat,
                "long": location.long
            ]
        ])
    }
}
