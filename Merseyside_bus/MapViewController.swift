//
//  MapViewController.swift
//  Merseyside_bus
//
//  Created by Shivansh Raj on 30/03/2025.
//

import UIKit
import FirebaseFirestore

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var busNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        fetchBusRoutes()
    }

    func fetchBusRoutes() {
        let db = Firestore.firestore()

        db.collection("routes").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching routes: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let busName = document.documentID // Bus name is document ID
                        self.busNames.append(busName)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - TableView DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusCell", for: indexPath)
        cell.textLabel?.text = busNames[indexPath.row]
        return cell
    }

    // MARK: - TableView Delegate Methods (optional for now)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBus = busNames[indexPath.row]
        print("Selected bus: \(selectedBus)")
        // (Later you can show stops for this selected bus)
    }
}

