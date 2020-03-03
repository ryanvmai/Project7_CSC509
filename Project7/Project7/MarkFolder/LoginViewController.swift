//
//  LoginViewController.swift
//  Project7
//
//  Created by Mark Witt on 3/2/20.
//  Copyright © 2020 CSC509. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var studentId:Int = Int()
    var isLoggedIn:Bool = Bool()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var studentList = [Student]()
    var firstnames = [String]()
    var lastnames = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        let urlString = "https://summer-session-api.herokuapp.com/students"
            if let url = URL(string: urlString) {
              if let data = try? Data(contentsOf: url) {
                parseStudents(json: data)
              } else {
                print("error getting data")
              }
            }
        for student in studentList{
            firstnames.append(student.firstname)
            lastnames.append(student.lastname)
            print(studentList.count)
        }

        studentId = defaults.integer(forKey: "user")
        isLoggedIn = defaults.bool(forKey: "loggedIn")
        if isLoggedIn == true{
            performSegue(withIdentifier: "login", sender: nil)
        }
    loginButton.layer.cornerRadius = 10
        registerForKeyboardNotifications()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let firstname = firstNameTextField.text
        let lastname = lastNameTextField.text
        
        if firstname == "" || lastname == ""{
            return
        }
        DoLogin(firstname!, lastname!)
    }
    func DoLogin(_ first:String,_ last:String){
        if let i: Int = firstnames.firstIndex(of: first)  {
            let lastname = lastnames[i]
            if lastname == last{
                performSegue(withIdentifier: "login", sender: nil)
                defaults.set(true, forKey: "loggedIn")
                defaults.set(i+1, forKey: "user")
                print(studentId)
            } else {
                LoginError()
            }
        } else {
            LoginError()
        }
    }
    func LoginError(){
        let invalidLoginAlert = UIAlertController(title: "Uh Oh", message:
            "Either your username or password are incorrect", preferredStyle: .alert)
        invalidLoginAlert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(invalidLoginAlert, animated: true, completion: nil)
    }
    
    
    func parseStudents(json: Data) {
    let decoder = JSONDecoder()
    if let jsonStudents = try? decoder.decode(Students.self, from: json) {
        studentList = jsonStudents.students
        
        print("successfully loaded student name data")
        } else {
            print("error decoding student name json")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return false
    }
     
    func registerForKeyboardNotifications() {
      NotificationCenter.default.addObserver(self,
                          selector: #selector(keyboardWasShown(_:)),
                          name: UIResponder.keyboardDidShowNotification,
                          object: nil)
      NotificationCenter.default.addObserver(self,
                          selector: #selector(keyboardWillBeHidden(_:)),
                          name: UIResponder.keyboardWillHideNotification,
                          object: nil)
      NotificationCenter.default.addObserver(self,
                          selector: #selector(keyboardWasShown(_:)),
                          name: UIResponder.keyboardWillChangeFrameNotification,
                          object: nil)
    }
     
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
      guard let info = notificiation.userInfo,
        let keyboardFrameValue =
        info[UIResponder.keyboardFrameBeginUserInfoKey]
          as? NSValue
        else { return }
      let keyboardFrame = keyboardFrameValue.cgRectValue
      let keyboardSize = keyboardFrame.size
       
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                       bottom: keyboardSize.height, right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }
     
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
      let contentInsets = UIEdgeInsets.zero
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      self.view.layoutIfNeeded()
    }
}

