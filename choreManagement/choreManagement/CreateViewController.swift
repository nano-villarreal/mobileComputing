//
//  CreateViewController.swift
//  choreManagement
//
//  Created by Vineel Mandava on 11/30/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class CreateViewController: UIViewController {
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!
    
    var fontSize: CGFloat!
    
    var darkOn: String!
    
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var roomInfoLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPWLabel: UILabel!
    
    var yourNameSize: CGFloat!
    var roomInfoSize: CGFloat!
    var roomNameSize: CGFloat!
    var passwordSize: CGFloat!
    var confirmPWSize: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        yourNameSize = yourNameLabel.font.pointSize
        roomInfoSize = roomInfoLabel.font.pointSize
        roomNameSize = roomNameLabel.font.pointSize
        passwordSize = passwordLabel.font.pointSize
        confirmPWSize = confirmPWLabel.font.pointSize

        
        scheduledTimerWithTimeInterval()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.newSettings), userInfo: nil, repeats: true)
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
        
        yourNameLabel.font = yourNameLabel.font.withSize(CGFloat(yourNameSize * (fontSize/10)))
        roomNameLabel.font = roomNameLabel.font.withSize(CGFloat(roomNameSize * (fontSize/10)))
        roomInfoLabel.font = roomInfoLabel.font.withSize(CGFloat(roomInfoSize * (fontSize/10)))
        passwordLabel.font = passwordLabel.font.withSize(CGFloat(passwordSize * (fontSize/10)))
        confirmPWLabel.font = confirmPWLabel.font.withSize(CGFloat(confirmPWSize * (fontSize/10)))
    }
    
    func updateScreen(){
        
        
        if (darkOn == "true"){
            
            overrideUserInterfaceStyle = .dark
            
        } else if (darkOn == "false"){
            
            overrideUserInterfaceStyle = .light

        }
        
    }

}
