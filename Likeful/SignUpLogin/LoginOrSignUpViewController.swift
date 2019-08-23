//
//  LoginOrSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class LoginOrSignUpViewController: UIViewController, cantJoin {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var flurlLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        flurlLabel.frame = CGRect(x: 50, y: 30, width: self.view.frame.width - 100, height: 35)
        loginButton.frame = CGRect(x: 0, y: self.view.frame.height / 3, width: self.view.frame.width, height: self.view.frame.height / 8)
        signUpButton.frame = CGRect(x: 0, y: self.view.frame.height / 2.15, width: self.view.frame.width, height: self.view.frame.height / 8)
        backImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // Do any additional setup after loading the view.
    }
    @IBAction func loginAct(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUp") as! UINavigationController
        let dest = vc.viewControllers[0] as? AgeSignUpViewController
        dest?.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func youCant() {
        let alert = UIAlertController(title: "You cannot join this app", message: "You are not old enough to use this application. You must be at least 14 years of age to create an account on this application. It is illegal to fake your age, and violators will be removed from the application.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
