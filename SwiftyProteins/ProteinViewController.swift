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
    
    func getLigand(fileFormat: String, coordModel: String) {
        
        
        let ligand = DataController.currentLigand!
        let url = "http://ligand-expo.rcsb.org/reports/\(ligand.first!)/\(ligand)/\(ligand)_\(coordModel).\(fileFormat)"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4
        configuration.timeoutIntervalForResource = 4 // seconds
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
        alamofireManager.request(url).responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = response.error {
                self.showAlertController(error.localizedDescription) { action -> Void in
                    self.performSegue(withIdentifier: "unwindToProteinListViewController", sender: nil)
                    return
                }
            }
            
            guard let result = response.result.value else { return }
            
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
        
        //if DataController.s
        
        for stick in DataController.sticks {
            let twoPointsNode = SCNNode()
            scnView.scene?.rootNode.addChildNode(twoPointsNode.buildLineInTwoPointsWithRotation(
                from: SCNVector3(stick.x1, stick.y1, stick.z1), to: SCNVector3(stick.x2, stick.y2, stick.z2), radius: radius, color: .gray))
        }
    }
}

class ProteinViewController: UIViewController {

    var alamofireManager : Alamofire.SessionManager!
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var preferencesView: UIView!
    @IBOutlet weak var stickThickness: UISlider!
    
    @IBOutlet weak var fileFormatSegment: UISegmentedControl!
    @IBOutlet weak var coordModelSegment: UISegmentedControl!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if !preferencesView.isHidden { preferencesView.isHidden = true }
        
        self.title = DataController.currentLigand!
        
        let location = sender.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count < 1 { return }
        
        let node = hitResults[0].node
        
        if !(node.geometry is SCNSphere) { return }
        
        self.title = node.name!

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView.scene = SCNScene()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        
        getLigand(fileFormat: "pdb", coordModel: "ideal")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scnView.addGestureRecognizer(tap)
        scnView.isUserInteractionEnabled = true
    }
    
    @IBAction func stickThicknessChanged(_ sender: UISlider) {
        removeSticks()
        let thickness = CGFloat(sender.value)
        drawSticks(radius: thickness)
        
    }
    
    @IBAction func sourceFileChanged(_ sender: Any) {
        
        let rootNode = scnView.scene?.rootNode
        if let nodes = rootNode?.childNodes {
            for node in nodes {
                node.removeFromParentNode()
            }
        }
        
        let segmentController = sender as! UISegmentedControl
        if segmentController.titleForSegment(at: 0) == "Ideal mode" {
            scnView.scene = SCNScene()
        }
        
        let fileFormat: String!
        let coordModel: String!
        
        switch fileFormatSegment.selectedSegmentIndex {
        
        case 0: fileFormat = "pdb"
        case 1: fileFormat = "sdf"
        
        default: return
        }
        
        switch coordModelSegment.selectedSegmentIndex {
            
        case 0: coordModel = "ideal"
        case 1: coordModel = "model"
            
        default: return
        }
        getLigand(fileFormat: fileFormat, coordModel: coordModel)
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        
    
        if DataController.atoms.isEmpty { return }
        
        if preferencesView.isHidden { preferencesView.isHidden = false }
        else { preferencesView.isHidden = true }
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        
        let image = scnView.snapshot()
        
        let imageShare = [ image ]
    
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.title = DataController.currentLigand!
        if let color = DataController.backgroundColor {
            scnView.backgroundColor = color
        }
    }
    
    @IBAction func unwindToProteinViewController(segue: UIStoryboardSegue) {}
}
