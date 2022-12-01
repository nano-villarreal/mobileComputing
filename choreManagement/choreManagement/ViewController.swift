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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!
    
    var fontSize: CGFloat! = 10.0
    
    var darkOn: String!

    var user_rooms_refs: NSArray = []
    var room_names: [String] = []
    
    @IBOutlet weak var myTableView: UITableView!
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
    
    override func viewWillAppear(_ animated: Bool){
        myTableView.dataSource = self
        myTableView.delegate = self
        
    }
    
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
        
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(5)
            UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.badge,.sound]) {
                granted, error in
                if granted {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
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
                            self.myTableView.reloadData()
                        }
                        
                        if let darkValue = (data["darkOn"] as? NSString){
                            self.darkOn = String(darkValue)
                            self.updateScreen()
                            self.myTableView.reloadData()
                        }
                        
                        if let roomList = (data["rooms"] as? NSArray){
                            self.user_rooms_refs = roomList
                            let objCArray = NSMutableArray(array: self.user_rooms_refs)

                            self.room_names = (objCArray as NSArray as? [String])!
                        }
                    }
                }
        }
        
        
        homeLabelSize = homeLabel.font.pointSize
        
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
                        
                        if let roomList = (data["rooms"] as? NSArray){
                            self.user_rooms_refs = roomList
                            let objCArray = NSMutableArray(array: self.user_rooms_refs)

                            self.room_names = (objCArray as NSArray as? [String])!
                            
                            self.myTableView.reloadData()
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
            
            overrideUserInterfaceStyle = .dark
        } else if (darkOn == "false"){
            
            overrideUserInterfaceStyle = .light

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return room_names.count
        return room_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let row = indexPath.row
        let roomName = room_names[row]
        cell.textLabel?.text = "\(roomName)"
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat(homeLabelSize * (fontSize/10)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "roomSegue",
            let destination = segue.destination as? RoomViewController,
            let operatorIndex = myTableView.indexPathForSelectedRow?.row
        {
            destination.roomName = room_names[operatorIndex]
        }
    }
    
}

