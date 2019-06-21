//
//  DataController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

struct DataController {
    
    static var atoms: [Atom] = []
    static var sticks: [Stick] = []
    
    static var currentLigand: String?
    static var allLigands: [String]!
    
    static var backgroundColor: UIColor?
}
