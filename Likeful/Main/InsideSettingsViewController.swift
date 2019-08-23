//
//  InsideSettingsViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class InsideSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    
    var blocked = [Userly]()
      let buttonErt = UIButton()
    @IBOutlet weak var tablerView: UITableView!
    let botoonSave = UIButton()
    
    @IBOutlet weak var labelFlurl: UILabel!
    var indexLor: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tablerView.delegate = self
        tablerView.dataSource = self
    tablerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height  - 64)

        self.tablerView.isHidden = true
        if let indexPat = indexLor {
            if indexPat.row == 0 {
                self.navigationItem.title = "Password"
                
                botoonSave.frame = CGRect(x: 15, y: 100, width: self.view.frame.width - 30, height: 50)
                botoonSave.setTitle("Change Password", for: .normal)
                botoonSave.setTitleColor(.white, for: .normal)
                botoonSave.backgroundColor = UIColor(red: 0, green: 0.4902, blue: 0.7176, alpha: 1.0)
                botoonSave.layer.cornerRadius = 20.0
                botoonSave.clipsToBounds = true
                botoonSave.titleLabel?.font = UIFont(name: "Futura", size: 16)
                botoonSave.addTarget(self, action: #selector(saverAct), for: .touchUpInside)
                
                view.addSubview(botoonSave)
                
                self.labelFlurl.isHidden = true
            }
            if indexPat.row == 1 {
                self.navigationItem.title = "Blocked Users"
                self.tablerView.isHidden = false
                self.tablerView.frame = CGRect(x: 10, y: 80, width: self.view.frame.width - 20, height: self.view.frame.height - 160)
                self.labelFlurl.isHidden = true
                self.grabBlocked()
               
                
            }
            if indexPat.row == 2 {
               
               
            }
            if indexPat.row == 4 {
                self.labelFlurl.text = "We strive to make Flurl as beautiful and friendly as possible, but we know that some things may go wrong. We encourage you to report any problems so our programmers can fix them. Please email a problem you find at flurlapp@gmail.com. If it is a user you would like to report, please email flurlapp@gmail.com the user's username and a photo of the problem. Thank you"
                self.navigationItem.title = "Report a problem"
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
                self.labelFlurl.numberOfLines = 20
            }
            
            if indexPat.row == 5 {
                self.labelFlurl.text = "We work hard to ensure that our application is great, and we hope you think so too. If you ever need to contact us, we are avaible. Please email flurlapp@gmail.com, for any questions, comments, or concerns."
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
                self.navigationItem.title = "Contact Us"
            }
            if indexPat.row == 6 {
                self.navigationItem.title = "About Flurl"
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
            }
            if indexPat.row == 7 {
                self.labelFlurl.isHidden = true
                self.navigationItem.title = "App Settings"
                let buttonEr = UIButton()
                buttonEr.setTitle("See App Settings", for: .normal)
                buttonEr.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 50)
                
                buttonEr.titleLabel?.font = UIFont(name: "Futura", size: 20)
                buttonEr.setTitleColor(.white, for: .normal)
                buttonEr.backgroundColor = UIColor(red: 0, green: 0.4863, blue: 0.6078, alpha: 1.0)
                buttonEr.layer.cornerRadius = 20.0
                buttonEr.clipsToBounds = true
                buttonEr.addTarget(self, action: #selector(self.makeGoSettings), for: .touchUpInside)
                
                self.view.addSubview(buttonEr)
            }
            if indexPat.row == 8 {
                self.grabPriva()
                self.labelFlurl.isHidden = true
                self.navigationItem.title = "Make Account private"
                
                
                buttonErt.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 50)
                buttonErt.titleLabel?.font = UIFont(name: "Futura", size: 18)
                
                buttonErt.layer.cornerRadius = 20.0
                buttonErt.clipsToBounds = true
                buttonErt.addTarget(self, action: #selector(self.changePrivate), for: .touchUpInside)
                
                self.view.addSubview(buttonErt)
            }
            if indexPat.row == 9 {
               
            }
        }
        
        // Do any additional setup after loading the view.
    }
    var oncei = false
    @objc func changePrivate () {
        if alreadyYes == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("privateAccount").removeValue()
                alreadyYes = false
                self.buttonErt.backgroundColor = .white
                self.buttonErt.setTitleColor(.blue, for: .normal)
                 self.buttonErt.setTitle("Make account Private", for: .normal)
            }
        } else {
            if self.oncei == false {
            print("goofwd")
            self.buttonErt.backgroundColor = .white
            self.buttonErt.setTitle("Make account Public", for: .normal)
            self.buttonErt.setTitleColor(.blue, for: .normal)
            if let uid = Auth.auth().currentUser?.uid {
            let feed = ["privateAccount" : uid]
                let ref = Database.database().reference()
                ref.child("users").child(uid).updateChildValues(feed)
                self.oncei = true
            }
            }
            alreadyYes = true
        }
    }
    
    
    var alreadyYes = false
    func grabPriva () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
        ref.child("users").child(uid).child("privateAccount").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                self.buttonErt.setTitle("Make account public", for: .normal)
                self.buttonErt.backgroundColor = .blue
                self.buttonErt.setTitleColor(.white, for: .normal)
                self.alreadyYes = true
            } else {
                self.buttonErt.setTitle("Make account private", for: .normal)
                self.buttonErt.backgroundColor = .white
                self.buttonErt.setTitleColor(.blue, for: .normal)
                
            }
        })
        }
    }
    
    @objc func makeGoSettings () {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocked.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as! BlockedTableViewCell
        cell.mainLabel.text = blocked[indexPath.row].namer
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    var once = false
    @objc func saverAct () {
        
        if let index = indexLor {
            
            if index.row == 1 {
                if once == false {
                    once = true
        botoonSave.setTitle("Sent to email", for: .normal)
                botoonSave.backgroundColor = UIColor.lightGray
                    if let currentUserEmail = Auth.auth().currentUser?.email {
                        Auth.auth().sendPasswordReset(withEmail: currentUserEmail, completion: { (error) in
                            if error == nil {
                                let alert3 = UIAlertController(title: "Email sent to \(currentUserEmail)", message: "Please check your email, an email containing information on how to change your password has been sent to the entered email", preferredStyle: .alert)
                                let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                                    self.navigationController?.popViewController(animated: true)                                })
                                
                                alert3.addAction(oky)
                                self.present(alert3, animated: true, completion: nil)
                            }
                            else {
                                let alertCo = UIAlertController(title: "Error", message: "Sorry there was an error, please try again later", preferredStyle: .alert)
                                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                alertCo.addAction(okay)
                                self.present(alertCo, animated: true, completion: nil)
                            }
                        })
                    }
                } else {
                    
                }
            }
        }
        
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerter = UIAlertController(title: blocked[indexPath.row].namer, message: blocked[indexPath.row].username, preferredStyle: .alert)
        let action = UIAlertAction(title: "Unblock", style: .default) { (alert : UIAlertAction) in
            let ref = Database.database().reference()
            if let theirId = self.blocked[indexPath.row].uider {
                if let uid = Auth.auth().currentUser?.uid {
             ref.child("users").child(uid).child("blocked").child(theirId).removeValue()
                self.blocked.remove(at: indexPath.row)
                    self.tablerView.reloadData()
                }
                
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerter.addAction(action)
        alerter.addAction(cancel)
        self.present(alerter, animated: true, completion: nil)
    }
    
    func grabBlocked () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("blocked").observeSingleEvent(of: .value, with: {(snapshot) in
                if let blocked = snapshot.value as? [String : AnyObject] {
                    for (_, val) in blocked {
                     self.loadUser(uid: val as! String)
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 40)
                    label.font = UIFont(name: "Futura", size: 17)
                    label.textAlignment = .center
                    label.text = "You currently have no blocked users"
                    label.textColor = .black
                    self.view.addSubview(label)
                }
            })
        }
    }
    func loadUser(uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String {
                
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
               
                 if self.blocked.contains( where: { $0.uider == newpUser.uider })  {
                }
                 else {
                    self.blocked.append(newpUser)
                }
               
            }
            self.tablerView.reloadData()
            print("loaded a user")
            
            
        })
        
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
