//
//  ProteinListViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

extension ProteinListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allLigands = DataController.allLigands
            tableViewLigand.reloadData()
            return
        }
        
        allLigands = DataController.allLigands.filter({
            if ($0.lowercased().contains(searchText.lowercased())) {
                return true
            }
            return false
        })
        tableViewLigand.reloadData()
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

    var allLigands: [String]!
    @IBOutlet weak var tableViewLigand: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.hidesSearchBarWhenScrolling = false
        //searchBar.hidesSearchBarWhenScrolling = false
        allLigands = DataController.allLigands
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProteinListViewController(segue: UIStoryboardSegue) {
        
    }
    
}
