//
//  ProteinListViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

extension ProteinListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
extension ProteinListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataController.currentLigand = allLigands[indexPath.row]
        performSegue(withIdentifier: "segueToProteinViewController", sender: nil)
    }
    
    
    
}

extension ProteinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLigands.count
        //return DataController.allProteins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProteinListCell")!
        
        let ligand = allLigands[indexPath.row]
        cell.detailTextLabel?.text = ligand
        cell.textLabel?.text = ligand
        return cell
    }
}

class ProteinListViewController: UIViewController {

    var filterLigands = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        
//        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Candies"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
        
        //print("123", DataController.allProteins)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
