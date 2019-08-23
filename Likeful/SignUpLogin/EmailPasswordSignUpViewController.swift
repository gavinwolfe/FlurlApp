//
//  EmailPasswordSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class EmailPasswordSignUpViewController: UIViewController {

    var usernAme: String?
    var namer: String?
    var years: Int?
    var dob: Date?
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextFielder: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextFielder: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 6.0
        signUpButton.clipsToBounds = true

        signUpButton.frame = CGRect(x: 52, y: 269, width: self.view.frame.width - 104, height: 56)
        passwordTextFielder.frame = CGRect(x: 20, y: 216, width: self.view.frame.width - 40, height: 30)
        passwordLabel.frame = CGRect(x: 20, y: 187, width: 200, height: 21)
        emailTextFielder.frame = CGRect(x: 20, y: 136, width: self.view.frame.width - 40, height: 30)
        emailLabel.frame = CGRect(x: 20, y: 107, width: 125, height: 21)
        
        
      
        self.navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var once = false
    @IBAction func signUpAct(_ sender: Any) {
        if once == false {
            once = true
        if let usernm = usernAme {
            if let namer = namer {
                if let dob = dob {
                    if let years = years {
                if let texterEmail = emailTextFielder.text {
                    if texterEmail.count < 52  {
                    if passwordTextFielder.text != "" {
        Auth.auth().createUser(withEmail: emailTextFielder.text!, password: passwordTextFielder.text!, completion: { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: error.localizedDescription, message: "Please enter a different email", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.signUpButton.isHidden = false
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.present(alert, animated: true, completion: nil)
                self.once = false
            }
            if let user = user {
            
                let calendar = Calendar.current
                
                let ageComponents = calendar.dateComponents([.year,.month,.day], from: dob)
                 let timelnow: Int = Int(NSDate().timeIntervalSince1970)
                
                UserDefaults.standard.set(years, forKey: "age")
                UserDefaults.standard.set(usernm, forKey: "username")
                UserDefaults.standard.set(timelnow, forKey: "newUser")
                let ref = Database.database().reference()
                let userInfo : [String : Any] = ["uid": user.uid as String, "name": namer, "username": usernm, "showDirections" : user.uid, "age" : years, "newUser" : timelnow, "score" : 5]
                ref.child("users").child(user.uid).setValue(userInfo)
                let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                
             
                let setup: [String : Any]  = ["Month" : ageComponents.month!, "Day" : ageComponents.day!, "Year" : ageComponents.year!]
                ref.child("users").child(user.uid).child("DOB").setValue(setup)
              
                let newUserSetup = [user.uid : user.uid]
                ref.child("newUsers").updateChildValues(newUserSetup)
                
                changeRequest.displayName = namer
                changeRequest.commitChanges(completion: nil)
                print(changeRequest.displayName!)
                print(user)
                
                  self.performSegue(withIdentifier: "segueLastSignUp", sender: self)
                
            }
        })
                }
                    }
                }
                }
            }
            }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextFielder.becomeFirstResponder()
    }
   
   
   

}
