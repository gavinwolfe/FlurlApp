//
//  PostViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 2/22/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import OneSignal
protocol abc: class {
    func xyz(url: String, time: Int, key: String, text: String)
}

class PostViewController: UIViewController {
// this could possible be reinstigated later
}

class sharer: NSObject, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var delegate: abc?
    var matches = [Userly]()
       let saveButton = UIButton()
    let activity = UIActivityIndicatorView()
     let textViewer = UITextView()
    let mainView = UIView()
    let tablerView = UITableView(frame: CGRect.zero, style: .grouped)
    let backButton = UIButton()
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
     let button1 = UIButton()
     let button2 = UIButton()
    let tableTopView = UIView()
      let sendButton = UIButton()
     let button3 = UIButton()
    func adddViews (image: UIImage) {
        selectedImage = image
        tablerView.delegate = self
        tablerView.dataSource = self
        textViewer.delegate = self
        
        tablerView.register(SharePhotoTableViewCell.self, forCellReuseIdentifier: "cellSharing")
        if let keywindow = UIApplication.shared.keyWindow {
            mainView.frame = keywindow.frame
            mainView.backgroundColor = .white
         
            grabMatched()
            tableTopView.frame = CGRect(x: 0, y: 65, width: mainView.frame.width, height: 305)
            
         
            index = 0
            view1.frame = CGRect(x: 15, y: 170, width: 24, height: 24)
            view1.layer.cornerRadius = 12
            view1.clipsToBounds = true
            view1.layer.borderWidth = 1.0
            view1.layer.borderColor = UIColor.black.cgColor
            view1.backgroundColor = .blue
            view2.frame = CGRect(x: 15, y: 210, width: 24, height: 24)
            view2.layer.cornerRadius = 12
            view2.clipsToBounds = true
            view2.layer.borderWidth = 1.0
            view2.layer.borderColor = UIColor.black.cgColor
            view2.backgroundColor = .white
            view3.frame = CGRect(x: 15, y: 250, width: 24, height: 24)
            view3.layer.cornerRadius = 12
            view3.clipsToBounds = true
            view3.layer.borderWidth = 1.0
            view3.layer.borderColor = UIColor.black.cgColor
            view3.backgroundColor = .white
            
            let label1 = UILabel()
            label1.frame = CGRect(x: 50, y: 170, width: 200, height: 25)
            label1.font = UIFont(name: "HelveticaNeue", size: 16)
            label1.textColor = .black
            label1.text = "All my connections"
            
            let label2 = UILabel()
            label2.frame = CGRect(x: 50, y: 210, width: 300, height: 25)
            label2.font = UIFont(name: "HelveticaNeue", size: 16)
            label2.textColor = .black
            label2.text = "Only my interested connections"
            
            let label3 = UILabel()
            label3.frame = CGRect(x: 50, y: 250, width: 250, height: 25)
            label3.font = UIFont(name: "HelveticaNeue", size: 16)
            label3.textColor = .black
            label3.text = "Only my friend connections"
            
           
            button1.frame = CGRect(x: 0, y: 167, width: 320, height: 30)
            button1.setTitle("", for: .normal)
            button1.addTarget(self, action: #selector(self.buttonAct1), for: .touchUpInside)
            
           
            button2.frame = CGRect(x: 0, y: 207, width: 320, height: 30)
            button2.setTitle("", for: .normal)
            button2.addTarget(self, action: #selector(self.buttonAct2), for: .touchUpInside)
            
           
            button3.frame = CGRect(x: 0, y: 247, width: 375, height: 30)
            button3.setTitle("", for: .normal)
            button3.addTarget(self, action: #selector(self.buttonAct3), for: .touchUpInside)
            
            
            let topView = UIView()
            topView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: 65)
            topView.backgroundColor = UIColor(red: 0, green: 0.5725, blue: 0.9569, alpha: 1.0)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 50, y: 20, width: topView.frame.width - 100, height: 35)
            titleLabel.font = UIFont(name: "Avenir-Heavy", size: 21)
            titleLabel.text = "Post Photo"
            titleLabel.textAlignment = .center
            titleLabel.textColor = .white
            if mainView.frame.height == 812 {
                titleLabel.frame = CGRect(x: 50, y: 27, width: topView.frame.width - 100, height: 35)
            }
            
            let imagelView = UIImageView()
            imagelView.frame = CGRect(x: mainView.frame.width - 90, y: 35, width: 80, height: 80)
            imagelView.image = image
            imagelView.contentMode = .scaleAspectFill
            imagelView.layer.cornerRadius = 8.0
            imagelView.clipsToBounds = true
            
           
            textViewer.frame = CGRect(x: 15, y: 35, width: mainView.frame.width - 120, height: 90)
            textViewer.backgroundColor = UIColor(red: 0.9686, green: 0.9725, blue: 1, alpha: 1.0)
            textViewer.font = UIFont(name: "Avenir-Medium", size: 16)
            textViewer.layer.cornerRadius = 12.0
            textViewer.clipsToBounds = true
            
            let labelUpper = UILabel()
            labelUpper.font = UIFont(name: "Avenir-Next", size: 14)
            labelUpper.textColor = UIColor.darkGray
            labelUpper.frame = CGRect(x: 15, y: 13, width: 300, height: 20)
            labelUpper.text = "Add text to photo (optional) :"
            
            let labelPost = UILabel()
            labelPost.frame = CGRect(x: 20, y: 135, width: 100, height: 25)
            labelPost.font = UIFont(name: "Avenir-Heavy", size: 18)
            labelPost.textColor = .blue
            labelPost.text = "Post to?"
            
            let labelSelect = UILabel()
            labelSelect.frame = CGRect(x: 10, y: 285, width: 250, height: 20)
            labelSelect.font = UIFont(name: "Avenir-Next", size: 6)
            labelSelect.text = "Or select connections :"
            labelSelect.textColor = .darkGray
            
            activity.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
            activity.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.6)
            activity.color = .white
            
            sendButton.frame = CGRect(x: mainView.frame.width - 95, y: mainView.frame.height - 90, width: 70, height: 70)
            sendButton.layer.shadowColor = UIColor.black.cgColor
            sendButton.layer.shadowRadius = 1.0
            sendButton.layer.shadowOpacity = 0.5
            sendButton.setTitle("", for: .normal)
            sendButton.setImage(#imageLiteral(resourceName: "sideArrow"), for: .normal)
            sendButton.backgroundColor = UIColor(red: 0, green: 0.5922, blue: 0.9373, alpha: 1.0)
            sendButton.layer.cornerRadius = 35
            sendButton.clipsToBounds = true
            sendButton.addTarget(self, action: #selector(self.sharePhotoer), for: .touchUpInside)
            
            saveButton.frame = CGRect(x: 50, y: mainView.frame.height / 2, width: mainView.frame.width - 100, height: 45)
            
            
            saveButton.backgroundColor = UIColor(red: 0, green: 0.4471, blue: 0.8392, alpha: 1.0)
            saveButton.layer.cornerRadius = 22.0
            saveButton.clipsToBounds = true
            saveButton.titleLabel?.font = UIFont(name: "Futura", size: 18)
            saveButton.setTitle("Done", for: .normal)
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.addTarget(self, action: #selector(exitText), for: .touchUpInside)
            saveButton.isHidden = true
            
            tablerView.frame = CGRect(x: 0, y: 65, width: mainView.frame.width, height: mainView.frame.height - 65)
//                CGRect(x: 0, y: mainView.frame.height / 1.8, width: mainView.frame.width, height: (mainView.frame.height) - (mainView.frame.height / 1.8) - 6)
            tablerView.separatorStyle = .none
            
            backButton.frame = CGRect(x: 12, y: 20, width: 35, height: 35)
            backButton.setImage(#imageLiteral(resourceName: "downMatch"), for: .normal)
            backButton.addTarget(self, action: #selector(self.backDown), for: .touchUpInside)
            if mainView.frame.height == 812 {
                backButton.frame = CGRect(x: 12, y: 25, width: 35, height: 35)
                tablerView.frame = CGRect(x: 0, y: 65, width: mainView.frame.width, height: mainView.frame.height - 65)
//                    CGRect(x: 0, y: mainView.frame.height / 1.8, width: mainView.frame.width, height: (mainView.frame.height) - (mainView.frame.height / 1.8) - 30)
            }
            if mainView.frame.width == 320 {
                tablerView.frame = CGRect(x: 0, y: 65, width: mainView.frame.width, height: mainView.frame.height - 65)
//                    CGRect(x: 0, y: mainView.frame.height / 1.55, width: mainView.frame.width, height: (mainView.frame.height) - (mainView.frame.height / 1.55) )
                labelSelect.frame = CGRect(x: 10, y: mainView.frame.height / 1.65, width: 250, height: 20)
                label1.font = UIFont(name: "Futura", size: 14)
                label2.font = UIFont(name: "Futura", size: 14)
                label3.font = UIFont(name: "Futura", size: 14)

            }
            if ( UIDevice.current.model.range(of: "iPad") != nil){
                tablerView.frame = CGRect(x: 0, y: 95, width: mainView.frame.width, height: 300)
//                    CGRect(x: 0, y: mainView.frame.height / 1.4, width: mainView.frame.width, height: (mainView.frame.height) - (mainView.frame.height / 1.4) )
                labelSelect.frame = CGRect(x: 10, y: 280, width: 250, height: 20)
                  button1.frame = CGRect(x: 0, y: 157, width: 320, height: 30)
                 button2.frame = CGRect(x: 0, y: 197, width: 320, height: 30)
                 button3.frame = CGRect(x: 0, y: 237, width: 375, height: 30)
                label1.frame = CGRect(x: 50, y: 160, width: 200, height: 25)
                label2.frame = CGRect(x: 50, y: 200, width: 200, height: 25)
                label3.frame = CGRect(x: 50, y: 240, width: 250, height: 25)
                view1.frame = CGRect(x: 15, y: 160, width: 24, height: 24)
                 view2.frame = CGRect(x: 15, y: 200, width: 24, height: 24)
                 view3.frame = CGRect(x: 15, y: 240, width: 24, height: 24)
            }
            keywindow.addSubview(mainView)
            tableTopView.addSubview(view1)
            tableTopView.addSubview(view2)
            tableTopView.addSubview(view3)
            mainView.addSubview(topView)
            mainView.addSubview(titleLabel)
            tableTopView.addSubview(imagelView)
            tableTopView.addSubview(textViewer)
            tableTopView.addSubview(labelUpper)
            tableTopView.addSubview(labelPost)
            tableTopView.addSubview(label1)
            tableTopView.addSubview(label2)
            tableTopView.addSubview(label3)
            mainView.addSubview(tablerView)
             mainView.addSubview(sendButton)
            tableTopView.addSubview(button1)
            tableTopView.addSubview(button2)
            tableTopView.addSubview(button3)
            tableTopView.addSubview(labelSelect)
            mainView.addSubview(saveButton)
            mainView.addSubview(backButton)
            
        }
    }
    var selectedImage: UIImage?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSharing", for: indexPath) as! SharePhotoTableViewCell
        cell.addSubview(cell.imagerView)
        cell.addSubview(cell.labelMain)
        cell.imagerView.layer.cornerRadius = 30.0
        cell.imagerView.clipsToBounds = true
        cell.imagerView.contentMode = .scaleAspectFill
       
        if let imager = matches[indexPath.row].imageUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            cell.imagerView.kf.indicatorType = .activity
            cell.imagerView.kf.setImage(with: restource)
        } else {
            cell.imagerView.image = nil
            cell.imagerView.image = UIImage(named: "profiler")
        }
        
        
        cell.labelMain.text = matches[indexPath.row].namer
        cell.labelMain.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        if let yep = matches[indexPath.row].isUnseen {
            if yep == "yep" {
                cell.labelMain.textColor = .blue
                cell.labelMain.text = "\(matches[indexPath.row].namer!) •"
              
            } else if yep == "nope" {
                cell.labelMain.textColor = .black
              
            }
        } else {
            cell.labelMain.textColor = .black
        }
       
        return cell
        
    }
    var notificationsArray = [String]()
    var once = false
    @objc func sharePhotoer() {
        print("called")
        var stringer = String()
       
        if self.textViewer.text == "" {
            stringer = "none$"
        } else {
             stringer = self.textViewer.text
        }
        
        if once == false {
        self.mainView.addSubview(activity)
        self.activity.startAnimating()
        if let selectedImager = selectedImage {
          matchClone = matches
            self.notificationsArray.removeAll()
              let ref = Database.database().reference()
            if let indexAt = index {
            if let uid = Auth.auth().currentUser?.uid {
                if let myName = Auth.auth().currentUser?.displayName {
            let key = ref.child("users").child(uid).child("Feed").childByAutoId().key
            let storage = Storage.storage().reference().child(uid).child("posts").child(key)
                    if let uploadData = UIImageJPEGRepresentation(selectedImager, 0.44) {
                storage.putData(uploadData, metadata: nil, completion:
                    { (metadata, error) in
                        if error != nil {
                            print(error!)
                            self.backDown()
                            self.activity.stopAnimating()
                            self.activity.removeFromSuperview()
                            return
                        }
                    
                        if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                            
                            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                            let unseenly = "unseen"
                            let feeder: [String : Any] = ["senderUid" : uid, "senderName" : myName, "timeStamp" : timeNow, "unseen" : unseenly, "key" : key, "imageUrl" : imagerUrl, "text" : stringer]
                            
                            let final = [key : feeder]
                            if indexAt == 0 {
                                if self.matchUids.count != 0 {
                                    for each in self.matchUids {
                                        ref.child("users").child(each.uider).child("Feed").updateChildValues(final)
                                        self.notificationsArray.append(each.uider)
                                    }
                                }
                            }
                            if indexAt == 1 {
                                if self.matchUids.count != 0 {
                                    for each in self.matchUids {
                                        if each.interl == 0 {
                                       ref.child("users").child(each.uider).child("Feed").updateChildValues(final)
                                            self.notificationsArray.append(each.uider)
                                        }
                                    }
                                }
                            }
                            if indexAt == 2 {
                                if self.matchUids.count != 0 {
                                    for each in self.matchUids {
                                        if each.interl == 1 {
                                        ref.child("users").child(each.uider).child("Feed").updateChildValues(final)
                                            self.notificationsArray.append(each.uider)
                                        }
                                    }
                                }
                            }
                            if indexAt == 3 {
                                if self.strings.count != 0 {
                                     for each in self.strings {
                                        ref.child("users").child(each).child("Feed").updateChildValues(final)
                                        self.notificationsArray.append(each)
                                    }
                                }
                            }
                             ref.child("users").child(uid).child("Feed").updateChildValues(final)
                            let postes = [key : timeNow]
                            ref.child("users").child(uid).child("Posts").updateChildValues(postes)
                            self.activity.stopAnimating()
                            self.activity.removeFromSuperview()
                            self.removeViews(time: timeNow, url: imagerUrl, key: key, text: stringer)
                          
                        }
                })
            }
            }
            
                }
        }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableTopView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 305
    }
    
    @objc func backDown () {
        if let keywindow = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.mainView.frame = CGRect(x: 0, y: keywindow.frame.height, width: keywindow.frame.width, height: 0)
            }, completion: {(_) -> Void in
                
                
                self.mainView.removeFromSuperview()
                self.matchUids.removeAll()
                self.textViewer.text = ""
                self.matches.removeAll()
                self.strings.removeAll()
                self.tablerView.reloadData()
                self.once = false
               
            })
        }
    }
   
    @objc func removeViews (time: Int, url: String, key: String, text: String) {
        
        if let keywindow = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.mainView.frame = CGRect(x: 0, y: keywindow.frame.height, width: keywindow.frame.width, height: 0)
            }, completion: {(_) -> Void in
              
                    self.matches.removeAll()
                self.mainView.removeFromSuperview()
               self.matchUids.removeAll()
                self.textViewer.text = ""
                self.strings.removeAll()
                self.tablerView.reloadData()
                self.once = false
                    if self.delegate != nil {
                self.delegate?.xyz(url: url, time: time, key: key, text: text)
                }
                self.updateScore()
                self.notifications()
            })
        }
    }
   var matchClone = [Userly]()
    func updateScore () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("score").observeSingleEvent(of: .value, with: {(snapi) in
                if let score = snapi.value as? Int {
                    let newScore = score + 2
                    let feedi = ["score" : newScore]
                    ref.child("users").child(uid).updateChildValues(feedi)
                    let incress = ["increased" : "increased"]
                    ref.child("users").child(uid).updateChildValues(incress)
                }
            })
        }
     }
    
    func notifications () {
        print("calling")
        if self.notificationsArray.count != 0 {
            let ref = Database.database().reference()
            for each in notificationsArray {
               
                if let indext = self.matchClone.index( where: { $0.uider == each }) {
                    if let usersKey = self.matchClone[indext].userKey {
                        if let lastNotif = self.matchClone[indext].lastMessage {
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let timer = timeStamp - lastNotif
                            let hours = timer /  3600
                            if hours >= 50 {
                                
                                let feedTime = ["lastNotification" : timeStamp]
                                if let myName = Auth.auth().currentUser?.displayName {
                                //update last notif
                                ref.child("users").child(each).updateChildValues(feedTime)
                                let messgae = "\(myName) just added to your feed"
                                print("sending notif")
                                let data = [
                                    "contents": ["en": "\(messgae)"],
                                    "include_player_ids":["\(usersKey)"],
                                    "ios_badgeType": "Increase",
                                    "ios_badgeCount": 1
                                    ] as [String : Any]
                                OneSignal.postNotification(data)
                                    print("send out")
                                }
                            } else {
                              print("no")
                            }
                        } else {
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let feedTime = ["lastNotification" : timeStamp]
                            if let myName = Auth.auth().currentUser?.displayName {
                                //update last notif
                                ref.child("users").child(each).updateChildValues(feedTime)
                                let messgae = "\(myName) just added to your feed"
                                print("sending notif")
                                let data = [
                                    "contents": ["en": "\(messgae)"],
                                    "include_player_ids":["\(usersKey)"],
                                    "ios_badgeType": "Increase",
                                    "ios_badgeCount": 1
                                    ] as [String : Any]
                                OneSignal.postNotification(data)
                                print("sendiot")
                            }
                        }
                    }
                }
            }
        }
        self.matchClone.removeAll()
        self.notificationsArray.removeAll()
    }
    
    
    var matchUids = [Userly]()
    func grabMatched () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let values = snapshot.value as? [String : AnyObject] {
                    for (one,ing) in values {
                         let newUser = Userly()
                        newUser.uider = one
                        newUser.interl = ing as? Int
                      if self.matchUids.contains( where: { $0.uider == newUser.uider } ) || newUser.uider == Auth.auth().currentUser?.uid {
                            
                        } else {
                        if newUser.interl != nil {
                        self.matchUids.append(newUser)
                        }
                        }
                       self.loadUser(uid: one)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    
    func loadUser(uid: String) {
        var reload = false
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String {
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                if let urler = value?["profileUrl"] as? String {
                    newpUser.imageUrl = urler
                }
                if let lasMessage = value?["lastNotification"] as? Int {
                    newpUser.lastMessage = lasMessage
                }
                if let usertkey = value?["userKey"] as? String {
                    newpUser.userKey = usertkey
                }
                if self.matches.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid {
                    print("no")
                } else {
                    self.matches.append(newpUser)
                    reload = true
                    
                }
            }
            if reload == true {
                reload = false
                self.tablerView.reloadData()
            }
                
            
        })
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 110
    }
        
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.saveButton.isHidden = false
    }
    @objc func exitText () {
        self.textViewer.resignFirstResponder()
        self.saveButton.isHidden = true
        print(textViewer.text.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    var index: Int?
    @objc func buttonAct1 () {
           if strings.count == 0 {
        index = 0
        view2.backgroundColor = .white
        view3.backgroundColor = .white
        view1.backgroundColor = .blue
        }
    }
    @objc func buttonAct2 () {
           if strings.count == 0 {
        index = 1
        view1.backgroundColor = .white
        view3.backgroundColor = .white
        view2.backgroundColor = .blue
        }
    }
    @objc func buttonAct3 () {
        if strings.count == 0 {
        index = 2
        view1.backgroundColor = .white
        view2.backgroundColor = .white
        view3.backgroundColor = .blue
        }
        
    }
    var strings = [String]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let already = matches[indexPath.row].isUnseen {
            if already == "yep" {
                
                strings = strings.filter{$0 != matches[indexPath.row].uider}
                matches[indexPath.row].isUnseen = "nope"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                if strings.count == 0 {
                    index = 1
                    buttonAct1()
                }
            } else {
                strings.append(matches[indexPath.row].uider)
                
               matches[indexPath.row].isUnseen = "yep"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                view1.backgroundColor = .white
                view2.backgroundColor = .white
                view3.backgroundColor = .white
                index = 3
            }
        } else {
            strings.append(matches[indexPath.row].uider)
            
            matches[indexPath.row].isUnseen = "yep"
            self.tablerView.reloadRows(at: [indexPath], with: .automatic)
            view1.backgroundColor = .white
            view2.backgroundColor = .white
            view3.backgroundColor = .white
            index = 3
        }
        print(strings)
    }
    
}


