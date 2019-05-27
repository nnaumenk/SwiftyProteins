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
        
        name = String(words[2]).trimmingCharacters(in: CharacterSet.decimalDigits)
        
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
            let atom1 = DataController.atoms[number1 - 1]
            let x1 = atom1.x
            let y1 = atom1.y
            let z1 = atom1.z
            
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
        print("1", strings)
        for string in strings {
            let words = string.split(separator: " ")
            switch words[0] {
                
            case "ATOM": atom(words)
            case "CONECT": connect(words)
                
            default: break
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
    
    func drawLigand() {
        
        let scene = SCNScene()
        scnView.autoenablesDefaultLighting = true
        
        for atom in DataController.atoms {

            let sphere = SCNSphere.init(radius: CGFloat(0.4))
            let material = SCNMaterial()
            material.diffuse.contents = getColor(name: atom.name)
            sphere.materials = [material]
            
            let node = SCNNode(geometry: sphere)
            node.position.x = atom.x
            node.position.y = atom.y
            node.position.z = atom.z
            scene.rootNode.addChildNode(node)
        }
        
        print("123", DataController.sticks)
        
        for stick in DataController.sticks {
            
            let twoPointsNode = SCNNode()
            scene.rootNode.addChildNode(twoPointsNode.buildLineInTwoPointsWithRotation(
                from: SCNVector3(stick.x1, stick.y1, stick.z1), to: SCNVector3(stick.x2, stick.y2, stick.z2), radius: 0.04, color: .black))
            
        }
        
     
       
        //end
        
        
        
     

    
        
        scnView.scene = scene
        
        //scnView.allowsCameraControl = true
    }
}

class ProteinViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    
    var ligandInfo: String! {
        didSet(newValue) {
            parseData(string: ligandInfo)
            drawLigand()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLigand()
        
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
