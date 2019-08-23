//
//  LoginViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate, cantJoin {

    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var noAccountButton: UIButton!
    var hither: String?
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
       
        noAccountButton.frame = CGRect(x: 60, y: 80, width: self.view.frame.width - 120, height: 20)
        emailLabel.frame = CGRect(x: 20, y: self.view.frame.height / 4.35, width: self.view.frame.width - 200, height: 20)
       emailTextField.frame = CGRect(x: 18, y: self.view.frame.height / 3.7, width: self.view.frame.width - 36, height: 30)
        
        passwordLabel.frame = CGRect(x: 20, y: self.view.frame.height / 2.8, width: self.view.frame.width - 200, height: 20)
        passwordField.frame = CGRect(x: 18, y: self.view.frame.height / 2.5, width: self.view.frame.width - 36, height: 30)
       forgotPasswordBtn.frame = CGRect(x: 90, y: self.view.frame.height / 2, width: self.view.frame.width - 180, height: 20)
        
        loginButton.frame = CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 52)
        loginButton.layer.cornerRadius = 12.0
        loginButton.clipsToBounds = true
        if self.view.frame.height == 812 {
             noAccountButton.frame = CGRect(x: 60, y: 100, width: self.view.frame.width - 120, height: 20)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpAct(_ sender: Any) {
       print("signup")
    }
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func forgotPasswordAct(_ sender: Any) {
        print("forgot password")
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        if emailTextField.isFirstResponder == true {
            emailTextField.resignFirstResponder()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLoginToSignUp" {
            let dest = segue.destination as! AgeSignUpViewController
            dest.delegate = self
        }
    }
  
    @IBOutlet weak var loginButton: UIButton!
    var pressOnce = false
    @IBAction func loginAction(_ sender: Any) {
        if pressOnce == false {
            pressOnce = true
        if let email = emailTextField.text {
            if let password = passwordField.text {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(logedIn, error) in
            if let error = error {
                print(error.localizedDescription)
                var problem = UIAlertController()
                problem = UIAlertController(title: "There was a problem", message: "The email or password is incorrect", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                problem.addAction(cancel)
                self.present(problem, animated: true, completion: nil)
                self.pressOnce = false
            }
            else {
                let vc = self.view.window!.rootViewController as! UITabBarController
                let dvc = vc.viewControllers![0] as! UINavigationController
                let dvcv = dvc.viewControllers[0] as! ViewController
                self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                    dvcv.dothingis()
                    let appDel = AppDelegate()
                    appDel.callNotifs()
                })
                
            }
        })
            }
        }
        }
    }
    
    func youCant() {
        let alert = UIAlertController(title: "You cannot join this app", message: "You are not old enough to use this application. You must be at least 14 years of age to create an account on this application. It is illegal to fake your age, and violators will be removed from the application.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }
    
}
