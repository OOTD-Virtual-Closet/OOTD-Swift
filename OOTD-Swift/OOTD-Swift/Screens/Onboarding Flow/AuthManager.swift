//
//  AuthManager.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/18/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
    }
}
final class AuthManager {
    static let shared = AuthManager()
    private init() {
        
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> FirebaseAuth.User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authDataResult.user
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signout() throws {
       try Auth.auth().signOut()
    }
    
    func changePassword(password: String) throws {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            /*
            if let error = error {
                //there was an error
            }
             */
        }
    }
    
    
    func verifyDelete() throws {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = Auth.auth().currentUser {
                user.sendEmailVerification();
                if user.isEmailVerified {
                    user.delete { error in
                    }
                    print("email is verified and account deleted")
                    
                } else {
                    print("not verified")
                }
            }
        }
    }
    
}
