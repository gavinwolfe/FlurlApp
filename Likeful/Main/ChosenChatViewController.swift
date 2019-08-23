//
//  ChosenChatViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import OneSignal

class ChosenChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    var theirName: String?
    var theirUid: String?
    var lastMessage: Int?
    let longTap = UILongPressGestureRecognizer()
     var createNewChat = false
     var messages = [Message]()
    var initialHide = false
    var activity = UIActivityIndicatorView()
    var originalUnseen: String?
    let activityImage = UIActivityIndicatorView()
  
    var imageCurrent = "none"
    // grab background image
    
    var oneCaller = false
    func grabBackGroundImage () {
       
        if oneCaller == false {
            oneCaller = true
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirUid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("chats").child(theirId).child("imageUrl").observe(.value, with: {(snapshop) in
                    if snapshop.exists() {
                        
                        if let string = snapshop.value as? String {
                            if string != self.imageCurrent {
                     
                            self.backImage.image = nil
                        let url = URL(string: string)
                        self.backImage.kf.indicatorType = .activity
                        
                        self.backImage.kf.setImage(with: url)
                      
                            self.imageCurrent = string
                                self.updateUnseens()
                                
                                self.zoomed = true
                                
                                self.tablerView.reloadData()
                                self.textVielder.textColor = .white
                                self.textVielder.layer.shadowColor = UIColor.black.cgColor
                                self.textVielder.layer.shadowOpacity = 1
                                self.textVielder.layer.shadowRadius = 2.0
                                //
                                self.view.backgroundColor = .black
                                self.activityImage.stopAnimating()
                                self.activityImage.removeFromSuperview()
                            }
                        }
                       
                    } else {
                        self.backImage.image = nil
                        if self.tablerView.isHidden == true {
                            if self.initialHide == true {
                            self.navigationController?.navigationBar.isHidden = false
                            self.tablerView.isHidden = false
                            self.cameraButton.isHidden = false
                            self.textVielder.isHidden = false
                            self.viewlere.isHidden = false
                            self.timeLabel.isHidden = false
                            self.textVielder.becomeFirstResponder()
                                self.activityImage.stopAnimating()
                                self.activityImage.removeFromSuperview()
                        }
                          self.zoomed = false
                             self.view.backgroundColor = .white
                              self.textVielder.textColor = .black
                            self.textVielder.layer.shadowColor = nil
                            self.textVielder.layer.shadowOpacity = 0
                            self.textVielder.layer.shadowRadius = 0
                        }
                    }
                }, withCancel: nil)
            }
        }
        }
    }
    
    // grab messages
    func grabMessages () {
        if self.originalUnseen == nil {
        self.view.addSubview(activity)
        }
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirUid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("chats").child(theirId).child("messages").observe(.value, with: {(snapshot) in
                    var reloadi = false
                    if let values = snapshot.value as? [String : AnyObject] {
                        for (_, one) in values {
                            if let whoSent = one["sender"] as? String, let messagl = one["message"] as? String, let timerl = one["timeStamp"] as? Int, let keyer = one["key"] as? String {
                                let newMess = Message()
                                print("googd")
                                newMess.key = keyer
                                newMess.timeStamp = timerl
                                newMess.messager = messagl
                                newMess.sender = whoSent
                                
                                       if self.messages.contains( where: { $0.key == newMess.key } )  {
                                       } else {
                                    
                                    self.messages.append(newMess)
                                        if self.messages.count != 0 {
                                            self.messages.sort { $1.timeStamp > $0.timeStamp }
                                       reloadi = true
                                        }
                                        
                                        if newMess.sender == theirId {
                                let update = ["unseen" : "iViewed"]
                           ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(update)
                                            
                                
                                        }
                                }
                                
                            }
                        }
                        
                        if reloadi == true {
                            reloadi = false
                            print("one relo")
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                self.tablerView.reloadData()
                         let indexPat = IndexPath(row: 0, section: self.messages.count - 1)
                             self.tablerView.scrollToRow(at: indexPat, at: .bottom, animated: false)
                                if self.showPhoto != true {
                                self.tablerView.isHidden = false
                                }
                               self.activity.stopAnimating()
                                self.activity.removeFromSuperview()
                                self.initialHide = false
                        }
                            
                        } else {
                            print("nor reload")
                        }
                     
                        
                        if self.messages.count != 0 {
                            if self.messages[self.messages.count - 1].sender == theirId {
                            let update = ["unseen" : "meViewed"]
                        ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(update)
                            }
                           
                            let lastMessage = self.messages.count - 1
                            let second = self.messages[lastMessage].timeStamp
                            self.grabLastMessage(seconds: second!)
                        }
                    } else {
                        self.activity.stopAnimating()
                        self.activity.removeFromSuperview()
                        self.timeLabel.text = "• Today"
                    }
                }, withCancel: nil)
            }
        }
    }
    
   // remove the background image if over 24 hours
    func removeImageIfOverTime () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirUid {
            ref.child("users").child(uid).child("chats").child(theirId).child("imageTime").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    if let valuer = snapshot.value as? Int {
                        let now: Int = Int(NSDate().timeIntervalSince1970)
                        let timer = now - valuer
                        // if greater than 1 day
                        if timer > 64800 {
                          let pictureRef = Storage.storage().reference().child(uid).child("chats").child(theirId).child("imageUrl.jpg")
                            pictureRef.delete { error in
                                if let error = error {
                                    print(error)
                                  
                                } else {
                                    // File deleted successfully
                                }
                            }
                            
                            ref.child("users").child(theirId).child("chats").child(uid).child("imageTime").removeValue()
                             ref.child("users").child(uid).child("chats").child(theirId).child("imageTime").removeValue()
                            ref.child("users").child(theirId).child("chats").child(uid).child("imageUrl").removeValue()
                            ref.child("users").child(uid).child("chats").child(theirId).child("imageUrl").removeValue()
                            
                            //stuff
                            
                            self.grabBackGroundImage()
                            
                        } else {
                        self.grabBackGroundImage()
                        }
                    }
                } else {
                    self.grabBackGroundImage()
                }
                })
            }
        }
    }
   // check if there is a chat then call other functions
    func grabChatters (uid: String) {
        let ref = Database.database().reference()
        if let myId = Auth.auth().currentUser?.uid {
        
            ref.child("users").child(myId).child("chats").child(uid).child("theirId").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    
                    self.grabMessages()
                    self.queryForTyping()
                     self.removeImageIfOverTime()
                   
                } else {
                    self.grabMessages()
                    self.createNewChat = true
                    self.grabBackGroundImage()
                    print("nope")
                }
            })
        }
    }
    // observe for user typing, removed in dismiss function
    let typingEmblem = UIImageView()
    var onceType = false
    func queryForTyping () {
      
        if onceType == false {
            onceType = true
        if let theirId = self.theirUid {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(theirId).child("active").observe(.value, with: {(snapshot) in
                    if let otherType = snapshot.value as? String {
                        if otherType == uid {
                        if self.typingEmblem.isHidden == true {
                            self.typingEmblem.isHidden = false
                        }
                        } else {
                            if self.typingEmblem.isHidden == false {
                                self.typingEmblem.isHidden = true
                            }
                        }
                    } else {
                        if self.typingEmblem.isHidden == false {
                            self.typingEmblem.isHidden = true
                        }
                    }
                }, withCancel: nil)
            }
        }
        }
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
       self.initialHide = false
        if let myUid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            if let theirId = theirUid {
                let imOnline = ["inChat" : theirId]
                ref.child("users").child(myUid).updateChildValues(imOnline)
            }
        }
    }
    
    var boolDont = false
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        print("appearing chat")
        if boolDont == false  {
            if self.originalUnseen == nil {
    self.textVielder.becomeFirstResponder()
            }
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.9373, green: 0, blue: 0.2157, alpha: 1.0)
        //To change Back button title & icon color
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //To change Navigation Bar Title Color
    }
   
    // check if there is a previous chat
     var placeholderLabel : UILabel!
    var gelsture = UITapGestureRecognizer()
    @IBOutlet weak var viewlere: UIView!
   @IBOutlet weak var textVielder: UITextView!
    @IBOutlet weak var tablerView: UITableView!
  var showPhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.originalUnseen != nil {
        showPhoto = true
         self.navigationController?.navigationBar.isHidden = true
            self.cameraButton.isHidden = true
            self.textVielder.isHidden = true
            self.viewlere.isHidden = true
            self.timeLabel.isHidden = true
            self.activityImage.startAnimating()
            self.view.addSubview(activityImage)
        } else {
            showPhoto = false
        }
      self.tablerView.isHidden = true
        if let uider = theirUid {
            self.grabChatters(uid: uider)
        }
        typingEmblem.image = #imageLiteral(resourceName: "typingty")
        typingEmblem.isHidden = true
        view.addSubview(typingEmblem)
       
         timeLabel.frame = CGRect(x: 50, y: 66, width: self.view.frame.width - 100, height: 20)
        longTap.minimumPressDuration = 0.8
        longTap.addTarget(self, action: #selector(removePhoto))
        view.addGestureRecognizer(longTap)
       
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
       
        gelsture.numberOfTapsRequired = 1
        gelsture.addTarget(self, action: #selector(hiddenOrNot))
       
        view.addGestureRecognizer(gelsture)
        
        if let seconds = lastMessage {
            print(seconds)
        } else {
          self.timeLabel.text = ""
        }
        
        if self.view.frame.width == 375 {
            tablerView.frame = CGRect(x: 5, y: 92, width: self.view.frame.width - 10, height: self.view.frame.height / 2.75)
           
        }
       
        if self.view.frame.width == 414 {
             tablerView.frame = CGRect(x: 5, y: 92, width: self.view.frame.width - 10, height: self.view.frame.height / 2.45)
              textVielder.frame = CGRect(x: 8, y: 0, width: viewlere.frame.width + 4 , height: viewlere.frame.height)
        }
        if self.view.frame.width <= 320 {
           tablerView.frame = CGRect(x: 5, y: 82, width: self.view.frame.width - 10, height: self.view.frame.height / 3.1)
            tablerView.isScrollEnabled = true
            textVielder.frame = CGRect(x: 8, y: 0, width: viewlere.frame.width - 81 , height: viewlere.frame.height)
        }
        if self.view.frame.height == 812 {
             timeLabel.frame = CGRect(x: 50, y: 92, width: self.view.frame.width - 100, height: 20)
              tablerView.frame = CGRect(x: 5, y: 116, width: self.view.frame.width - 10, height: self.view.frame.height / 2.7)
        }
         if ( UIDevice.current.model.range(of: "iPad") != nil){
                tablerView.frame = CGRect(x: 5, y: 82, width: self.view.frame.width - 10, height: self.view.frame.height / 4.6)
        }
       
        self.textVielder.layer.cornerRadius = 4.0
        

        textVielder.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type a message..."
        placeholderLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        placeholderLabel.sizeToFit()
        textVielder.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textVielder.text.isEmpty
        textVielder.scrollsToTop = false
        
        
        self.activity.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height / 2.5)
        self.activity.backgroundColor = .white
        self.activity.color = .red
        self.activity.startAnimating()
        
        self.activityImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.activityImage.backgroundColor = .black
        self.activityImage.color = .white
        
        backImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView.delegate = self
        tablerView.dataSource = self

        viewlere.backgroundColor = .darkGray
    
        
        if let titler = theirName {
           self.navigationItem.title = titler
         
        }
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillHide(notification:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillHide(notification:)),
            name: NSNotification.Name.UIApplicationWillTerminate,
            object: nil)
        
        tablerView.estimatedRowHeight = 0
        tablerView.estimatedSectionHeaderHeight = 0
        tablerView.estimatedSectionFooterHeight = 0
         tablerView.scrollsToTop = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        if let myUid = Auth.auth().currentUser?.uid {
             grabMessages()
            let ref = Database.database().reference()
            if let theirId = theirUid {
                let imOnline = ["inChat" : theirId]
                ref.child("users").child(myUid).updateChildValues(imOnline)
            }
            self.onceType = false
            self.oneCaller = false
            self.queryForTyping()
            self.grabBackGroundImage()
        }
    }
    
    @objc func applicationWillHide(notification: NSNotification) {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = self.theirUid {
        ref.child("users").child(uid).child("chats").child(theirId).child("messages").removeAllObservers()
            ref.child("users").child(uid).child("chats").child(theirId).child("imageUrl").removeAllObservers()
            ref.child("users").child(theirId).child("active").removeAllObservers()
            }
        }
    }
    
    
     func grabLastMessage(seconds: Int) {
        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
        let timer = timeStamp - seconds
        
        if timer <= 59 {
            timeLabel.text = ("• \(timer)s ago")
            
        }
        if timer > 59 && timer < 3600 {
            let minuters = timer / 60
            timeLabel.text = "• \(minuters)mins ago"
            if minuters == 1 {
                timeLabel.text  = "• \(minuters)min ago"
            }
        }
        if timer > 59 && timer >= 3600 && timer < 86400 {
            let hours = timer / 3600
            timeLabel.text = "• \(hours)hrs ago"
            if hours == 1 {
                timeLabel.text = "• \(hours)hr ago"
            }
        }
        if timer > 86400 {
            let days = timer / 86400
            timeLabel.text = "• \(days)days ago"
            if days == 1 {
                timeLabel.text = "• \(days)day ago"
            }
        }
    }
    @objc func hiddenOrNot () {
        self.initialHide = true
        if backImage.image != nil {
            self.navigationController?.navigationBar.isHidden = !(self.navigationController?.navigationBar.isHidden)!
            
            tablerView.isHidden = !tablerView.isHidden
            cameraButton.isHidden = !cameraButton.isHidden
            textVielder.isHidden = !textVielder.isHidden
            viewlere.isHidden = !viewlere.isHidden
            timeLabel.isHidden = !timeLabel.isHidden
            
            if textVielder.isFirstResponder == true {
                textVielder.resignFirstResponder()
            } else {
                textVielder.becomeFirstResponder()
            }
            if self.cameraButton.isHidden == true {
                self.tablerView.isHidden = true
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var dismissing = false
    @IBAction func dismisser(_ sender: Any) {
        self.dismissing = true
        self.textVielder.resignFirstResponder()
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirUid {
                ref.child("users").child(uid).child("chats").child(theirId).child("messages").removeAllObservers()
                ref.child("users").child(uid).child("chats").child(theirId).child("imageUrl").removeAllObservers()
                 ref.child("users").child(theirId).child("active").removeAllObservers()
                ref.child("users").child(uid).child("active").removeValue()
                if self.addScores == true {
                    ref.child("users").child(theirId).child("score").observeSingleEvent(of: .value, with: {(snap) in
                        if let score = snap.value as? Int {
                            let newScore = score + 1
                            let feedi = ["score" : newScore]
                            ref.child("users").child(theirId).updateChildValues(feedi)
                            let incress = ["increased" : "increased"]
                            ref.child("users").child(theirId).updateChildValues(incress)
                        }
                    })
                    ref.child("users").child(uid).child("score").observeSingleEvent(of: .value, with: {(snapi) in
                        if let score = snapi.value as? Int {
                            let newScore = score + 1
                            let feedi = ["score" : newScore]
                            ref.child("users").child(uid).updateChildValues(feedi)
                            let incress = ["increased" : "increased"]
                            ref.child("users").child(uid).updateChildValues(incress)
                        }
                    })
                   
                }
                if messages.count != 0 {
                    for each in self.messages  {
                        if each.key != self.messages[self.messages.endIndex - 1].key {
                            ref.child("users").child(uid).child("chats").child(theirId).child("messages").child(each.key).removeValue()
                            
                        } else if each.key == self.messages[self.messages.endIndex - 1].key  {
                            if let endTime = self.messages[self.messages.endIndex - 1].timeStamp {
                                let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                                if timeNow - endTime > 21600 {
        ref.child("users").child(uid).child("chats").child(theirId).child("messages").child(each.key).removeValue()
                                }
                            }
                        }
                    }
                }
            }
        }
        
       
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //&&&&&&&&&&&&&&&&&&&&&&& Table view &&&&&&&&&&&&&&&&&&&//
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messages.count != 0 {
            if messages[indexPath.section].messager.count > 43 && messages[indexPath.section].messager.count < 80 {
                
                return 44
            }
            if messages[indexPath.section].messager.count >= 80 && messages[indexPath.section].messager.count <= 117 {
              
                return 60
            }
            if messages[indexPath.section].messager.count > 117  && messages[indexPath.section].messager.count <= 154 {
               
                return 80
            }
            if messages[indexPath.section].messager.count > 154  {
               
                 return 100
            }
            
            
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= 1 {
        if messages[section - 1].sender != messages[section].sender {
            return 29
        }
        } else {
            return 29
        }
        
        return 0.0000000001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          if section >= 1 {
        if messages[section - 1].sender == messages[section].sender {
            return 0.0000001
        }
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
                headerView.backgroundColor = .clear
            let lineView = UIView()
        let lengthTheir = self.theirName?.count
        
              let headerLabel = UILabel()
                headerLabel.frame = CGRect(x: 5, y: 7, width: 300, height: 20)
                headerLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
                headerLabel.textColor = UIColor(red: 0, green: 0.6706, blue: 0.9569, alpha: 1.0)
        if messages[section].sender == Auth.auth().currentUser?.uid {
            headerLabel.text = "Me"
            lineView.frame = CGRect(x: 5, y: 28, width: 26, height: 1)
            lineView.backgroundColor = UIColor(red: 0, green: 0.6706, blue: 0.9569, alpha: 1.0)
        } else {
                headerLabel.text = self.theirName
             headerLabel.textColor = UIColor(red: 0, green: 0.8471, blue: 0.6784, alpha: 1.0)
            lineView.frame = CGRect(x: 5, y: 28, width: lengthTheir! * 10 , height: 1)
            lineView.backgroundColor = UIColor(red: 0, green: 0.8471, blue: 0.6784, alpha: 1.0)
        }
                headerView.addSubview(headerLabel)
                headerView.addSubview(lineView)
                headerView.layer.cornerRadius = 8.0
                headerView.clipsToBounds = true
        return headerView
    }
    
    
    var zoomed = false
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellChosenChat", for: indexPath) as! ChosenChatTableViewCell
        cell.backgroundColor = .clear
       
        cell.labelMain.text = messages[indexPath.section].messager
        
        cell.labelMain.textAlignment = .left
        
       cell.labelMain.numberOfLines = 5
        
            cell.labelMain.frame = CGRect(x: 5, y: 0, width: cell.frame.width - 7, height: cell.frame.height)
        cell.labelMain.textColor = UIColor.black
        if zoomed == true {
            cell.labelMain.layer.shadowColor = UIColor.black.cgColor
            cell.labelMain.layer.shadowRadius = 1.0
            cell.labelMain.layer.shadowOpacity = 2.0
            cell.labelMain.textColor = UIColor.white
        } else {
            cell.labelMain.layer.shadowColor = nil
            cell.labelMain.layer.shadowRadius = 0
            cell.labelMain.layer.shadowOpacity = 0
            cell.labelMain.textColor = UIColor.black
        }
        
            cell.labelMain.backgroundColor = .clear
       
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
       
    textView.scrollRangeToVisible(NSRange(location:0, length:0))
         placeholderLabel.isHidden = !textView.text.isEmpty
    if textView.text != "" {
       
        if let cureentframe = self.origframe {
        let numLines = Int(textVielder.contentSize.height / (textVielder.font?.lineHeight)!)
        if numLines == 2 {
          
            self.textVielder.frame = CGRect(x: 50, y: cureentframe.origin.y - 28, width: self.view.frame.width - 54, height: 54)
          self.textVielder.backgroundColor = .white
           self.textVielder.textColor = .black
        } else if numLines == 3 {
            self.textVielder.frame = CGRect(x: 50, y: cureentframe.origin.y - 49, width: self.view.frame.width - 54, height: 74)
            self.textVielder.textColor = .black
            self.textVielder.backgroundColor = .white
        } else if numLines == 4 {
            self.textVielder.frame = CGRect(x: 50, y: cureentframe.origin.y - 72, width: self.view.frame.width - 54, height: 96)
            self.textVielder.textColor = .black
            self.textVielder.backgroundColor = .white
        } else if numLines == 5 {
        self.textVielder.frame = CGRect(x: 50, y: cureentframe.origin.y - 94, width: self.view.frame.width - 54, height: 116)
            self.textVielder.textColor = .black
            self.textVielder.backgroundColor = .white
        } else if numLines >= 6 {
        self.textVielder.frame = CGRect(x: 50, y: cureentframe.origin.y - 114, width: self.view.frame.width - 54, height: 134)
            self.textVielder.textColor = .black
            self.textVielder.backgroundColor = .white
        } else if numLines == 1 {
            if let origfram = self.origframe {
            self.textVielder.frame = origfram
            }
            if self.zoomed == true {
                self.textVielder.textColor = .white
            } else {
            self.textVielder.textColor = .black
            }
            self.textVielder.backgroundColor = .clear
        }
        }
      
    if let uid = Auth.auth().currentUser?.uid {
    if let theirId = self.theirUid {
    let ref = Database.database().reference()
    let feed = ["active" : theirId]
    ref.child("users").child(uid).updateChildValues(feed)
    }
    }
       
    } else {
        let ref = Database.database().reference()
      
            if let uid = Auth.auth().currentUser?.uid {
                ref.child("users").child(uid).child("active").removeValue()
            }
        
       
        }
        
    }
    
    
    
    var addScores = false

    // %%%%%%%%%%%%%%%%%%%%%%%%%                 Send Chats                     %%%%%%%%%%%%%%%%%%%%%%%%%%
    var once = false
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //create the updated text string
         if(text == "\n") {
        if textView.text != "" && textView.text != " " {
            // if create a new chat bc there is not one already, create one and send the message
            if createNewChat == true {
                print("create")
                createNewChat = false
                self.creatANewChat()
                return false
            } else {
                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                self.addAChat(message: textView.text, time: timeStamp)
                let ref = Database.database().reference()
              
                    if let uid = Auth.auth().currentUser?.uid {
                    ref.child("users").child(uid).child("active").removeValue()
                    }
                
                textVielder.text = ""
                placeholderLabel.isHidden = false
                if let originalFram = self.origframe {
                    textVielder.frame = originalFram
                }
                if self.zoomed == true {
                    self.textVielder.textColor = .white
                } else {
                    self.textVielder.textColor = .black
                }
                self.textVielder.backgroundColor = .clear
                return false
            }
            }
            textVielder.text = ""
         }
        if textVielder.text.count != 0 {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return true && newText.count <= 220
        }
        
        return true
        
    }
    
    
    func creatANewChat() {
        if self.textVielder.text != "" {
        if let theirId = theirUid {
            if let uid = Auth.auth().currentUser?.uid {
                print("new")
                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                let ref = Database.database().reference()
                if let theirName = self.theirName {
                    if once == false {
                        once = true
                        // remove anyvalues if they create at the same time
                        ref.child("users").child(uid).child("chats").child(theirId).removeValue()
                        ref.child("users").child(theirId).child("chats").child(uid).removeValue()
                        if let myName = Auth.auth().currentUser?.displayName {
                        
                                    let newChat = ["theirId" : theirId, "lastMessage" : timeStamp, "theirName" : theirName] as [String : Any]
                                    let myFeed = [theirId : newChat]
                                    
                                    ref.child("users").child(uid).child("chats").updateChildValues(myFeed)
                                    let theirNewChat = ["theirId" : uid, "lastMessage" : timeStamp, "theirName" : myName] as [String : Any]
                                    let feed = [uid : theirNewChat]
                                    ref.child("users").child(theirId).child("chats").updateChildValues(feed)
                                    
                                    self.addAChat(message: self.textVielder.text, time: timeStamp)
                                    self.addScores = true
                                }
                            }
                }
                self.textVielder.text = ""
                placeholderLabel.isHidden = false
            }
        }
        }
    }
 
    
   // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                             &&&&&&&&&&&&&&&&&&&&&&&&&&&
    //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  Send Message / Add message   %%%%%%%%%%%%%%%%%%%%%%%%%%%
    func addAChat (message: String, time: Int) {
        if let theirId = theirUid {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                
                let key = ref.child("users").child(uid).child("chats").child(theirId).childByAutoId().key
                let feedLi = ["message" : message, "sender" : uid, "timeStamp" : time, "key" : key] as [String : Any]
                let mySetup = [key : feedLi]
                let theirSetup = [key : feedLi]
                
                
                let unseenTheed = ["unseen" : "recieved"]
                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(unseenTheed)
                let unseenMeed = ["unseen" : "sent"]
                 ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(unseenMeed)
                
                let timer = ["lastMessage" : time]
                ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(timer)
                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(timer)
                
                
             ref.child("users").child(uid).child("chats").child(theirId).child("messages").updateChildValues(mySetup)
            ref.child("users").child(theirId).child("chats").child(uid).child("messages").updateChildValues(theirSetup)
                
                sendNotification()
            
                    }
        }
    }
    
    
    func sendNotification () {
        let ref = Database.database().reference()
        if let theirId = self.theirUid {
        if let uid = Auth.auth().currentUser?.uid {
        let timelnow: Int = Int(NSDate().timeIntervalSince1970)
        if timelnow - self.lastnotfic > 14 {
            ref.child("users").child(theirId).child("userKey").observeSingleEvent(of: .value, with: {(snapshot) in
                if let keyer = snapshot.value as? String {
                    ref.child("users").child(theirId).child("inChat").observeSingleEvent(of: .value, with: {(snapshoter) in
                        if let value = snapshoter.value as? String {
                            if value == uid || value == "nope" {
                                return
                            } else {
                                if let myName = Auth.auth().currentUser?.displayName {
                                    let messgae = "New chat from \(myName) "
                                    let data = [
                                        "contents": ["en": "\(messgae)"],
                                        "include_player_ids":["\(keyer)"],
                                        "ios_badgeType": "Increase",
                                        "ios_badgeCount": 1
                                        ] as [String : Any]
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                    OneSignal.postNotification(data)
                                    self.lastnotfic = timelnow
                                    print("sent notif")
                                    }
                                  
                                }
                                
                            }
                        } else {
                            if let myName = Auth.auth().currentUser?.displayName {
                                let messgae = "New chat from \(myName) "
                                
                                
                                let data = [
                                    "contents": ["en": "\(messgae)"],
                                    "include_player_ids":["\(keyer)"],
                                    "ios_badgeType": "Increase",
                                    "ios_badgeCount": 1
                                    ] as [String : Any]
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                OneSignal.postNotification(data)
                                }
                                print("sent notif")
                                self.lastnotfic = timelnow
                                
                            }
                            
                        }
                    })
                } else {
                    return
                }
            })
            
            }
            }
        }
    }
    
    
    
   
    ////****************************** Image posting ************************************* //
    
    
      let imagePicker = UIImagePickerController()
    @IBAction func cameraAct(_ sender: Any) {
      
        if createNewChat == true {
            print("no sending photos unless previous chat")
        } else {
        imagePicker.delegate = self
        let buoty = UIButton()
        buoty.frame = CGRect(x: self.view.frame.width - 50, y: 1, width: 40, height: 40)
        buoty.setImage(#imageLiteral(resourceName: "albumo"), for: .normal)
        buoty.backgroundColor = .clear
        imagePicker.view.addSubview(buoty)
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        buoty.addTarget(self, action: #selector(photoLibraryAction), for: .touchUpInside)
        
        
        self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func photoLibraryAction () {
        imagePicker.dismiss(animated: false, completion: nil)
        
        let imgPick = UIImagePickerController()
        imgPick.delegate = self
        imgPick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(imgPick, animated: false, completion: {
            
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
    self.postImage(image: selectedImage)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    var lastnotfic = Int()
    func postImage(image : UIImage) {
        let activity = UIActivityIndicatorView()
        activity.backgroundColor = .white
        activity.color = .black
        activity.frame = self.view.frame
       
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirUid {
                view.addSubview(activity)
                activity.startAnimating()
                let ref = Database.database().reference()
                let storage = Storage.storage().reference().child(uid).child("chats").child(theirId).child("imageUrl.jpg")
                
                storage.delete { error in
                    if let error = error {
                        print(error)
                    
                    } else {
                        // File deleted successfully
                    }
                }
                
                if let uploadData = UIImageJPEGRepresentation(image, 0.38) {
                    storage.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            if error != nil {
                                print(error!)
                                activity.stopAnimating()
                                return
                            }
                            if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                                   let timel: Int = Int(NSDate().timeIntervalSince1970)
                                
                                
                                let unseenTheed = ["unseen" : "recievedImage"]
                                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(unseenTheed)
                                let unseenMeed = ["unseen" : "sent"]
                                ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(unseenMeed)
                            
                                
                                let postFeed = ["imageUrl" : imagerUrl]
                                ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(postFeed)
                                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(postFeed)
                                
                                
                                let lastImage = ["imageTime" : timel]
                                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(lastImage)
                                
                                ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(lastImage)
                                
                             
                                let timer = ["lastMessage" : timel]
                                ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(timer)
                                ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(timer)
                                
                                
                               
                                let timelnow: Int = Int(NSDate().timeIntervalSince1970)
                                if timelnow - self.lastnotfic > 20 {
                               
                                    ref.child("users").child(theirId).child("userKey").observeSingleEvent(of: .value, with: {(snapshot) in
                                        if let keyer = snapshot.value as? String {
                                            ref.child("users").child(theirId).child("inChat").observeSingleEvent(of: .value, with: {(snapshoter) in
                                                if let value = snapshoter.value as? String {
                                                    if value == uid || value == "nope" {
                                                        return
                                                    } else {
                                                        if let myName = Auth.auth().currentUser?.displayName {
                                                            let messgae = "\(myName) sent you a photo"
                                                           
                                                            print("sending notif")
                                                            let data = [
                                                                "contents": ["en": "\(messgae)"],
                                                                "include_player_ids":["\(keyer)"],
                                                                "ios_badgeType": "Increase",
                                                                "ios_badgeCount": 1
                                                                ] as [String : Any]
                                                            OneSignal.postNotification(data)
                                                          
                                                            self.lastnotfic = timel
                                                        }
                                                        
                                                    }
                                                } else {
                                                    if let myName = Auth.auth().currentUser?.displayName {
                                                        let messgae = "\(myName) sent you a photo"
                                                      
                                                        print("sending notif")
                                                        let data = [
                                                            "contents": ["en": "\(messgae)"],
                                                            "include_player_ids":["\(keyer)"],
                                                            "ios_badgeType": "Increase",
                                                            "ios_badgeCount": 1
                                                            ] as [String : Any]
                                                        OneSignal.postNotification(data)
                                                          self.lastnotfic = timel
                                                      
                                                    }
                                                    
                                                }
                                            })
                                        } else {
                                            return
                                        }
                                    })
            
                                
                                }
                                
                                activity.stopAnimating()
                            }
                    })
                }
            }
        }
    }
    
    
    @objc func removePhoto () {
        if tablerView.isHidden == true {
            if let uid = Auth.auth().currentUser?.uid {
                if let theirId = self.theirUid {
                    let ref = Database.database().reference()
                    let alerter = UIAlertController(title: "Remove Background Photo", message: "Tap remove to remove the background photo", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Remove", style: .default, handler: { (alert: UIAlertAction) in
                        
                        
                        
                        ref.child("users").child(theirId).child("chats").child(uid).child("imageTime").removeValue()
                        ref.child("users").child(uid).child("chats").child(theirId).child("imageTime").removeValue()
                        ref.child("users").child(theirId).child("chats").child(uid).child("imageUrl").removeValue()
                        ref.child("users").child(uid).child("chats").child(theirId).child("imageUrl").removeValue()
                        
                        self.tablerView.isHidden = false
                        self.view.backgroundColor = .white
                        self.textVielder.becomeFirstResponder()
                        self.navigationController?.navigationBar.isHidden = false
                        self.viewlere.isHidden = false
                        self.textVielder.isHidden = false
                        self.cameraButton.isHidden = false
                        self.typingEmblem.isHidden = true
                        self.textVielder.textColor = .black
                        self.zoomed = false
                        self.tablerView.reloadData()
                        self.textVielder.layer.shadowColor = nil
                        self.textVielder.layer.shadowOpacity = 0
                        self.textVielder.layer.shadowRadius = 0
                    })
                    let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alerter.addAction(action)
                    alerter.addAction(canceler)
                    self.present(alerter, animated: true, completion: nil)
                    
                }
            }
        }
    }
  
    // &&&&&&&&&&&&&&&&&&&&&&&&&&& More Button - Save and see saved Messages %%%%%%%%%%%%%%%%%%%%%%%
   
       let seeSaved = UIButton()
    let buttonDone = UIButton()
    var allowedToSelect = false
      let labeler = UILabel()
    @IBAction func moreButtonAct(_ sender: Any) {
        let popup = UIAlertController(title: "Actions", message: "Select what you would like to do", preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "Save a message", style: .default, handler: { (alert : UIAlertAction) -> Void in
          
            self.seeSaved.isHidden = false
            self.labeler.isHidden = false
            self.buttonDone.isHidden = false
            self.cameraButton.isHidden = true
            self.view.removeGestureRecognizer(self.gelsture)
            
        self.viewlere.isHidden = true
            
            self.allowedToSelect = true
           self.textVielder.resignFirstResponder()
          
            self.labeler.frame = CGRect(x: 15, y: self.view.frame.height / 1.8, width: self.view.frame.width - 30, height: 50)
           self.labeler.backgroundColor = .white
            self.labeler.textColor = UIColor.black
            self.labeler.numberOfLines = 2
            self.labeler.textAlignment = .center
            self.labeler.layer.cornerRadius = 10.0
            self.labeler.clipsToBounds = true
            self.labeler.text = "Tap a message then click save, to save a message"
            self.labeler.font = UIFont(name: "Verdana", size: 16)
            self.view.addSubview(self.labeler)
            
            self.buttonDone.frame = CGRect(x: 50, y: self.view.frame.height / 1.5, width: self.view.frame.width - 100, height: 50)
            self.buttonDone.backgroundColor =  UIColor(red: 0, green: 0.8569, blue: 0.8098, alpha: 1.0)
            self.buttonDone.setTitle("Done", for: .normal)
            self.buttonDone.titleLabel?.font = UIFont(name: "Futura", size: 18)
            self.buttonDone.setTitleColor(.white, for: .normal)
            self.buttonDone.layer.cornerRadius = 22.0
            self.buttonDone.clipsToBounds = true
            self.buttonDone.addTarget(self, action: #selector(self.doner), for: .touchUpInside)
            self.view.addSubview(self.buttonDone)
            self.seeSaved.frame = CGRect(x: self.view.frame.width - 200, y: 80, width: 200, height: 25)
            self.seeSaved.setTitle("See saved messages >", for: .normal)
            self.seeSaved.titleLabel?.font = UIFont(name: "Futura", size: 16)
            self.seeSaved.setTitleColor(UIColor(red: 0, green: 0.5569, blue: 0.9569, alpha: 1.0), for: .normal)
            self.seeSaved.addTarget(self, action: #selector(self.seeSavedAct), for: .touchUpInside)
            if self.view.frame.width != 320 {
            self.view.addSubview(self.seeSaved)
            }
            
         
        })
        let actionTwo = UIAlertAction(title: "Saved messages", style: .default, handler: { (alert : UIAlertAction) -> Void in
          
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "savedChats") as! UINavigationController
             let dest = vc.viewControllers[0] as! SavedChatsViewController
            if let theirId = self.theirUid {
                dest.theirId = theirId
            }
            
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
            
            
        })
        
      
        let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        popup.addAction(actionOne)
        popup.addAction(actionTwo)
        popup.addAction(canceler)
        self.present(popup, animated: true, completion: nil)
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowedToSelect == true {
        let alert = UIAlertController(title: "", message: "\(messages[indexPath.section].messager!)", preferredStyle: .alert)
        let act = UIAlertAction(title: "Save", style: .default, handler: {(alert : UIAlertAction) -> Void in
            
            let ref = Database.database().reference()
            if let uid = Auth.auth().currentUser?.uid {
                
                if let theirId = self.theirUid {
                    ref.child("users").child(uid).child("chats").child(theirId).child("saveMessages").child(self.messages[indexPath.row].key).observeSingleEvent(of: .value, with: {(snapshot) in
                        if snapshot.exists() {
                            print("true")
                        } else {
                            let key = self.messages[indexPath.section].key!
                            let messagel = self.messages[indexPath.section].messager
                            let timer = self.messages[indexPath.section].timeStamp
                            let from = self.messages[indexPath.section].sender!
                            let feeder = ["message" : messagel!, "timeStamp" : timer!, "key" : key, "sender" : from] as [String : Any]
                            let feed = [key : feeder]
                            ref.child("users").child(uid).child("chats").child(theirId).child("savedMessages").updateChildValues(feed)
                        }
                    })
            
            }
            }
                   })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(act)
        alert.addAction(cancel)
        DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
        }
        }
    }
    
    @objc func doner () {
        self.labeler.isHidden = true
        self.buttonDone.isHidden = true
        self.view.addGestureRecognizer(gelsture)
        self.viewlere.isHidden = false
        self.cameraButton.isHidden = false
        self.textVielder.becomeFirstResponder()
        self.allowedToSelect = false
        self.seeSaved.isHidden = true
       
    }
    
    @objc func seeSavedAct () {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "savedChats") as! UINavigationController
        let dest = vc.viewControllers[0] as! SavedChatsViewController
        self.boolDont = true
        if let theirId = theirUid {
        dest.theirId = theirId
        }
      
        DispatchQueue.main.async {
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    // &&&&&&&&&&&&&&&&&&&&& Keyboard frame to add textfield and camera button ****************
  
    var origframe: CGRect?
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("keyboardFrame: \(keyboardFrame)")
        print(keyboardFrame.height)
        
        textVielder.frame = CGRect(x: 50, y:  self.view.frame.height - keyboardFrame.height - 31.5, width: self.view.frame.width - 54, height: 25)
        cameraButton.frame = CGRect(x: 6, y: self.view.frame.height - keyboardFrame.height - 42, width: 40, height: 40)
        viewlere.frame = CGRect(x: 50, y:  self.view.frame.height - keyboardFrame.height - 5, width: self.view.frame.width - 54, height: 1)
        typingEmblem.frame = CGRect(x: 10, y: self.view.frame.height - keyboardFrame.height - 72, width: 45, height: 45)
         placeholderLabel.frame.origin = CGPoint(x: 5, y: (textVielder.font?.pointSize)! / 2)
        print(viewlere.frame)
        origframe = textVielder.frame
    }
    
    
    /// ####################### View will Dissappear
    override func viewWillDisappear(_ animated: Bool) {
        if self.dismissing == false {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
          ref.child("users").child(uid).child("inChat").removeValue()
           ref.child("users").child(uid).child("active").removeValue()
        
        }
        }
    
    }
    
    func updateUnseens () {
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = self.theirUid {
                let ref = Database.database().reference()
        
                if let origUnseen = self.originalUnseen {
                    if origUnseen == "recievedImage" {
                    
                        let unseenTheed = ["unseen" : "iViewed"]
                        ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(unseenTheed)
                        let unseenMeed = ["unseen" : "iImaged"]
                        ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(unseenMeed)
                        self.originalUnseen = nil
                    }
                } else {
                ref.child("users").child(uid).child("chats").child(theirId).child("unseen").observeSingleEvent(of: .value, with: { (snapshoty) in
                    if let snapshoti = snapshoty.value as? String {
                       
                        if snapshoti == "recievedImage" {
                            let unseenTheed = ["unseen" : "iViewed"]
                            ref.child("users").child(theirId).child("chats").child(uid).updateChildValues(unseenTheed)
                            let unseenMeed = ["unseen" : "iImaged"]
                            ref.child("users").child(uid).child("chats").child(theirId).updateChildValues(unseenMeed)
                        }
                    }
                })
                }
                
            }
        }
    }
    
    
  

}







