//
//  SettingsViewController.swift
//  choreManagement
//
//  Created by Jon Brown on 11/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var fontSizeSlider: UISlider!
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var fontSliderLabel: UILabel!
    
    @IBOutlet weak var darkSwitch: UISwitch!
    
    var fontSize: CGFloat!
    
    var darkOn: String!

    var settingsLabelSize: CGFloat!
    var darkModeLabelSize: CGFloat!
    var notiLabelSize: CGFloat!
    var fontSliderLabelSize: CGFloat!
    
    
    
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
                            self.fontSizeSlider.value = Float(fontFloat)
                            self.fontSize = CGFloat(Int(self.fontSizeSlider.value))
                            self.updateFonts()
                        }
                        
                        if let darkValue = (data["darkOn"] as? NSString){
                            self.darkOn = String(darkValue)
                            self.updateScreen()
                        }
                    }
                }
        }
        
        settingsLabelSize = settingsLabel.font.pointSize
        darkModeLabelSize = darkModeLabel.font.pointSize
        notiLabelSize = notiLabel.font.pointSize
        fontSliderLabelSize = fontSliderLabel.font.pointSize
    
    }
    
    @IBAction func fontSizeChanged(_ sender: UISlider) {
        fontSize = CGFloat(Int(sender.value))
        updateFonts()
        
        if Auth.auth().currentUser != nil {
            
            db.collection("users").document("\(email)").setData(["fontSize": "\(fontSize.description)"], merge: true)
        }
        
    }
    
    func updateFonts(){
        
        settingsLabel.font = settingsLabel.font.withSize(CGFloat(settingsLabelSize * (fontSize/10)))
        notiLabel.font = notiLabel.font.withSize(CGFloat(notiLabelSize * (fontSize/10)))
        darkModeLabel.font = darkModeLabel.font.withSize(CGFloat(darkModeLabelSize * (fontSize/10)))
        fontSliderLabel.font = fontSliderLabel.font.withSize(CGFloat(fontSliderLabelSize * (fontSize/10)))
    }
    
    func updateScreen(){
        
        
        if (darkOn == "true"){
            settingsLabel.textColor = UIColor.white
            notiLabel.textColor = UIColor.white
            darkModeLabel.textColor = UIColor.white
            fontSliderLabel.textColor = UIColor.white
            
            view.backgroundColor = UIColor.black
            
            darkSwitch.setOn(true, animated: false)
        } else if (darkOn == "false"){
            
            settingsLabel.textColor = UIColor.black
            notiLabel.textColor = UIColor.black
            darkModeLabel.textColor = UIColor.black
            fontSliderLabel.textColor = UIColor.black
            
            view.backgroundColor = UIColor.white
            
            darkSwitch.setOn(false, animated: false)

        }
        
    }
    
    @IBAction func darkModeSwitched(_ sender: Any) {
        
        let docRef = db.collection("users").document("\(email)")
        
        docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        if let darkOn = (data["darkOn"] as? NSString) {
                            if (darkOn == "true"){
                                self.db.collection("users").document("\(self.email)").setData(["darkOn": "false"], merge: true)
                                self.darkOn = "false"
                                self.updateScreen()
                            } else if (darkOn == "false"){
                                self.db.collection("users").document("\(self.email)").setData(["darkOn": "true"], merge: true)
                                self.darkOn = "true"
                                self.updateScreen()
                            }
                        }
                    }
                }
        }
        
    }
    
    
}
