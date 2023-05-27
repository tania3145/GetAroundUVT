//
//  FirebaseService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 27.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
}
