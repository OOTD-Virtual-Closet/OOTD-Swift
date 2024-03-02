//
//  LoginViewModel.swift
//  OOTD-Swift
//
//  Created by Rishabh Pandey on 2/20/24.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LogInVM: ObservableObject {

    @Published var isLogin: Bool = false
    
    func signUpWithGoogle(completion: @escaping (Bool) -> Void) {

        // get app client id
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Firebase ClientID is not available.")
            completion(false)
            return
        }
        
        // get configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // sign in
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) {
            [unowned self] result, error in

            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken:user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                if let err = error {
                    print(err.localizedDescription)
                    completion(false)
                    return
                }

                if let user = result?.user {
                    print(user.displayName ?? "No Display Name.")
                    self.isLogin.toggle()
                    UserDefaults.standard.set(user.email, forKey: "email")
                    UserDefaults.standard.set(user.uid, forKey: "uid")

                }
            }
        }
    }
}
