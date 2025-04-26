//
//  MenuViewController.swift
//  Merseyside_bus
//
//  Created by Shivansh Raj on 30/03/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MenuViewController: UIViewController {

    @IBOutlet weak var startJourneyButton: UIButton!

    @IBAction func startJourneyButton(_ sender: UIButton) {
        saveJourneyData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup if needed
    }

    func saveJourneyData() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }

        let db = Firestore.firestore()

        db.collection("journeys").addDocument(data: [
            "userId": user.uid,
            "startTime": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error saving journey: \(error.localizedDescription)")
            } else {
                print("Journey successfully saved to Firestore!")
                
                // Only after journey is saved, move to Map screen
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMap", sender: nil)
                }
            }
        }
    }
}


