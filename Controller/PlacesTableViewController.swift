//
//  PlacesTableViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 12/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    var allAdventures: [Adventure] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        getAllAdventures()
    }

    func getAllAdventures(){
        let child = SpinnerViewController()
        SpinnerViewController.shared.startSpinner(targetViewController: self)
        DatabaseService.shared.getAllAdventuresFromDB(userID: (AuthenticationService.shared.currentUser?.uid)!) {(adventuresFromService) in
            self.allAdventures = adventuresFromService
            self.tableView.reloadData()
            SpinnerViewController.shared.stopSpinner()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAdventures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adventureCell") as! AdventureCell
        cell.adventureCellLabel.text = self.allAdventures[indexPath.row].locationName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showAdventureDetailsSegue" {
            let adventureDetailsViewController = segue.destination as! AdventureDetailsViewController
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                adventureDetailsViewController.adventureIDFromTableView = allAdventures[selectedIndex].adventureID
            } else {
                print("Prepare in PlacesTableView: could not get index of selected row in the tableview")
            }
        }
    }
}
