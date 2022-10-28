//
//  ViewController.swift
//  choreManagement
//
//  Created by Nano Villarreal on 10/26/22.
//

import UIKit
import FirebaseAuth
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }
    
}

