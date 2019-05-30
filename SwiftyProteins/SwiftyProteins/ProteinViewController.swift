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
    
    func getLigand(fileFormat: String, coords: String) {
        
        
        let ligand = DataController.currentLigand!
        let url = "http://ligand-expo.rcsb.org/reports/\(ligand.first!)/\(ligand)/\(ligand)_\(coords).\(fileFormat)"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(url).responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let result = response.result.value else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.dataParser(data: result, fileFormat: fileFormat)
            self.drawBalls()
            self.drawSticks(radius: CGFloat(self.stickThickness!.value))
        }
    }
}




extension ProteinViewController {
    
    func getColor(name: String) -> UIColor {
        
        let colorDarkViolet = UIColor(red: 255, green: 192, blue: 203)
        let colorLightBlue = UIColor(red: 255, green: 192, blue: 203)
        let colorLightOrange = UIColor(red: 255, green: 192, blue: 203)
        let colorBeige = UIColor(red: 255, green: 192, blue: 203)
        let colorViolet = UIColor(red: 255, green: 192, blue: 203)
        let colorDarkGreen = UIColor(red: 255, green: 192, blue: 203)
        let colorDarkOrange = UIColor(red: 255, green: 192, blue: 203)
        let colorPink = UIColor(red: 255, green: 192, blue: 203)
        
        switch name{
        case "H":                                   return UIColor.white
        case "C":                                   return UIColor.black
        case "N":                                   return UIColor.blue
        case "O":                                   return UIColor.red
        case "F", "Cl":                             return UIColor.green
        case "Br":                                  return UIColor.brown
        case "I":                                   return colorDarkViolet
        case "He", "Ne", "Ar", "Xe", "Kr":          return colorLightBlue
        case "P":                                   return colorLightOrange
        case "S":                                   return UIColor.yellow
        case "B":                                   return colorBeige
        case "Li", "Na", "K", "Rb", "Cs":           return colorViolet
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":    return colorDarkGreen
        case "Ti":                                  return UIColor.gray
        case "Fe":                                  return colorDarkOrange
        default:                                    return colorPink
        }
    }
    
    func drawBalls(radius: CGFloat = 0.4) {
        
        for atom in DataController.atoms {
            let sphere = SCNSphere.init(radius: radius)
            let material = SCNMaterial()
            material.diffuse.contents = getColor(name: atom.name)
            sphere.materials = [material]
            
            let node = SCNNode(geometry: sphere)
            node.name = atom.name
            node.position.x = atom.x
            node.position.y = atom.y
            node.position.z = atom.z
            scnView.scene?.rootNode.addChildNode(node)
        }
        
    }
    
    func removeSticks() {
        for node in (scnView.scene?.rootNode.childNodes)! {
            if node.geometry is SCNCylinder {
                node.removeFromParentNode()
            }
        }
    }
    
    func drawSticks(radius: CGFloat) {
        
        for stick in DataController.sticks {
            let twoPointsNode = SCNNode()
            scnView.scene?.rootNode.addChildNode(twoPointsNode.buildLineInTwoPointsWithRotation(
                from: SCNVector3(stick.x1, stick.y1, stick.z1), to: SCNVector3(stick.x2, stick.y2, stick.z2), radius: radius, color: .gray))
        }
    }
}

class ProteinViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var preferencesView: UIView!
    @IBOutlet weak var stickThickness: UISlider!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.title = DataController.currentLigand!
        
        let location = sender.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count < 1 { return }
        
        let node = hitResults[0].node
        
        if !(node.geometry is SCNSphere) { return }
        
        self.title = node.name!
//
//        node.camera = SCNCamera()
////
//        let cameraNode = SCNNode()
////                // 2
//        cameraNode.camera = SCNCamera()
       // scnView.pointOfView?.camera.x
        
//        let x =  node.position.x / 2
//        let y =  node.position.y / 2
//        let z =  node.position.z / 2
        
        
        
        //scnView.pointOfView?.position = SCNVector3(x, y, z)
        
//        scnView.scene?.rootNode.addChildNode(cameraNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView.scene = SCNScene()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        
        getLigand(fileFormat: "pdb", coords: "model")
        
        

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scnView.addGestureRecognizer(tap)
        scnView.isUserInteractionEnabled = true
        //scnView.pointOfView.set
        
        // function which is triggered when handleTap is called
       
        
    }
    http://ligand-expo.rcsb.org/reports/1/10R/10R_ideal.pdb
    http://ligand-expo.rcsb.org/reports/1/10R/10R_model.pdb
    
    @IBAction func stickThicknessChanged(_ sender: UISlider) {
        removeSticks()
        let thickness = CGFloat(sender.value)
        drawSticks(radius: thickness)
        
    }
    
    @IBAction func fileFormatChanged(_ sender: UISegmentedControl) {
        
        let rootNode = scnView.scene?.rootNode
        if let nodes = rootNode?.childNodes {
            for node in nodes {
                node.removeFromParentNode()
            }
        }
        
       // http://ligand-expo.rcsb.org/reports/1/10R/10R_model.sdf
        
        switch sender.selectedSegmentIndex {
            
        case 0: getLigand(fileFormat: "pdb", coords: "ideal")
        case 1: getLigand(fileFormat: "sdf", coords: "ideal")
        
        default: break
        }
        
    }
    
    
    @IBAction func preferencesClicked(_ sender: Any) {
        
        print("1", DataController.sticks.count)
        if preferencesView.isHidden { preferencesView.isHidden = false }
        else { preferencesView.isHidden = true }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.title = DataController.currentLigand!
    }
}
