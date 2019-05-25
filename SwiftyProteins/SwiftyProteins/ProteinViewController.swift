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
import SceneKit

extension ProteinViewController {
    
    func getLigandInformation() {
        let ligand = DataController.currentLigand!
        let url = "http://ligand-expo.rcsb.org/reports/\(ligand.first!)/\(ligand)/\(ligand)_ideal.pdb"
        Alamofire.request(url).responseData { response in
            if let data = response.data {
                print(data)
            }
            print(response.result.value)
        }
    }
}

extension ProteinViewController {
    
    func drawLigand() {
        
        let scene = SCNScene()
        scnView.autoenablesDefaultLighting = true
        
        // 1
        let sphere1 = SCNSphere.init(radius: CGFloat(0.5))
        let sphereNode1 = SCNNode(geometry: sphere1)
        sphereNode1.position.x = 0
        sphereNode1.position.y = 0
        sphereNode1.position.z = 0
        sphereNode1.light = SCNLight.init()
        sphereNode1.light?.color = UIColor.red
       // print("123", sphereNode1.light?.color)
        scene.rootNode.addChildNode(sphereNode1)
        
        
        
        // 2
        let sphere2 = SCNSphere.init(radius: CGFloat(0.5))
        let sphereNode2 = SCNNode(geometry: sphere2)
        sphereNode2.position.x = -1.208
        sphereNode2.position.y = 0
        sphereNode2.position.z = 0
        sphereNode2.light = SCNLight.init()
        sphereNode2.light?.color = UIColor.black
        //print("123", sphereNode2.light?.color)
        scene.rootNode.addChildNode(sphereNode2)
        
        // 3
        let sphere3 = SCNSphere.init(radius: CGFloat(0.5))
        let sphereNode3 = SCNNode(geometry: sphere3)
        sphereNode3.position.x = 1.208
        sphereNode3.position.y = 0
        sphereNode3.position.z = 0
        sphereNode3.light = SCNLight.init()
        sphereNode3.light?.color = UIColor.black

        
        //print("123", sphereNode3.light?.color)
        scene.rootNode.addChildNode(sphereNode3)
        
        scnView.scene = scene
        
        //scnView.allowsCameraControl = true
    }
}

class ProteinViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    
    override func viewDidAppear(_ animated: Bool) {
        drawLigand()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("lig", DataController.currentLigand!)
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
}
