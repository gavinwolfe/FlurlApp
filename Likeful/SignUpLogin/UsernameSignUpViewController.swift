//
//  UsernameSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class UsernameSignUpViewController: UIViewController, UITextFieldDelegate {

    var namer: String?
    var years: Int?
    var dob: Date?
    override func viewWillAppear(_ animated: Bool) {
        self.textField.becomeFirstResponder()
    }
    
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        
       textField.frame = CGRect(x: 16, y: 133, width: self.view.frame.width - 32, height: 30)
        usernameLabel.frame = CGRect(x: 107, y: 104, width: self.view.frame.width - 214, height: 21)
        nextButton.frame = CGRect(x: 56, y: 188, width: self.view.frame.width - 112, height: 52)

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.labelTaken.frame = CGRect(x: 50, y: 280, width: self.view.frame.width - 100, height: 25)
        self.labelTaken.font = UIFont(name: "Futura", size: 20)
        self.labelTaken.textColor = .red
        self.labelTaken.textAlignment = .center
        self.view.addSubview(labelTaken)
        self.labelTaken.text = "This username is taken"
        self.labelTaken.isHidden = true
        self.navigationItem.title = "Sign Up"
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            self.usernameLabel.font = UIFont(name:  "HelveticaNeue-Medium", size: 14)
        }
        // Do any additional setup after loading the view.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
 return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
    }
    
    @objc func textFieldDidChange() {
        self.labelTaken.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   let labelTaken = UILabel()
    @IBAction func nextAct(_ sender: Any) {
        if let textlo = textField.text {
            if textlo.count > 4 && textlo.count < 19 {
                if let namer = namer {
                    let string = textlo.lowercased()
                    if   string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger")
                        || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains(" ") || string.contains("nigga")
                    {
                 
                        
                    } else {
                    
                        let ref = Database.database().reference()
                        let input = self.textField.text?.lowercased()
                        ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: input!).queryEnding(atValue: input! + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.exists() {
                               self.labelTaken.isHidden = false
                            }
                            else {
                                self.labelTaken.isHidden = true
                                let dest = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailSignup") as! EmailPasswordSignUpViewController
                                
                                    if let texter = self.textField.text {
                                        dest.namer = namer
                                        dest.dob = self.dob
                                        dest.years = self.years
                                        dest.usernAme = texter.lowercased()
                                    }
                                self.navigationController?.pushViewController(dest, animated: true)
                                
                            }
                            
                        })
                        
                        
                    }
                    
                }
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
