//
//  ResetViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 1/10/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ResetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var labeler: UILabel!
    @IBOutlet weak var textFielder: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textFielder.delegate = self
        self.navigationItem.title = "Reset Password"
        textFielder.frame = CGRect(x: 15, y: 140, width: self.view.frame.width - 30, height: 30)
        resetAction.frame = CGRect(x: 15, y: self.view.frame.height - 80, width: self.view.frame.width - 30, height: 60)
        resetAction.layer.cornerRadius = 22.0
        resetAction.clipsToBounds = true
        
        labeler.frame = CGRect(x: 15, y: 90, width: self.view.frame.width - 30, height: 25)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFielder.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var once = false
    @IBOutlet weak var resetAction: UIButton!
    @IBAction func realResetAction(_ sender: Any) {
        if once == false {
            once = true
        if textFielder.text != "" {
            Auth.auth().sendPasswordReset(withEmail: textFielder.text!, completion: { (error) in
                if error == nil {
                    let emailText = self.textFielder.text!
                    let alert = UIAlertController(title: "Email sent to \(emailText)", message: "Please check your email, An email containing information on how to reset your password has been sent to the entered email", preferredStyle: .alert)
                    let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(oky)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alertCo = UIAlertController(title: "There is no user corresponding to this email", message: "Please enter the email of your registered account, or create an account by going back to sign up", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alertCo.addAction(okay)
                    self.textFielder.text = ""
                    self.present(alertCo, animated: true, completion: nil)
                    self.once = false
                }
            })
        }
        }
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
