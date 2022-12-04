//
//  JoinViewController.swift
//  choreManagement
//
//  Created by Vineel Mandava on 11/30/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class JoinViewController: UIViewController {
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!
    
    var fontSize: CGFloat!
    
    var darkOn: String!
    
    var checkPW: String!
    
    @IBOutlet weak var roomInfoLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var roomInfoSize: CGFloat!
    var roomNameSize: CGFloat!
    var passwordSize: CGFloat!
    var joinedSize: CGFloat!
    
    var room_refs: NSArray = []
    var rooms: [String] = []
    
    var clicked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinedLabel.isHidden = true
        passwordField.isSecureTextEntry = true

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
                        
                        if let roomList = (data["rooms"] as? NSArray){
                            self.room_refs = roomList
                            let objCArray = NSMutableArray(array: self.room_refs)

                            self.rooms = (objCArray as NSArray as? [String])!
                        }
                    }
                }
        }
        
        roomInfoSize = roomInfoLabel.font.pointSize
        roomNameSize = roomNameLabel.font.pointSize
        passwordSize = passwordLabel.font.pointSize
        joinedSize = joinedLabel.font.pointSize
        
        scheduledTimerWithTimeInterval()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.newSettings), userInfo: nil, repeats: true)
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
        
        if (clicked == true) && (passwordField.text == checkPW){
            
            db.collection("users").document("\((Auth.auth().currentUser?.email)!)").getDocument { (document, error) in
                    guard error == nil else {
                        print("error", error ?? "")
                        return
                    }

                    if let document = document, document.exists {
                        let data = document.data()
                        if let data = data {
                            
                            
                            if let roomsList = (data["rooms"] as? NSArray){
                                self.room_refs = roomsList
                                let objCArray = NSMutableArray(array: self.room_refs)

                                self.rooms = (objCArray as NSArray as? [String])!
                            }
                        }
                    }
            }
            
            let roomName: String = roomNameField.text!
            rooms.append(roomName)
            
            let tempArray = NSArray(array: rooms)
            
            db.collection("users").document("\((Auth.auth().currentUser?.email)!)").updateData([
                "rooms": tempArray
            ])
            
            if notificationsOn{
                let content = UNMutableNotificationContent()
                content.title = "You have joined a room"
                content.body = "Now joining \(self.roomNameField.text ?? "") "
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8.0, repeats: false)
                let request = UNNotificationRequest(identifier: "myJoinNotification", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                print("Notifying")
            }
           
            joinedLabel.isHidden = false
            checkPW = ""
            
        }
        clicked = false
    }
    
    func updateFonts(){
        
        roomNameLabel.font = roomNameLabel.font.withSize(CGFloat(roomNameSize * (fontSize/10)))
        roomInfoLabel.font = roomInfoLabel.font.withSize(CGFloat(roomInfoSize * (fontSize/10)))
        passwordLabel.font = passwordLabel.font.withSize(CGFloat(passwordSize * (fontSize/10)))
        joinedLabel.font = joinedLabel.font.withSize(CGFloat(joinedSize * (fontSize/10)))
    }
    
    func updateScreen(){
        
        
        if (darkOn == "true"){
            
            overrideUserInterfaceStyle = .dark
            
        } else if (darkOn == "false"){
            
            overrideUserInterfaceStyle = .light

        }
        
    }
    
    @IBAction func joinPressed(_ sender: Any) {
        
        clicked = true
        
        if (roomNameField.text != "") && (passwordField.text != ""){
            let docRef = db.collection("rooms").document("\((roomNameField.text)!)")

            docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        if let password = (data["password"] as? String){
                            self.checkPW = password
                        }
                    }
                }
            }

        }
    }
}
