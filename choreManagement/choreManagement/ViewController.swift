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

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = ""
        let titleText = "Welcome"
        var charIndex = 0.0
        for letter in titleText {
            
            Timer.scheduledTimer(withTimeInterval: 0.32 * charIndex, repeats: false) { (timer) in
                self.welcomeLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.animateOut()
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.visualEffectView.removeFromSuperview()
        }
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

