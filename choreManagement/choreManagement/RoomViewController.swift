//
//  RoomViewController.swift
//  choreManagement
//
//  Created by Vineel Mandava on 11/30/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var taskField: UITextField!
    
    var roomName: String!
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    var task_refs: NSArray = []
    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        roomLabel.text = roomName
        
        let docRef = db.collection("rooms").document("\(roomName)")
        
        docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        
                        
                        if let taskList = (data["tasks"] as? NSArray){
                            self.task_refs = taskList
                            let objCArray = NSMutableArray(array: self.task_refs)

                            self.tasks = (objCArray as NSArray as? [String])!
                        }
                    }
                }
        }
        
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTasks), userInfo: nil, repeats: true)
    }
    
    @objc func getTasks(){
        
        let room: String = roomName
        
        let docRef = db.collection("rooms").document("\(room)")
        
        docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        
                        
                        if let taskList = (data["tasks"] as? NSArray){
                            self.task_refs = taskList
                            let objCArray = NSMutableArray(array: self.task_refs)

                            self.tasks = (objCArray as NSArray as? [String])!
                            
                            self.myTableView.reloadData()
                        }
                    }
                }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = tasks[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        if (taskField.text != "") {
            
            let room: String = roomName
            let task: String = taskField.text!
            let taskRef = db.collection("rooms").document("\(room)")
            
            tasks.append(task)
            
            let tempArray = NSArray(array: tasks)

            taskRef.setData([
                "tasks": tempArray
            ])

        }
        
    }
    

}
