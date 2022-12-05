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
import SwiftUI

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var taskField: UITextField!
    
    var roomLabelSize: CGFloat!
    
    var roomName: String!
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    let email: String = (Auth.auth().currentUser?.email)!
    
    var fontSize: CGFloat!
    
    var darkOn: String!
    
    var task_refs: NSArray = []
    var tasks: [String] = []
    
    var completed_task_refs: NSArray = []
    var completed_tasks:  [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        roomLabel.text = roomName
        
        let docRef2 = db.collection("users").document("\(email)")
        
        docRef2.getDocument { (document, error) in
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
                    }
                }
        }
        
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
                        if let completedTaskList = (data["completed_tasks"] as? NSArray){
                            self.completed_task_refs = completedTaskList
                            let objCArray = NSMutableArray(array: self.completed_task_refs)

                            self.completed_tasks = (objCArray as NSArray as? [String])!
                        }
                    }
                }
        }
        
        roomLabelSize = roomLabel.font.pointSize
        
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTasks), userInfo: nil, repeats: true)
    }
    
    @objc func getTasks(){
        
        let room: String = roomName
        
        let docRef2 = db.collection("users").document("\(email)")
        
        docRef2.getDocument { (document, error) in
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
    
    func updateFonts(){
        
        roomLabel.font = roomLabel.font.withSize(CGFloat(roomLabelSize * (fontSize/10)))
        
    }
    
    func updateScreen(){
        
        if (darkOn == "true"){
            
            overrideUserInterfaceStyle = .dark
            
        } else if (darkOn == "false"){
            
            overrideUserInterfaceStyle = .light

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = tasks[row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat(roomLabelSize * (fontSize/10)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let room: String = roomName
        let taskRef = db.collection("rooms").document("\(room)")
        
        let controller = UIAlertController(
            title: "Would you like to complete this task?",
            message: "Click OK to complete ",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        controller.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (paramAction:UIAlertAction!) in
                    let compTask = self.tasks[indexPath.row]
                    self.tasks.remove(at: indexPath.row)
                    
                    let tempArray = NSArray(array: self.tasks)
                print(type(of:tempArray))
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                print(dateFormatter.string(from: date))
                self.completed_tasks.append("\(compTask) completed by \(self.email) at \(dateFormatter.string(from: date))")
                    let tempCompleted = NSArray(array: self.completed_tasks)
                    print(type(of: tempCompleted))
                print(tempCompleted)
                    taskRef.updateData([
                        "tasks": tempArray,
                        "completed_tasks": tempCompleted
                    ])
                    print("completed task")
            }))
        present(controller, animated: true)
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        if (taskField.text != "") {
            
            let room: String = roomName
            let task: String = taskField.text!
            let taskRef = db.collection("rooms").document("\(room)")
            
            tasks.append(task)
            
            let tempArray = NSArray(array: tasks)
            
            taskRef.updateData([
                "tasks": tempArray
            ])
            
        }
        
    }
    
    
    
    struct Task {
      let title: String
      let user: String
    }
    
  
    
    @IBSegueAction func tasksCompleted(_ coder: NSCoder) -> UIViewController? {
        let listView = ListView(taskList: self.completed_tasks)
        return UIHostingController(coder: coder, rootView: listView)
    }
  
    
    struct ListView: View {
        var tasks: [String]
        init(taskList: [String]) {
               self.tasks = taskList
           }
        
        var body: some View {
            List(tasks, id: \.self) { task in
                 Text(task)
               }.navigationBarTitle("Completed Task List")
        }
    }
    
    
    
}
