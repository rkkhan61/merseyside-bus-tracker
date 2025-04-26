//
//  ViewController.swift
//  Merseyside_bus
//
//  Created by Shivansh Raj on 30/03/2025.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    func saveUserToFirestore() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("user information").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                print("User already exists in Firestore")
            } else {
                userRef.setData([
                    "uid": user.uid,
                    "name": user.displayName ?? "",
                    "email": user.email ?? "",
                    "joined": Timestamp()
                ]) { err in
                    if let err = err {
                        print("Error writing user to Firestore: \(err)")
                    } else {
                        print("New user added to Firestore successfully!")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton! // <- This is OK if you have another use for it

    @IBAction func googleButton(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let presentingVC = UIApplication.shared.windows.first?.rootViewController else {
            print("Error: Unable to get root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Missing user or ID Token")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }

                print("Firebase sign-in success!")
                print("User logged in: \(Auth.auth().currentUser?.email ?? "No user")")
                
                // Save user info to Firestore
                self.saveUserToFirestore()

                // ✅ Now move to Menu screen after everything is successful
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMenu", sender: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


