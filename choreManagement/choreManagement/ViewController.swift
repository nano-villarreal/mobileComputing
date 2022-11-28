//
//  ViewController.swift
//  choreManagement
//
//  Created by Nano Villarreal on 10/26/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class ViewController: UIViewController{
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!
    
    var fontSize: CGFloat!
    
    var darkOn: String!

    @IBOutlet weak var visualEffectView: UIVisualEffectView!    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var joinButtonSize: CGFloat!
    var homeLabelSize: CGFloat!
    var createButtonSize: CGFloat!
    var logOutButtonSize: CGFloat!
    
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
        
        let docRef = db.collection("users").document("\(email)")
        
        docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        if let fontFloat = (data["fontSize"] as? NSString)?.doubleValue {
                            self.fontSize = CGFloat(Int(fontFloat))
                            self.updateFonts()
                        }
                        
                        if let darkValue = (data["darkOn"] as? NSString){
                            self.darkOn = String(darkValue)
                            self.updateScreen()
                        }
                    }
                }
        }
        
        joinButtonSize = joinButton.titleLabel?.font.pointSize
        homeLabelSize = homeLabel.font.pointSize
        createButtonSize = createButton.titleLabel?.font.pointSize
        logOutButtonSize = logOutButton.titleLabel?.font.pointSize
        
        scheduledTimerWithTimeInterval()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.newSettings), userInfo: nil, repeats: true)
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
    
    @objc func newSettings(){
        let docRef = db.collection("users").document("\(email)")
        
        docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        if let fontFloat = (data["fontSize"] as? NSString)?.doubleValue {
                            self.fontSize = CGFloat(Int(fontFloat))
                            self.updateFonts()
                        }
                        
                        if let darkValue = (data["darkOn"] as? NSString){
                            self.darkOn = String(darkValue)
                            self.updateScreen()
                        }
                    }
                }
        }
    }
    
    func updateFonts(){
        
        homeLabel.font = homeLabel.font.withSize(CGFloat(homeLabelSize * (fontSize/10)))
        
    }
    
    func updateScreen(){
        
        
        if (darkOn == "true"){
            
            homeLabel.textColor = UIColor.white
            view.backgroundColor = UIColor.black
            
        } else if (darkOn == "false"){
            
            homeLabel.textColor = UIColor.black
            view.backgroundColor = UIColor.white

        }
        
    }
    
}

