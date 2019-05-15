//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/15/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import LocalAuthentication

extension LoginViewController {
    
}



extension LoginViewController {
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}



extension LoginViewController {
    
    func checkTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isAvailableTouchID = true
        } else {
            isAvailableTouchID = false
        }
    }
    
}



class LoginViewController: UIViewController {

    /////////////////////////////////////////////////////////// outlets
    
    @IBOutlet weak var textBoxLogin: UITextField!
    @IBOutlet weak var textBoxPassword: UITextField!
    @IBOutlet weak var buttonTouchID: UIButton!
    
    /////////////////////////////////////////////////////////// outlets
    
    
    
    ////////////////////////////////////////////////////////// other prosperties
    var isAvailableTouchID: Bool! {
        willSet(newValue) {
            if newValue == false {
                buttonTouchID.isEnabled = false
                buttonTouchID.isHidden = true
            }
        }
    }
    ////////////////////////////////////////////////////////// other prosperties

    
    
    ////////////////////////////////////////////////////////// actions
    
    @IBAction func buttonPressedTouchID(_ sender: Any) {
        textBoxLogin.isEnabled = false
        textBoxPassword.isEnabled = false
        buttonTouchID.isEnabled = false
        
        let context = LAContext()
        let reason = "Authenticate with Touch ID"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {(success, error) in
            if success {
                self.showAlertController("authentication succeeded")
            }
            else {
                self.showAlertController("authentication failed")
            }
            self.textBoxLogin.isEnabled = true
            self.textBoxPassword.isEnabled = true
            self.buttonTouchID.isEnabled = true
        })
    }
    
    @IBAction func buttonPressedNext(_ sender: Any) {
        
        if (textBoxLogin.text?.isEmpty)! {
            print("no login")
            return
        }
        
        if (textBoxPassword.text?.isEmpty)! {
            print("no Password")
            return
        }
        
        
        performSegue(withIdentifier: "segueToProteinListViewController", sender: nil)
    }
    
    ///////////////////////////////////////////////////////// actions
    
    
    
    ////////////////////////////////////////////////////// view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        checkTouchID()
        
       // readAllProteins()
    
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///////////////////////////////////////////////////// view life cycle
}

