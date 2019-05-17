//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import Alamofire

class ProteinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("lig", DataController.currentLigand!)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        //let url = "http://www.rcsb.org/pdb/rest/describeHet?chemicalID=" + DataController.currentLigand!
        let url = "http://www.rcsb.org/pdb/rest/describeHet?chemicalID=04g"
        Alamofire.request(url).responseString { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
            print(response.value as Any)
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
