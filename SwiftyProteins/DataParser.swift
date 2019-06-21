//
//  DataParser.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/30/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

extension ProteinViewController {
    
    func atomPDB(_ words: [Substring.SubSequence]) {
        
        let name: String
        let x: Float
        let y: Float
        let z: Float
        
        name = String(describing: words[2].first!)
        
        if let coord = Float(words[6]) {
            x = coord
        } else { return }
        
        if let coord = Float(words[7]) {
            y = coord
        } else { return }
        
        if let coord = Float(words[8]) {
            z = coord
        } else { return }
        
        let atom = Atom(name: name, x: x, y: y, z: z)
        DataController.atoms.append(atom)
    }
    
    func atomSDF(_ words: [Substring.SubSequence]) {
        
        let name: String
        let x: Float
        let y: Float
        let z: Float
        
        name = String(words[3])
     
        if let coord = Float(words[0]) {
            x = coord
        } else { return }
        
        if let coord = Float(words[1]) {
            y = coord
        } else { return }
        
        if let coord = Float(words[2]) {
            z = coord
        } else { return }
        
        let atom = Atom(name: name, x: x, y: y, z: z)
        DataController.atoms.append(atom)
    }
    
    func connectPDB(_ words: [Substring.SubSequence]) {
        
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
    
    func connectSDF(_ words: [Substring.SubSequence]) {
        
        let number1: Int
        var number2: Int
        
        if let element = Int(words[0]) {
            number1 = element
        } else { return }
        
        if let element = Int(words[1]) {
            number2 = element
        } else { return }
        
        if number1 > DataController.atoms.count { return }
        let atom1 = DataController.atoms[number1 - 1]
        let x1 = atom1.x
        let y1 = atom1.y
        let z1 = atom1.z
            
        if number2 > DataController.atoms.count { return }
        let atom2 = DataController.atoms[number2 - 1]
        let x2 = atom2.x
        let y2 = atom2.y
        let z2 = atom2.z
            
        let stick = Stick(number1: number1, number2: number2, x1: x1, y1: y1, z1: z1, x2: x2, y2: y2, z2: z2)
            
        DataController.sticks.append(stick)
            
    }
    
    func dataParserPDB(lines: [String.SubSequence]) {
        
        for line in lines {
            let words = line.split(separator: " ")
            switch words[0] {
                
            case "ATOM": atomPDB(words)
            case "CONECT": connectPDB(words)
                
            default: break
            }
        }
        
    }
    
    func dataParserSDF(lines: [String.SubSequence]) {
        
        for line in lines {
            let words = line.split(separator: " ")
            switch words.count {
                
            case 9: atomSDF(words)
            case 6: connectSDF(words)
                
            default: break
            }
        }
        
    }
    
    func dataParser(data: String, fileFormat: String) {
        
        DataController.atoms = []
        DataController.sticks = []
        
        let lines = data.split(separator: "\n")
        switch fileFormat {
        case "pdb": dataParserPDB(lines: lines)
        case "sdf": dataParserSDF(lines: lines)
            
        default: break
        }
        
        
        
        
        if DataController.atoms.count == 0 {
            showAlertController("ligand error") { action -> Void in
                self.performSegue(withIdentifier: "unwindToProteinListViewController", sender: nil)
            }
        }
        
    }
}
