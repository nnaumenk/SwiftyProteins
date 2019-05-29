//
//  AlertController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/29/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func showAlertController(_ message: String, _ handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alertController, animated: true, completion: nil)
    }
    
}
