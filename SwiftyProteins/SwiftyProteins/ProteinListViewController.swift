//
//  ProteinListViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
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
