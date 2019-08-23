//
//  ShareUserViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/11/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import OneSignal

class ShareUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usersForNotifications = [Userly]()
    var theirUsername: String?
    var theUrl : String?
    var theirName: String? 
    
      let buttonShare = UIButton()
    var theirUid: String?
    var userlers = [Userly]()
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        buttonShare.frame = CGRect(x: 10, y: self.view.frame.height - 100, width: self.view.frame.width - 20, height: 50)
        buttonShare.backgroundColor = UIColor(red: 0.2627, green: 0, blue: 0.9373, alpha: 1.0)
        buttonShare.setTitle("Share User", for: .normal)
        buttonShare.setTitleColor(.white, for: .normal)
        buttonShare.titleLabel?.font = UIFont(name: "Futura", size: 18)
        buttonShare.layer.cornerRadius = 24.0
        buttonShare.clipsToBounds = true
        view.addSubview(buttonShare)
        buttonShare.isHidden = true
        if let theirId = self.theirUid {
            print(theirId)
        grabSuggested()
        }
        tablerView.delegate = self
        tablerView.dataSource = self
        buttonShare.addTarget(self, action: #selector(share), for: .touchUpInside)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 22)!, NSAttributedStringKey.foregroundColor : UIColor.black]
         tablerView.frame = CGRect(x: 0, y: 94, width: self.view.frame.width, height: self.view.frame.height  - 94)
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userlers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellShare", for: indexPath) as! ShareUserTableViewCell
    cell.changeView.layer.cornerRadius = 10.5
        cell.changeView.clipsToBounds = true
        cell.changeView.layer.borderColor = UIColor.darkGray.cgColor
        cell.changeView.layer.borderWidth = 1.0
     cell.changeView.frame = CGRect(x: cell.frame.width - 38, y: cell.frame.height / 2.7, width: 20, height: 20)
        
        cell.imagerView.layer.cornerRadius = 25
        cell.imagerView.clipsToBounds = true
         cell.labelMain.frame = CGRect(x: 73, y: 16, width: self.view.frame.width - 150, height: 22)
        if let imager = userlers[indexPath.row].imageUrl {
            if highmem == false {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            cell.imagerView.kf.setImage(with: restource)
            } else {
                cell.imagerView.image = #imageLiteral(resourceName: "profiler")
            }
        } else {
            cell.imagerView.image = #imageLiteral(resourceName: "profiler")
        }

        if let yep = userlers[indexPath.row].isUnseen {
            if yep == "yep" {
               cell.changeView.backgroundColor = UIColor(red: 0, green: 0.651, blue: 0.9098, alpha: 1.0)
            } else if yep == "nope" {
                cell.changeView.backgroundColor = .clear
            }
        } else {
             cell.changeView.backgroundColor = .clear
        }
        
        cell.labelMain.text = userlers[indexPath.row].namer
        return cell
    }
 var highmem = false
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        highmem = true
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var matchCount = 0
    func grabSuggested () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let matchers = snapshot.value as? [String : AnyObject] {
                    self.matchCount = matchers.count
                    for (one,_) in matchers {
                        self.loadUser(uid: one)
                    }
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
                
                if let theirKey = value?["userKey"] as? String {
                    newpUser.userKey = theirKey
                }
                if let urler = value?["profileUrl"] as? String {
                    if urler == "none" {
                        
                    } else {
                    newpUser.imageUrl = urler
                    }
                }
                if self.userlers.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid || newpUser.uider == self.theirUid {
                    print("no")
                    self.matchCount -= 1
                } else {
                    self.userlers.append(newpUser)
                    
                }
            }
            if self.userlers.count == self.matchCount {
                print("relodddd")
            self.tablerView.reloadData()
            }
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

    var strings = [String]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let already = userlers[indexPath.row].isUnseen {
            if already == "yep" {
                
                strings = strings.filter{$0 != userlers[indexPath.row].uider}
                userlers[indexPath.row].isUnseen = "nope"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                if strings.count == 0 {
                    buttonShare.isHidden = true
                }
            } else {
                strings.append(userlers[indexPath.row].uider)
                
                userlers[indexPath.row].isUnseen = "yep"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                buttonShare.isHidden = false
            }
        } else {
              strings.append(userlers[indexPath.row].uider)
          
      userlers[indexPath.row].isUnseen = "yep"
        self.tablerView.reloadRows(at: [indexPath], with: .automatic)
            buttonShare.isHidden = false
        }
        print(strings)
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
   
    @objc func share () {
        if strings.count != 0 {
            if let uid = Auth.auth().currentUser?.uid {
                for each in strings {
                    if let sharerId = theirUid {
                        if let theUrl = theUrl {
                            if let theirNamer = theirName {
                                if let theirUsernmer = theirUsername {
                            if let myName = Auth.auth().currentUser?.displayName {
                     let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let content = "\(myName) shared this user with you"
                    let ref = Database.database().reference()
                  
                    let key = ref.child("users").child(each).child("Notifications").childByAutoId().key
                                
                                
                                let feed = ["timeStamp" : timeStamp, "key" : key, "theirName" : theirNamer, "theirId" : uid, "shareId" : sharerId, "theirUrl" : theUrl, "content" : content, "unseen" : each, "theirUsername" : theirUsernmer] as [String : Any]
                                
                                let final = [key : feed]
                                
                                ref.child("users").child(each).child("Notifications").updateChildValues(final)
                                
                            
                                
                }
                    }
                            }
            }
                    }
                }
                for each in strings {
                    let ref = Database.database().reference()
                    ref.child("users").child(each).child("userKey").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let userKey = snapshot.value as? String {
                            if let namert = Auth.auth().currentUser?.displayName {
                            let messgae = "\(namert) has shared a user with you"
                           
                            print("sending notif")
                                let data = [
                                    "contents": ["en": "\(messgae)"],
                                    "include_player_ids":["\(userKey)"],
                                    "ios_badgeType": "Increase",
                                    "ios_badgeCount": 1
                                    ] as [String : Any]
                                OneSignal.postNotification(data)
                            }
                        }
                    })
                }
        
                self.dismiss(animated: true, completion: nil) //
            }
        }
    }
    
}
