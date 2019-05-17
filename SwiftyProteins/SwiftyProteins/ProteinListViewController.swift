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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewLigand: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allLigands = DataController.allLigands
    }
  
//    override func viewWillAppear(_ animated: Bool) {
//         self.navigationController?.isNavigationBarHidden = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
//    applicationWillResignActive:(UIApplication *)application
//    {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    }

}
