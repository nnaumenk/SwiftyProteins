//
//  ColorManagerViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 6/1/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class ColorManagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBAction func saveColor(_ sender: Any) {
        
        DataController.backgroundColor = label.backgroundColor!
        performSegue(withIdentifier: "unwindToProteinViewControllerWithSegue", sender: nil)
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        label.backgroundColor = color
    }
    
}
