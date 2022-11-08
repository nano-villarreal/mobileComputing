//
//  LoginViewController.swift
//  choreManagement
//
//  Created by Jon Brown on 10/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    var db: Firestore!

    @IBOutlet weak var userIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var confirmLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var loginSegCtrl: UISegmentedControl!
    
    var segString = "Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmLabel.text = ""
        loginButton.setTitle("Sign In", for: .normal)
        confirmPasswordField.isHidden = true
        
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true

        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.userIDField.text = nil
                self.passwordField.text = nil
                self.confirmPasswordField.text = nil
            }
        }
    }
    
    @IBAction func loginSegPressed(_ sender: Any) {
        switch loginSegCtrl.selectedSegmentIndex {
        case 0:
            segString = "Login"
            confirmLabel.text = ""
            loginButton.setTitle("Sign In", for: .normal)
            confirmPasswordField.isHidden = true
        case 1:
            segString = "Sign Up"
            confirmLabel.text = "Confirm Password"
            loginButton.setTitle("Sign Up", for: .normal)
            confirmPasswordField.isHidden = false
        default:
            segString = "Login"
            confirmLabel.text = "Confirm Password"
            loginButton.setTitle("Sign Up", for: .normal)
            confirmPasswordField.isHidden = true
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if (segString == "Login"){
            Auth.auth().signIn(withEmail: userIDField.text!, password: passwordField.text!) {
                authResult, error in
                if let error = error as NSError? {
                    self.errorMessage.text = "\(error.localizedDescription)"
                } else {
                    self.errorMessage.text = ""
                }
            }
        } else {
            
            if (passwordField.text == confirmPasswordField.text){
                Auth.auth().createUser(withEmail: userIDField.text!, password: passwordField.text!) {
                    authResult, error in
                    if let error = error as NSError? {
                        self.errorMessage.text = "\(error.localizedDescription)"
                    } else {
                        self.errorMessage.text = ""
                    }
                }
            } else {
                self.errorMessage.text = "Passwords do not match"
            }
            
            db.collection("users").document("\(userIDField.text!)").setData([
                "username": "\(userIDField.text!)",
                "password": "\(passwordField.text!)",
                "rooms": []
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
        }
    }
    
}
