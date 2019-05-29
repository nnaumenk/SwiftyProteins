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
    
    func getLigand() {
        let ligand = DataController.currentLigand!
        let url = "http://ligand-expo.rcsb.org/reports/\(ligand.first!)/\(ligand)/\(ligand)_ideal.pdb"
        Alamofire.request(url).responseString { response in
            guard let result = response.result.value else { return }
            
            self.ligandInfo = result
        }
    }
}

extension ProteinViewController {
    
    func atom(_ words: [Substring.SubSequence]) {
        
        let name: String
        let number : Int
        let x: Float
        let y: Float
        let z: Float
        
        //name = String(words[2]).trimmingCharacters(in: CharacterSet.decimalDigits)
        name = String(describing: words[2].first!)
        
        if let element = Int(words[1]) {
            number = element
        } else { return }
        
        if let coord = Float(words[6]) {
            x = coord
        } else { return }
        
        if let coord = Float(words[7]) {
            y = coord
        } else { return }
        
        if let coord = Float(words[8]) {
            z = coord
        } else { return }
        
        let atom = Atom(number: number, name: name, x: x, y: y, z: z)
        DataController.atoms.append(atom)
    }
    
    func connect(_ words: [Substring.SubSequence]) {
        
        let number1: Int
        var number2: Int
        
        if let element = Int(words[1]) {
            number1 = element
        } else { return }
        
        for i in 2 ..< words.count {
            
            if let element = Int(words[i]) {
                number2 = element
            } else { continue }
            
            if DataController.sticks.contains(where: { $0.number1 == number1 && $0.number2 == number2 }) {
                continue
            }
            if number1 > DataController.atoms.count { continue }
            let atom1 = DataController.atoms[number1 - 1]
            let x1 = atom1.x
            let y1 = atom1.y
            let z1 = atom1.z
            
            if number2 > DataController.atoms.count { continue }
            let atom2 = DataController.atoms[number2 - 1]
            let x2 = atom2.x
            let y2 = atom2.y
            let z2 = atom2.z
            
            let stick = Stick(number1: number1, number2: number2, x1: x1, y1: y1, z1: z1, x2: x2, y2: y2, z2: z2)
            
            DataController.sticks.append(stick)
            
        }
    }
    
    func parseData(string: String) {
        
        DataController.atoms = []
        DataController.sticks = []
        
        let strings = string.split(separator: "\n")
        for string in strings {
            let words = string.split(separator: " ")
            switch words[0] {
                
            case "ATOM": atom(words)
            case "CONECT": connect(words)
                
            default: break
            }
        }
        if DataController.atoms.count == 0 {
            showAlertController("ligand error") { action -> Void in
                self.performSegue(withIdentifier: "unwindToProteinListViewController", sender: nil)
            }
        }
        
    }
    
    
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
    
    func drawSticks(radius: CGFloat = 0.04) {
        
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
    
    var ligandInfo: String! {
        didSet(newValue) {
            parseData(string: ligandInfo)
            drawBalls()
            drawSticks()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
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
        print("loaded")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getLigand()
        
        scnView.scene = SCNScene()
        //scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scnView.addGestureRecognizer(tap)
        scnView.isUserInteractionEnabled = true
        //scnView.pointOfView.set
        
        // function which is triggered when handleTap is called
       
        
    }

    
    
    @IBAction func stickThicknessChanged(_ sender: UISlider) {
        removeSticks()
        let thickness = CGFloat(sender.value)
        drawSticks(radius: thickness)
        
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        
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
