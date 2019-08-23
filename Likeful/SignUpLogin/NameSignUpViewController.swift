//
//  NameSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class NameSignUpViewController: UIViewController, UITextFieldDelegate {

    override func viewWillAppear(_ animated: Bool) {
        self.textFielder.becomeFirstResponder()
    }
    var years: Int?
    var dob: Date?
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textFielder: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        textFielder.frame = CGRect(x: 16, y: 133, width: self.view.frame.width - 32, height: 30)
        nameLabel.frame = CGRect(x: 107, y: 104, width: self.view.frame.width - 214, height: 21)
        nextButton.frame = CGRect(x: 56, y: 188, width: self.view.frame.width - 112, height: 52)
       
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            self.nameLabel.font = UIFont(name:  "HelveticaNeue-Medium", size: 14)
        }
        
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let textlo = textFielder.text {
            if textlo.count > 3 && textlo.count < 30 {
                let string = textlo.lowercased()
                if  string.contains("-") || string.contains("_") || string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger")
                    || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("nigga")
                {
                    return false
                   
                } else {
                return true
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "segueName" {
            if let texter = textFielder.text {
                let dest = segue.destination as! UsernameSignUpViewController
                dest.namer = texter
                dest.dob = dob
                dest.years = years
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textlo = textField.text {
            if textlo.count <= 3 {
                textFielder.text = ""
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextAction(_ sender: Any) {
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
