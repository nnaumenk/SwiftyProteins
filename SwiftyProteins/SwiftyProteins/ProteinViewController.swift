//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class ProteinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("lig", DataController.currentLigand!)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        let url = "http://www.rcsb.org/pdb/rest/describeHet?chemicalID=" + DataController.currentLigand!
        Alamofire.request(url).responseData { response in
            if let data = response.data {
                let xml = XML.parse(data)
                if let element = xml["describeHet"]["ligandInfo"]["ligand"].attributes["molecularWeight"] {
                    print("weight=", element)
                }
                if let element = xml["describeHet"]["ligandInfo"]["ligand"]["formula"].text {
                    print("formula=", element)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
