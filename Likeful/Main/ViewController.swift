//
//  ViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/2/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ALCameraViewController
import OneSignal

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, abc {


    
    @IBAction func openMessaging(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newMessage")
          DispatchQueue.main.async {
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    var hide = false
    override func viewWillAppear(_ animated: Bool) {
        
       self.dontremove = false
        self.cameraButtony.isHidden = true
        self.cameraButtony.removeFromSuperview()
        if hide == false {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        }
       
    }
    
    
   
    
    
    var liveFunc = false
    override func viewDidAppear(_ animated: Bool) {
        if liveFunc == true {
            self.liveChats()
        }
       
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference()
            let updater = ["inChat" : "nope"]
            ref.child("users").child(uid).updateChildValues(updater)
        }
    }
   
    let buttonShowDesc = UIButton()
    
   
    @IBOutlet weak var yourMatches: UILabel!
    let activityIndc = UIActivityIndicatorView()
      let datePicker = UIDatePicker()

    var likers = [Userly]()
 
    var feeds = [Photo]()
   
    @IBOutlet weak var collectionerView: UICollectionView!
  
    
      let viewForDate = UIView()
    func usersWithoutDob () {
        // users who were on app previous to age requirement (84)
        // i added the change age child to their user value
        // i check for it here and have the user pick their date of birth
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
        ref.child("users").child(uid).child("DOB").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let valuers = snapshot.value as? [String : AnyObject] {
             
                        if let yeare = valuers["Year"] as? Int, let dayy = valuers["Day"] as? Int, let monthe = valuers["Month"] as? Int {
                          
                            let date = Date()
                            let calendarr = Calendar.current
                            
                            let year = calendarr.component(.year, from: date)
                            let month = calendarr.component(.month, from: date)
                            let day = calendarr.component(.day, from: date)
                            
                            if month == monthe && day == dayy {
                                let newNey = year - yeare
                                UserDefaults.standard.set(newNey, forKey: "age")
                                let feed: [String : Any] = ["age" : newNey]
                                ref.child("users").child(uid).updateChildValues(feed)
                                
                            }
                        }
                 }
            } else {
             
                var components = DateComponents()
                components.year = -100
                let minDate = Calendar.current.date(byAdding: components, to: Date())
                self.labelGo.isHidden = true
                components.year = -14
                let maxDate = Calendar.current.date(byAdding: components, to: Date())
                self.datePicker.addTarget(self, action: #selector(self.pickerFunc), for: .valueChanged)
                self.datePicker.minimumDate = minDate
                self.datePicker.maximumDate = maxDate
                self.viewForDate.frame = CGRect(x: 30, y: 100, width: self.view.frame.width - 60, height: self.view.frame.height - 200)
                self.viewForDate.backgroundColor = UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 1.0)
                self.viewForDate.layer.cornerRadius = 10.0
                self.viewForDate.clipsToBounds = true
                self.view.addSubview(self.viewForDate)
                self.viewForDate.layer.borderColor = UIColor.black.cgColor
                self.viewForDate.layer.borderWidth = 1.0
             
                self.datePicker.datePickerMode = .date
                self.datePicker.frame = CGRect(x: 5, y: 50, width: self.viewForDate.frame.width - 10, height: self.viewForDate.frame.height - 150)
                let topLabel = UILabel()
                topLabel.frame = CGRect(x: 10, y: 10, width: self.viewForDate.frame.width - 20, height: 20)
                topLabel.font = UIFont(name: "Futura", size: 18)
                topLabel.text = "Select your Date of Birth"
                topLabel.textAlignment = .center
                self.viewForDate.addSubview(self.datePicker)
                self.viewForDate.addSubview(topLabel)
                self.buttonoProf.isHidden = true
                self.buttonCam.isHidden = true
                let buttonDismiss = UIButton()
                buttonDismiss.frame = CGRect(x: 10, y: self.viewForDate.frame.height - 70, width: self.viewForDate.frame.width - 20, height: 45)
                buttonDismiss.layer.cornerRadius = 18.0
                buttonDismiss.clipsToBounds = true
                buttonDismiss.backgroundColor = UIColor(red: 0, green: 0.4863, blue: 0.6078, alpha: 1.0)
                buttonDismiss.setTitleColor(.white, for: .normal)
                buttonDismiss.titleLabel?.font = UIFont(name: "Futura", size: 16)
                buttonDismiss.setTitle("Done", for: .normal)
                buttonDismiss.addTarget(self, action: #selector(self.donePicking), for: .touchUpInside)
                self.tablerView.allowsSelection = false
                self.viewForDate.addSubview(buttonDismiss)
                self.viewForDate.addSubview(buttonDismiss)
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
                self.dot.isHidden = true
                self.collectionerView.isHidden = true
                self.labelTop.isHidden = true
            }
        })
            
        }
     
    }
    
    var dateSelected: Date?
    @objc func donePicking () {
        if let uid = Auth.auth().currentUser?.uid {
        if let dateSelected = dateSelected {
        let now = Date()
        let birthday: Date = dateSelected
        let calendar = Calendar.current
            let components = calendar.dateComponents([.day,.month,.year], from: self.datePicker.date)
        
            
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
     
        if age >= 14 {
            self.viewForDate.isHidden = true
            self.tablerView.allowsSelection = true
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.dot.isHidden = false
            let ref = Database.database().reference()
            let fixAge: [String : Any] = ["age" : age]
            ref.child("users").child(uid).updateChildValues(fixAge)
            let feed: [String : Any] = ["Month" : components.month!, "Day" : components.day!, "Year" : components.year!]
            ref.child("users").child(uid).child("DOB").updateChildValues(feed)
            if self.matchCount == 0 {
                self.buttonoProf.isHidden = false
                self.labelGo.isHidden = false
                self.labelTop.isHidden = false
            }
            if self.feeds.count != 0 {
          self.collectionerView.isHidden = false
            }
              self.buttonCam.isHidden = false
            
                   }
            }
        }
    }
    @objc func pickerFunc () {
      dateSelected = datePicker.date
    }
  
    func updateTime (score: Int) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
              let timeNow: Int = Int(NSDate().timeIntervalSince1970)
            ref.child("users").child(uid).child("lastLog").observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? Int {
                    if timeNow - value > 172800 {
                        let updteLost = ["decreased" : timeNow]
                        ref.child("users").child(uid).updateChildValues(updteLost)
                        ref.child("users").child(uid).child("increased").removeValue()
                        if score >= 2 {
                        let final = score - 2
                        let anotherUpd = ["score" : final]
                        ref.child("users").child(uid).updateChildValues(anotherUpd)
                        }
                    } else if timeNow - value > 7200 {
                        let updteAdd = ["increased" : "one"]
                        ref.child("users").child(uid).updateChildValues(updteAdd)
                        ref.child("users").child(uid).child("decreased").removeValue()
                        let final = score + 1
                        let anotherUpd = ["score" : final]
                        ref.child("users").child(uid).updateChildValues(anotherUpd)
                    }
                    let feed = ["lastLog" : timeNow]
                    ref.child("users").child(uid).updateChildValues(feed)
                } else {
                    if let matcherts = self.matchCount {
                        let theVal = matcherts * 100
                        let final = theVal + 15
                       
                        let anotherUpd = ["score" : final]
                        ref.child("users").child(uid).updateChildValues(anotherUpd)
                        
                    } else {
                        let final = 5
                        let anotherUpd = ["score" : final]
                        ref.child("users").child(uid).updateChildValues(anotherUpd)
                        
                    }
                    let feed = ["lastLog" : timeNow]
                    ref.child("users").child(uid).updateChildValues(feed)
                    let updteAdd = ["increased" : "inc"]
                    ref.child("users").child(uid).updateChildValues(updteAdd)
                }
            })
            
        }
    }
    
    
  
    
    
        
   
    override func viewWillLayoutSubviews() {
    
        if self.view.frame.height == 812 {
            tablerView.frame = CGRect(x: 0, y: 112, width: self.view.frame.width, height: self.view.frame.height - 160)
            yourMatches.frame = CGRect(x: 5, y: 89.5, width: 250, height: 20)
          
            
        }
        if self.view.frame.width == 320 {
             yourMatches.font = UIFont(name: "Futura", size: 16)
          
        }

        activityIndc.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        activityIndc.color = UIColor(red: 0, green: 0.2824, blue: 0.5294, alpha: 1.0)
   
       
        self.stuffLabel.frame = CGRect(x: 10, y: 15, width: 300, height: 50)
        self.stuffLabel.font = UIFont(name: "Futura", size: 18)
        self.stuffLabel.textColor = .white
        self.stuffLabel.numberOfLines = 2
        if self.view.frame.height == 812 {
             self.stuffLabel.frame = CGRect(x: 10, y: 35, width: 300, height: 50)
        }
        self.collectionerView.clipsToBounds = false
      
        
    }
    
    func saveAge () {
        if let age = UserDefaults.standard.object(forKey: "age") as? Int {
            print("all gucci \(age)")
        } else {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("age").observeSingleEvent(of: .value, with: {(snaphop) in
                    if let ager = snaphop.value as? Int {
                         UserDefaults.standard.set(ager, forKey: "age")
                        return
                    }
                })
            }
        }
    }
    
    
    func checkLoggedin () {
        if Auth.auth().currentUser?.uid == nil {
            
            perform(#selector(logoutnow), with: nil, afterDelay: 0)
            
        }
        else {
            print("your good")
        }
        
    }
    @objc func logoutnow () {
        do {
            try Auth.auth().signOut()
        }   catch let loginError {
            print(loginError)
        }
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpOrLogin")
        self.present(vc, animated: true, completion: nil)
    }
     let refreshControl = UIRefreshControl()
    @IBOutlet weak var tablerView: UITableView!
    
    func grabUnseenMessagesCount() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
           
            ref.child("users").child(uid).child("Notifications").observeSingleEvent(of: .value, with: {(snapshoti) in
                var unseners = [String]()
                if let notifs = snapshoti.value as? [String : AnyObject] {
                    for (_, val) in notifs {
                        if let unseener = val["unseen"] as? String {
                           unseners.append(unseener)
                            self.tabBarController?.tabBar.items?[1].badgeValue = "\(unseners.count)"
                        }
                    }
                    
                }
            }, withCancel: nil)
        }
    }
    
    func grabScore () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("score").observeSingleEvent(of: .value, with: {(snapsht) in
                if let scorei = snapsht.value as? Int {
                    self.updateTime(score: scorei)
                } else {
                    let anotherUpd = ["score" : 5]
                    ref.child("users").child(uid).updateChildValues(anotherUpd)
                }
            })
        }
    }

    let buttonCam = UIButton()
    var gesturSwipeUp = UISwipeGestureRecognizer()
    // %%%%%%%%% View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedin()
        grably()
        getFeed()
        if Auth.auth().currentUser?.uid != nil {
            self.view.addSubview(activityIndc)
            self.activityIndc.startAnimating()
        }
       self.collectionerView.frame = CGRect(x: 0, y: self.view.frame.height - 122, width: self.view.frame.width, height: 122)
          grabUnseenMessagesCount()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.2039, green: 0, blue: 0.949, alpha: 1.0)
      
        if #available(iOS 10.0, *) {
            tablerView.refreshControl = refreshControl
            
        } else {
            tablerView.backgroundView = refreshControl
        }
        self.swipeDown.direction = .down
    
        self.swipeDown.addTarget(self, action: #selector(self.swiperDown))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closing(notification:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closing(notification:)),
            name: NSNotification.Name.UIApplicationWillTerminate,
            object: nil)
      
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
        

        self.collectionerView.backgroundColor = .clear
        gesturSwipeUp.direction = .up
        gesturSwipeUp.addTarget(self, action: #selector(self.openFeed))
        self.collectionerView.addGestureRecognizer(gesturSwipeUp)
        collectionerView.delegate = self
        collectionerView.dataSource = self
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "profiley.png"), style:.plain, target: self , action: #selector(goToProf))
        self.navigationController?.navigationBar.tintColor = .black
      
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 25)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        
        self.swipeDowngest.addTarget(self, action: #selector(self.showDescript))
        self.swipeDowngest.direction = .down
        self.swipeUpGest.addTarget(self, action: #selector(self.showDescript))
        self.swipeUpGest.direction = .up
       
        tablerView.delegate = self
        tablerView.dataSource = self
        if Auth.auth().currentUser?.uid != nil {
        checkAndRemove()
        }
        addDot()
        usersWithoutDob()
        saveAge()
        grabScore()
        buttonCam.frame = CGRect(x: self.view.frame.width - 85, y: self.view.frame.height - 135, width: 75, height: 75)
        buttonCam.setImage(#imageLiteral(resourceName: "iconPhoto"), for: .normal)
        buttonCam.addTarget(self, action: #selector(self.buttonCameraAction), for: .touchUpInside)
        view.addSubview(self.buttonCam)
        if self.view.frame.width == 320 {
            self.buttonCam.frame = CGRect(x: self.view.frame.width - 85, y: self.view.frame.height - 130, width: 70, height: 70)
           
        }
        if self.view.frame.height == 812 {
            self.buttonCam.frame = CGRect(x: self.view.frame.width - 85, y: self.view.frame.height - 160, width: 70, height: 70)
           self.collectionerView.frame = CGRect(x: 0, y: self.view.frame.height - 132, width: self.view.frame.width, height: 122)
        }
        self.buttonShowDesc.frame = CGRect(x: 10, y: self.view.frame.height - 50, width: 40, height: 40)
        self.buttonShowDesc.setImage(#imageLiteral(resourceName: "showUp"), for: .normal)
        self.buttonShowDesc.addTarget(self, action: #selector(self.showDescript), for: .touchUpInside)
        self.removeOldImages()
 
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
    }
  
    


@objc func applicationDidBecomeActive(notification: NSNotification) {
    if let myUid = Auth.auth().currentUser?.uid {
        let ref = Database.database().reference()
      
            let imOnline = ["inChat" : "nope"]
            ref.child("users").child(myUid).updateChildValues(imOnline)
    }
    }
    
    @objc func closing (notification: NSNotification) {
        if scrolled == true {
            scrolled = false
            if self.removes.count != 0 {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    for each in removes {
                        ref.child("users").child(uid).child("Feed").child(each).removeValue()
                    }
                    if self.sendSeens.count != 0 {
                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                        let feedy = [uid : timeStamp]
                        for each in self.sendSeens {
                            ref.child("users").child(each).child("dailyViews").updateChildValues(feedy)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
    
    
    func checkAndRemove () {
        
        print("callerrd")
   
        if let uid = Auth.auth().currentUser?.uid {
          let ref = Database.database().reference()
            if let newUser = UserDefaults.standard.value(forKey: "newUser") as? Int {
                if newUser != 0 {
                    let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                    let timer = timeStamp - newUser
                    //call have photos check
                  
                    let hours = timer /  432000
                    
                    if hours >= 2 {
                        
                        ref.child("newUsers").observeSingleEvent(of: .value, with: {(snapshot) in
                            if let snapshoter = snapshot.value as? [String : AnyObject] {
                                if snapshoter.count > 100 {
                                    ref.child("users").child(uid).child("newUser").removeValue()
                                    ref.child("newUsers").child(uid).removeValue()
                                    UserDefaults.standard.set(0, forKey: "newUser")
                                } else {
                                    return
                                }
                            }
                        })
                        
                    }
                }
                } else {
                print("none")
                    self.activityIndc.stopAnimating()
                }
        }
        
    }
    
    
    @objc func refresh () {
        likers.removeAll()
        self.reloaders.removeAll()
        tablerView.reloadData()
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("chats").removeAllObservers()
        }
        grably()
        print("refreshing")
        refreshControl.endRefreshing()
        if self.feeds.count <= 1 {
            self.getFeed()
        }
    }
    @objc func goToProf () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile")
        
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
   
    
    // ******** TABLE VIEW ************//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likers.count
    }
    
    // CELL FOR ROW *************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        cell.imagerView.layer.cornerRadius = 26.0
        cell.imagerView.clipsToBounds = true
        cell.backView.layer.cornerRadius = 28.0
        cell.backView.clipsToBounds = true
        cell.notSeenViewer.frame = CGRect(x: cell.frame.width - 42, y: cell.frame.height / 3.45, width: 26, height: 26)
      
        cell.buttonFeed.isEnabled = false
        
        cell.furtherBackView.layer.cornerRadius = 30.0
        cell.furtherBackView.clipsToBounds = true
    cell.mainLabel.frame = CGRect(x: 73, y: 12, width: self.view.frame.width - 95, height: 22)
    cell.subLabel.frame = CGRect(x: 73, y: 36, width: self.view.frame.width - 75, height: 20)
         cell.mainLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        //likers
        
        if indexPath.section == 0 {
            if let imager = likers[indexPath.row].imageUrl {
                let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
                cell.imagerView.kf.indicatorType = .activity
                cell.imagerView.kf.setImage(with: restource, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if let error = error {
                        print(error)
                        cell.imagerView.image = #imageLiteral(resourceName: "profiler")
                    }
                })
            } else {
                 cell.imagerView.image = nil
                cell.imagerView.image = UIImage(named: "profiler")
            }
            cell.mainLabel.text = likers[indexPath.row].namer
            if let lasterMess = likers[indexPath.row].lastMessage {
                if lasterMess == 1 {
                     cell.subLabel.text =  "• Tap to chat"
                } else {
                    let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                    let timer = timeStamp - lasterMess
                    
                    if timer <= 59 {
                        cell.subLabel.text = "• \(timer)s ago"
                    }
                    
                    if timer > 59 && timer < 3600 {
                        let minuters = timer / 60
                        cell.subLabel.text = "• \(minuters)mins ago"
                        if minuters == 1 {
                            cell.subLabel.text = "• \(minuters)min ago"
                        }
                    }
                    if timer > 59 && timer >= 3600 && timer < 86400 {
                      
                        let hours = timer / 3600
                        
                        if hours <= 4 {
                            if hours == 1 {
                                cell.subLabel.text = "• \(hours)hr ago"
                            } else {
                            cell.subLabel.text = "• \(hours)hrs ago"
                            }
                        }
                        if hours > 4 {
                            if let unseen = likers[indexPath.row].isUnseen {
                                if unseen != "recieved" {
                              if let lastLog = likers[indexPath.row].lastLog {
                                cell.subLabel.text = getTime(lastLog: lastLog)
                              } else {
                                cell.subLabel.text = "• \(hours)hrs ago"
                            }
                                } else {
                                    cell.subLabel.text = "• \(hours)hrs ago"
                                }
                            } else {
                                cell.subLabel.text = "• \(hours)hrs ago"
                            }
                        }
                    }
                    if timer > 86400 {
                        
                        if let lastLog = likers[indexPath.row].lastLog {
                            cell.subLabel.text = getTime(lastLog: lastLog)
                        } else {
                        let days = timer / 86400
                        cell.subLabel.text = "• \(days)days ago"
                        if days == 1 {
                            cell.subLabel.text = "• \(days)day ago"
                        }
                        }
                    }
                }
            } else {
            cell.subLabel.text =  "• Tap to chat"
            }
            cell.furtherBackView.backgroundColor = .white
            if let unseener = likers[indexPath.row].isUnseen {
                  print(unseener)
                if unseener == "recieved" {
                    cell.notSeenViewer.frame = CGRect(x: cell.frame.width - 42, y: cell.frame.height / 3.5, width: 30, height: 30)
                cell.mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                cell.notSeenViewer.image = #imageLiteral(resourceName: "chatMessage")
                    if cell.subLabel.text != "" {
                let editedText = cell.subLabel.text?.replacingOccurrences(of: "•", with: "")
                    let myString = "• New Chat -\(editedText!)"
                    var myMutableString = NSMutableAttributedString()
                    myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Futura", size: 14.0)!])
                    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:1))
                        let bigBoldFont = UIFont.boldSystemFont(ofSize: 18.0)
                        myMutableString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: bigBoldFont, range: NSMakeRange(0, 1))
                    // set label Attribute
                    cell.subLabel.attributedText = myMutableString
                   
                    }
                }
                if unseener == "meViewed" {
                    cell.notSeenViewer.image = #imageLiteral(resourceName: "seenChat")
                }
                if unseener == "sent" {
                    cell.notSeenViewer.image = #imageLiteral(resourceName: "sentMessage")
                }
                if unseener == "iViewed" {
                    cell.notSeenViewer.image = #imageLiteral(resourceName: "blueSeen")
                }
                if unseener == "recievedImage" {
                    cell.notSeenViewer.frame = CGRect(x: cell.frame.width - 42, y: cell.frame.height / 3.5, width: 30, height: 30)
                    cell.notSeenViewer.image = #imageLiteral(resourceName: "gotPhoto")
                    let myString = "• Sent you a photo"
                    var myMutableString = NSMutableAttributedString()
                    print("cahhing")
                    cell.mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                    myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Futura", size: 14.0)!])
                    cell.subLabel.attributedText = myMutableString
                }
                if unseener == "iImaged" {
                    cell.notSeenViewer.image = #imageLiteral(resourceName: "seenPhoto")
                }
            } else {
                cell.notSeenViewer.image = nil
               
            }
            
            if let hasPost = self.likers[indexPath.row].hasFeed {
                print(hasPost)
                 cell.buttonFeed.removeTarget(self, action: #selector(self.showUserNoFeed(sender:)), for: .touchUpInside)
               cell.furtherBackView.backgroundColor = UIColor(red: 1, green: 0, blue: 0.6314, alpha: 1.0)
                cell.buttonFeed.isEnabled = true
                cell.buttonFeed.tag = indexPath.row
                cell.buttonFeed.addTarget(self, action: #selector(self.connected(sender:)), for: .touchUpInside)
                let myString = "• Added to your feed"
                var myMutableString = NSMutableAttributedString()
                print("cahhing")
                myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Futura", size: 14.0)!])
                  if let unseener = likers[indexPath.row].isUnseen {
                    if unseener != "recieved" {
                         cell.subLabel.attributedText = myMutableString
                    }
                  } else {
                cell.subLabel.attributedText = myMutableString
                }
            } else {
                cell.buttonFeed.isEnabled = true
                cell.buttonFeed.tag = indexPath.row
                cell.buttonFeed.addTarget(self, action: #selector(self.showUserNoFeed(sender:)), for: .touchUpInside)
                cell.furtherBackView.backgroundColor = .white
            }
            
                //UIColor(red: 0.9373, green: 0, blue: 0.4196, alpha: 1.0)
        }
        
        return cell
    }
    
    func getTime(lastLog:Int) -> String {
        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
        let timerr = timeStamp - lastLog
        
        let someDate = Date().startOfDay
        let timeInterval = Int(someDate.timeIntervalSince1970)
        let hoursToday = (timeStamp - timeInterval) / 3600
        print(timeInterval)
        if timerr <= 59 {
            return "• Active now"
        }
        if timerr > 59 && timerr < 3600 {
            let minuters = timerr / 60
           
            if minuters <= 5 {
                return "• Active now"
            } else {
                 return "• Active \(minuters)mins ago"
            }
        }
        if timerr > 59 && timerr >= 3600 && timerr < 86400 {
            
            let hours = timerr / 3600
            
            if hours == 1 {
                return "• Active \(hours)hr ago"
            }
            if hours <= 4 {
                return "• Active \(hours)hrs ago"
            } else {
                if hours < hoursToday {
                 return "• Active today"
                } else {
                    return "• Active yesterday"
                }
            }
            
        }
        if timerr >= 86400 {
            let days = timerr / 86400
            
            if days <= 7 {
            if days == 1 {
               return "• Active yesterday"
            }
               return "• Active this week"
            } else {
                 return "• Active recently"
            }
           
        }
        return ""
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        if let rower = self.likers[buttonTag].hasFeed {
            let selectIndexpat = IndexPath(item: rower, section: 0)
             DispatchQueue.main.async {
            self.collectionerView.selectItem(at: selectIndexpat, animated: true, scrollPosition: .centeredHorizontally)
                print("done")
                
                self.collectionerView.delegate?.collectionView!(self.collectionerView, didSelectItemAt: selectIndexpat)
            }
            
        }
    }
    
    @objc func showUserNoFeed(sender: UIButton) {
          let buttonTag = sender.tag
        self.segueIndex = buttonTag
        DispatchQueue.main.async {
       self.performSegue(withIdentifier: "segueShowUserMain", sender: self)
        }
    }
    var segueIndex: Int?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        self.dontremove = true
           let lipto = tablerView.cellForRow(at: indexPath) as! MainTableViewCell
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chosenChat")
            as! UINavigationController
        let dest = vc.viewControllers[0] as! ChosenChatViewController
        dest.theirName = likers[indexPath.row].namer
        dest.theirUid = likers[indexPath.row].uider
        dest.lastMessage = likers[indexPath.row].lastMessage
       
        if let unseeney = likers[indexPath.row].isUnseen {
            if unseeney == "recievedImage" {
                dest.originalUnseen = unseeney
            }
            
        }
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: {
                if indexPath.section == 0 {
                    
                    if let notSeener = self.likers[indexPath.row].isUnseen {
                        
                        if notSeener == "recieved" {
                            lipto.backgroundColor = .clear
                            self.likers[indexPath.row].isUnseen = "meViewed"
                            self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                        if notSeener == "recievedImage" {
                            lipto.backgroundColor = .clear
                            self.likers[indexPath.row].isUnseen = "iImaged"
                            self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                        }
                        
                        print("\(notSeener) main")
                    }
                }
            })
        }
    }
    
    
    /// SEGUE *******
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
      
        if segue.identifier == "segueShowUserMain" {
            let dest = segue.destination as! UserViewController
            if let index = self.segueIndex {
                let indexPath = IndexPath(row: index, section: 0)
            let cell = tablerView.cellForRow(at: indexPath) as! MainTableViewCell
            dest.imagel = cell.imagerView.image
            dest.areMatched = "yes"
                dest.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 16)!, NSAttributedStringKey.foregroundColor : UIColor.black]
                dest.namer = likers[index].namer
                dest.userName = likers[index].username
                dest.yourInt = likers[index].interl
                dest.id = likers[index].uider
                if let theirUrl = self.likers[index].imageUrl {
                dest.theirUrl = theirUrl
                }
               self.segueIndex = nil
            
            }
        }
    }
  
    var matchCount: Int?
    let buttonoProf = UIButton()
    let labelGo = UIButton()
    let labelTop = UILabel()
    func grably () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? [String : AnyObject] {
                    self.yourMatches.text = "Your connections • \(value.count)"
                    self.matchCount = value.count
                    self.buttonoProf.isHidden = true
                    self.labelGo.isHidden = true
                    self.labelTop.isHidden = true
                    for (one, val) in value {
                        self.loadUser(uid: one, inter: val as! Int, reload: false)
                    }
                    print(self.likers.count)
                   
                } else {
                 self.matchCount = 0
                   
                    self.activityIndc.stopAnimating()
                      self.yourMatches.text = "Your connections • 0"
                    self.labelTop.frame = CGRect(x: 25, y: self.view.frame.height / 4, width: self.view.frame.width - 50, height: 70)
                    self.labelTop.font = UIFont(name: "Avenir-Medium", size: 22)
                    self.labelTop.numberOfLines = 2
                    self.labelTop.text = "Connections will show up here. \n You currently don't have any."
                   self.labelTop.textAlignment = .center
                    self.labelTop.textColor = UIColor.darkGray
                     self.view.addSubview(self.labelTop)
                    
                    self.buttonoProf.frame = CGRect(x: 30, y: self.view.frame.height / 2, width: self.view.frame.width - 60, height: 50)
                    self.buttonoProf.backgroundColor = .white
                    self.buttonoProf.setTitle("Or edit your profile.", for: .normal)
                    self.buttonoProf.titleLabel?.font = UIFont(name: "Futura", size: 18)
                    self.buttonoProf.addTarget(self, action: #selector(self.goToProf), for: .touchUpInside)
                    self.buttonoProf.layer.cornerRadius = 12.0
                    self.buttonoProf.clipsToBounds = true
                    self.view.addSubview(self.buttonoProf)
                    self.buttonoProf.setTitleColor(UIColor(red: 0, green: 0.5098, blue: 0.9882, alpha: 1.0), for: .normal)
                    
                    if self.view.frame.width == 320 {
                        self.labelTop.frame = CGRect(x: 10, y: self.view.frame.height / 4, width: self.view.frame.width - 20, height: 70)
                        self.labelTop.font = UIFont(name: "Futura", size: 19)
                    }
                    
                    self.labelGo.setTitle("Find people you know", for: .normal)
                    self.labelGo.titleLabel?.font = UIFont(name: "Futura", size: 22)
                   
                    self.labelGo.setTitleColor(.white, for: .normal)
                    self.labelGo.backgroundColor = UIColor(red: 0, green: 0.5098, blue: 0.9882, alpha: 1.0)
                    self.labelGo.frame = CGRect(x: 30, y: self.view.frame.height / 2.5, width: self.view.frame.width - 60, height: 50)
                    self.labelGo.addTarget(self, action: #selector(self.findPeople), for: .touchUpInside)
                    self.labelGo.layer.cornerRadius = 12.0
                    self.labelGo.clipsToBounds = true
                    self.view.addSubview(self.labelGo)
                    self.buttonoProf.isHidden = false
                    self.labelGo.isHidden = false
                    self.labelTop.isHidden = false
                }
            }, withCancel: nil)
        }
    }
    
    @objc func findPeople () {
    tabBarController?.selectedIndex = 1
    }
    
    
    func loadUser(uid: String, inter: Int, reload: Bool) {
        var reload = false
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String {
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                newpUser.interl = inter
                if let urler = value?["profileUrl"] as? String {
                    newpUser.imageUrl = urler
                }
                if let lastLog = value?["lastLog"] as? Int {
                    newpUser.lastLog = lastLog
                }
                newpUser.lastMessage = 1

                    if self.likers.contains( where: { $0.uider == newpUser.uider }) || newpUser.uider == Auth.auth().currentUser?.uid {
                        
                    } else {
                    self.likers.append(newpUser)
                        reload = true
                    }

                self.getChats(uid: uid, interl: inter)

                self.activityIndc.stopAnimating()
              
            }
            if reload == true {
            if self.likers.count == self.matchCount {
            self.tablerView.reloadData()
                reload = false
                print("reloaded whole tblv")
            }
            }
            
            
        })
        
    }
    // refresh main functions ex - login
    func dothingis () {
        likers.removeAll()
        reloaders.removeAll()
        tablerView.reloadData()
        grably()
        checkAndRemove()
        feeds.removeAll()
        collectionerView.reloadData()
        sendSeens.removeAll()
        removes.removeAll()
        getFeed()
        grabScore()
        grabAFeedTutorial()
    }
 
    func grabAFeedTutorial () {
        let ref = Database.database().reference()
        ref.child("tutorialPhotos").child("photoUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if let tutorialPhoto = snapshot.value as? String {
                  let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                let newPhoto = Photo()
                newPhoto.photoUrl = tutorialPhoto
                newPhoto.name = "Flurl"
                newPhoto.timeStamp = timeStamp
                newPhoto.key = "key"
                newPhoto.text = "none$"
                newPhoto.uider = "flurl"
                if self.feeds.contains( where: { $0.key == newPhoto.key }) && self.feeds.count == 0 {
                    
                } else {
                   self.feeds.append(newPhoto)
                    if self.feeds.count != 0 && self.feeds.count < 2 {
                        
                        self.feeds.sort { $1.timeStamp < $0.timeStamp }
                        DispatchQueue.main.async {
                            self.collectionerView.isHidden = false
                            self.collectionerView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    
    

    let dot = UIView()
    func addDot() {

        dot.isHidden = false
        dot.frame = CGRect(x: self.view.frame.width - 97.5, y: self.view.frame.height - 9.5, width: 7, height: 7)
        dot.backgroundColor = UIColor(red: 0.949, green: 0.251, blue: 0, alpha: 1.0)
        dot.layer.cornerRadius = 3.5
        dot.clipsToBounds = true
        if self.view.frame.height == 812 {
            dot.frame = CGRect(x: self.view.frame.width - 97.5, y: self.view.frame.height - 44.0, width: 7, height: 7)
        }
        if self.view.frame.width == 320 {
             dot.frame = CGRect(x: self.view.frame.width - 85.5, y: self.view.frame.height - 9.5, width: 7, height: 7)
        }
        if self.view.frame.width == 414 {
             dot.frame = CGRect(x: self.view.frame.width - 106.5, y: self.view.frame.height - 9.5, width: 7, height: 7)
        }
        
        tabBarController?.view.addSubview(dot)
    }
    func removerDot () {
        if dot.isHidden == false {
        dot.removeFromSuperview()
        dot.isHidden = true
         self.tabBarController?.tabBar.items?[1].title = "Discover"
        }
    }

    
    
   
    
    // ================================= Collection View - Feed ==================================== //
    
    // collectionview
    var small = true
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if small == true {
             return CGSize(width: collectionerView.frame.width - 100, height: collectionerView.frame.height)
        }
    
        return CGSize(width: collectionerView.frame.width, height: collectionerView.frame.height)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if small == true {
            if feeds.count > 20 {
                return 20
            }
        }
        return feeds.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! HomeCollectionViewCell
        let topLabel = UILabel()
        topLabel.frame = CGRect(x: 8, y: 3, width: 250, height: 45)
        topLabel.numberOfLines = 2
        topLabel.font = UIFont(name: "Futura", size: 13)
        topLabel.textColor = .white
        
        let miniView = UIView()
        miniView.frame = CGRect(x: cell.frame.width - 40, y: 10, width: 12, height: 12)
        miniView.backgroundColor = UIColor(red: 0, green: 0.9294, blue: 0.9765, alpha: 1.0)
       miniView.layer.cornerRadius = 6.0
        miniView.clipsToBounds = true
        
        if let seconds = feeds[indexPath.row].timeStamp {
            
            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
            let timer = timeStamp - seconds
           
            if timer <= 59 {
                topLabel.text = ("\(feeds[indexPath.row].name!) \n • \(timer)s ago")
                
            }
            if timer > 59 && timer < 3600 {
                let minuters = timer / 60
               topLabel.text = "\(feeds[indexPath.row].name!) \n • \(minuters)mins ago"
                if minuters == 1 {
                    topLabel.text  = "\(feeds[indexPath.row].name!) \n • \(minuters)min ago"
                }
            }
            if timer > 59 && timer >= 3600 && timer < 86400 {
                let hours = timer / 3600
                topLabel.text = "\(feeds[indexPath.row].name!) \n • \(hours)hrs ago"
                if hours == 1 {
                    topLabel.text = "\(feeds[indexPath.row].name!) \n • \(hours)hr ago"
                }
            }
            if timer > 86400 {
                let days = timer / 86400
                topLabel.text = "\(feeds[indexPath.row].name!) \n • \(days)days ago"
                if days == 1 {
                    topLabel.text = "\(feeds[indexPath.row].name!) \n • \(days)day ago"
                }
            }
        }
        
       
        cell.imagerView.frame = CGRect(x: 5, y: 5, width: cell.frame.width - 10, height: cell.frame.height - 10)
       
        if small == true {
          cell.imagerView.backgroundColor = UIColor(red: 0, green: 0.6863, blue: 0.9569, alpha: 1.0)
             cell.imagerView.contentMode = .scaleAspectFill
            cell.imagerView.addBlurEffect()
            cell.imagerView.layer.cornerRadius = 10.0
            cell.imagerView.clipsToBounds = true
            cell.imagerView.addSubview(topLabel)
            if let unseen = feeds[indexPath.row].unseen {
                print(unseen)
                cell.imagerView.addSubview(miniView)
            } else {
              
                miniView.isHidden = true
                miniView.backgroundColor = .clear
                miniView.removeFromSuperview()
            }
            
        } else {
            cell.imagerView.backgroundColor = .black
            cell.imagerView.contentMode = .scaleAspectFit
         cell.imagerView.removeAllBlur()
         cell.imagerView.layer.cornerRadius = 0
        }

        if let imager = feeds[indexPath.row].photoUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            cell.imagerView.kf.indicatorType = .activity
            cell.imagerView.kf.setImage(with: restource, completionHandler: {
                (image, error, cacheType, imageUrl) in
                if let error = error {
                    print(error)
                    cell.imagerView.image = #imageLiteral(resourceName: "noViews")
                }
            })
            
        } else {
            cell.imagerView.image = nil
        }
        
        return cell
    }
 
    let stuffLabel = UILabel()
    var oncet = false
    @objc func openFeed () {
        if self.dontAllow == false {
            if self.oncet == false {
                if self.feeds.count != 0 {
      self.oncet = true
            self.buttonoProf.isHidden = true
                    self.labelTop.isHidden = true
                    self.labelGo.isHidden = true
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.small = false
            self.collectionerView.removeGestureRecognizer(self.gesturSwipeUp)
            self.collectionerView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 110)
            self.stuffLabel.text = self.feeds[0].name
            self.removerDot()
            self.collectionerView.isPagingEnabled = true
            self.collectionerView.reloadData()
          
            self.view.backgroundColor = .black
               self.collectionerView.addGestureRecognizer(self.swipeDown)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.collectionerView.backgroundColor = .black
            
        }, completion: {(_) -> Void in
            self.getTimeforFirst(seconds: self.feeds[0].timeStamp, index: 0)
           self.view.addSubview(self.stuffLabel)
             self.tablerView.isHidden = true
            if self.removes.contains(self.feeds[0].key) || self.feeds[0].key == "key" {
                
            } else {
                self.removes.append(self.feeds[0].key)
                self.scrolled = true
                if self.sendSeens.contains(self.feeds[0].uider) || self.feeds[0].uider == Auth.auth().currentUser?.uid {
                    
                } else {
                    self.sendSeens.append(self.feeds[0].uider)
                }
            }
            self.oncet = false
            if self.feeds[0].text != "none$" {
                self.view.addSubview(self.buttonShowDesc)
                self.descriptText = self.feeds[0].text
                self.collectionerView.addGestureRecognizer(self.swipeUpGest)
            }
            if let unseener = self.feeds[0].unseen {
                print(unseener)
                self.feeds[0].unseen = nil
            }
          self.addReaction(index: 0)
        })
        }
            }
        }
    }
    var swipeDown = UISwipeGestureRecognizer()

    
    @objc func swiperDown () {
         if oncet == false {
            self.oncet = true
            self.small = true
        self.desLabel.removeFromSuperview()
            self.buttonShowDesc.removeFromSuperview()
        self.collectionerView.reloadData()
          self.tablerView.isHidden = false
           self.removeReaction()
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                if self.view.frame.height == 812 {
                    self.collectionerView.frame = CGRect(x: 0, y: self.view.frame.height - 132, width: self.view.frame.width, height: self.view.frame.height - 110)
                } else {
                self.collectionerView.frame = CGRect(x: 0, y: self.view.frame.height - 122, width: self.view.frame.width, height: self.view.frame.height - 110)
                }
                self.collectionerView.isPagingEnabled = false
                self.view.backgroundColor = .white
                
                self.collectionerView.backgroundColor = .white
                self.collectionerView.removeGestureRecognizer(self.swipeDowngest)
                self.collectionerView.removeGestureRecognizer(self.swipeUpGest)
            }, completion: {(_) -> Void in
                if self.buttonCam.isHidden == true {
                    self.buttonCam.isHidden = false
                }
                if self.matchCount == 0 {
                    self.buttonoProf.isHidden = false
                    self.labelTop.isHidden = false
                    self.labelGo.isHidden = false
                   
                } else {
                    
                }
               self.stuffLabel.removeFromSuperview()
                self.collectionerView.addGestureRecognizer(self.gesturSwipeUp)
                self.collectionerView.removeGestureRecognizer(self.swipeDown)
               self.oncet = false
            })
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if small == true {
            
             if self.feeds.count != 0 {
            self.small = false
            self.oncet = false
                self.buttonoProf.isHidden = true
                self.labelTop.isHidden = true
                self.labelGo.isHidden = true
            
              UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
         
              
                    self.collectionerView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 110)
            self.collectionerView.removeGestureRecognizer(self.gesturSwipeUp)
            self.collectionerView.isPagingEnabled = true
            self.collectionerView.reloadData()
            self.removerDot()
             self.collectionerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.view.backgroundColor = .black
            self.collectionerView.addGestureRecognizer(self.swipeDown)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.collectionerView.backgroundColor = .black
              }, completion: {(_) -> Void in
                
                self.getTimeforFirst(seconds: self.feeds[indexPath.row].timeStamp, index: indexPath.row)
                self.view.addSubview(self.stuffLabel)
                 self.tablerView.isHidden = true
                if let unseener = self.feeds[indexPath.row].unseen {
                    print(unseener)
                    self.feeds[indexPath.row].unseen = nil
                }
                if self.removes.contains(self.feeds[indexPath.row].key) || self.feeds[indexPath.row].key == "key" {
                    
                } else {
                    self.removes.append(self.feeds[indexPath.row].key)
                    if self.sendSeens.contains(self.feeds[indexPath.row].uider) || self.feeds[indexPath.row].uider == Auth.auth().currentUser?.uid {
                        
                    } else {
                        self.sendSeens.append(self.feeds[indexPath.row].uider)
                    }
                    self.scrolled = true
                }
                if self.feeds[indexPath.row].text != "none$" {
                    self.view.addSubview(self.buttonShowDesc)
                    self.descriptText = self.feeds[0].text
                    self.collectionerView.addGestureRecognizer(self.swipeUpGest)
                }
                 self.addReaction(index: indexPath.row)
              })
    }
        }
    }
 
    
    func getTimeforFirst (seconds: Int, index: Int) {
        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
        let timer = timeStamp - seconds
        
        if timer <= 59 {
            stuffLabel.text = ("\(feeds[index].name!) \n • \(timer)s ago")
            
        }
        if timer > 59 && timer < 3600 {
            let minuters = timer / 60
            stuffLabel.text = "\(feeds[index].name!) \n • \(minuters)mins ago"
            if minuters == 1 {
                stuffLabel.text  = "\(feeds[index].name!) \n • \(minuters)min ago"
            }
        }
        if timer > 59 && timer >= 3600 && timer < 86400 {
            let hours = timer / 3600
            stuffLabel.text = "\(feeds[index].name!) \n • \(hours)hrs ago"
            if hours == 1 {
                stuffLabel.text = "\(feeds[index].name!) \n • \(hours)hr ago"
            }
        }
        if timer > 86400 {
            let days = timer / 86400
            stuffLabel.text = "\(feeds[index].name!) \n • \(days)days ago"
            if days == 1 {
                stuffLabel.text = "\(feeds[index].name!) \n • \(days)day ago"
            }
        }
    }
    
    
    // take photo
    
     let goer = sharer()
       let cameraButtony = UIButton()
    @objc func buttonCameraAction () {
        self.hide = true
        let cameraViewController = CameraViewController(allowsLibraryAccess: false) {  [weak self] image, asset in
            // Do something with your image here.

            if let imagel = image {
                self?.goer.delegate = self
                self?.goer.adddViews(image: imagel)
                self?.dismiss(animated: false, completion: {

            })

            } else {
                self?.dismiss(animated: true, completion: nil)
            }

        }
         DispatchQueue.main.async {

        self.present(cameraViewController, animated: true, completion: nil)
            if let keyWindow = UIApplication.shared.keyWindow {

                self.cameraButtony.frame = CGRect(x: 10, y: 6, width: 40, height: 40)
               self.cameraButtony.isHidden = false
                self.cameraButtony.setImage(#imageLiteral(resourceName: "albumo"), for: .normal)
                self.cameraButtony.addTarget(self, action: #selector(self.openLibrary), for: .touchUpInside)
                keyWindow.addSubview(self.cameraButtony)
            }
        }
    }
    
     let imagePicker = UIImagePickerController()
     @objc func openLibrary () {
        imagePicker.delegate = self
        self.dismiss(animated: false, completion: {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: false, completion: nil)
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.goer.delegate = self
         self.goer.adddViews(image: selectedImage)
       
        picker.dismiss(animated: true, completion: {
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func getFeed () {
        print("calling feed")
        if let uid = Auth.auth().currentUser?.uid {
            var reload = false
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("Feed").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
              
                if let feed = snapshot.value as? [String : AnyObject] {
                    self.tablerView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 222)
                    if self.view.frame.height == 812 {
                          self.tablerView.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 242)
                    }
                   
                    self.collectionerView.isHidden = false
                    for (_,one) in feed {
                     
                        if let fromUid = one["senderUid"] as? String, let fromName = one["senderName"] as? String, let timeSent = one["timeStamp"] as? Int, let unviewed = one["unseen"] as? String, let key = one["key"] as? String, let stringUrl = one["imageUrl"] as? String, let desc = one["text"] as? String {
                             let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                            if timeNow - timeSent < 345600 {
                                let aPost = Photo()
                                aPost.uider = fromUid
                                aPost.name = fromName
                                aPost.timeStamp = timeSent
                                aPost.unseen = unviewed
                                aPost.key = key
                                aPost.photoUrl = stringUrl
                                aPost.text = desc
                                 if self.feeds.contains( where: { $0.key == aPost.key }) {
                                    
                                 } else {
                                    self.feeds.append(aPost)
                                    if self.feeds.count != 0 {
                                        self.feeds.sort { $1.timeStamp < $0.timeStamp }
                                    }
                                    reload = true
                                }
                            } else {
                                ref.child("users").child(uid).child("Feed").child(key).removeValue()
                            }
                        }
                    }
                    if reload == true {
                          DispatchQueue.main.async {
                        self.collectionerView.reloadData()
                      print("collection reload")
                        }
                        reload = false
                        // if user swipes to reload
                        if self.dontAllow == true {
                            self.dontAllow = false
                            self.collectionerView.allowsSelection = true
                            self.loadcall = true
                        }
                    } else {
                        // if user swipes to reload
                        if self.dontAllow == true {
                            self.dontAllow = false
                            self.collectionerView.allowsSelection = true
                            self.loadcall = true
                        }
                        if self.feeds.count == 0 {
                            self.tablerView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 149)
                              self.collectionerView.isHidden = true
                        }
                    }
                } else {
                    if self.feeds.count == 0 {
                    self.tablerView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 149)
                    self.collectionerView.backgroundColor = .clear
                    self.collectionerView.isHidden = true
                    }
                }
            }, withCancel: nil)
        }
    }
   

    func xyz(url: String, time: Int, key: String, text: String) {
        if let authiD = Auth.auth().currentUser?.uid {
            if let authName = Auth.auth().currentUser?.displayName {
        let newPhoto = Photo()
        newPhoto.photoUrl = url
        newPhoto.timeStamp = time
        newPhoto.key = key
        newPhoto.text = text
        newPhoto.name = authName
        newPhoto.uider = authiD
        newPhoto.unseen = "unseen"
              if self.feeds.contains( where: { $0.key == newPhoto.key }) {
                
              } else {
                self.feeds.append(newPhoto)
                if self.feeds.count != 0 {
                   self.feeds.sort { $1.timeStamp < $0.timeStamp }
                 DispatchQueue.main.async {
                    self.collectionerView.isHidden = false
                    self.collectionerView.reloadData()
                }
                }
                }
            }
        }
    }
    
    var sendSeens = [String]()
    var removes = [String]()
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionerView {
             if small == false {
        self.scrolled = true
        var visibleRect = CGRect()
        visibleRect.origin = collectionerView.contentOffset
        visibleRect.size = collectionerView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX - 1, y: visibleRect.midY - 1)
        let visibli: NSIndexPath = collectionerView.indexPathForItem(at: visiblePoint)! as IndexPath as NSIndexPath
        print(visibli.row)
        self.getTimeforFirst(seconds: feeds[visibli.row].timeStamp, index: visibli.row)

                if let undeen = self.feeds[visibli.row].unseen {
                print(undeen)
                    self.feeds[visibli.row].unseen = nil
                }
        if removes.contains(feeds[visibli.row].key) || feeds[visibli.row].key == "key" {
            
        } else {
            removes.append(feeds[visibli.row].key)
            if let uid = Auth.auth().currentUser?.uid {
            if self.sendSeens.contains(feeds[visibli.row].uider) || feeds[visibli.row].uider == uid {
                
            } else {
                self.sendSeens.append(feeds[visibli.row].uider)
                print(self.sendSeens.count)
            }
        }
            }
            if let aDes = self.feeds[visibli.row].text {
                
                if self.feeds[visibli.row].text != "none$" {
                self.desLabel.text = self.feeds[visibli.row].text
                self.descriptText = aDes
                
                self.view.addSubview(self.buttonShowDesc)
                    if desOut == false {
                        self.collectionerView.addGestureRecognizer(self.swipeUpGest)
                    } else {
                        self.collectionerView.addGestureRecognizer(self.swipeDowngest)
                    }
                } else {
                    self.desLabel.removeFromSuperview()
                    self.buttonShowDesc.removeFromSuperview()
                    self.collectionerView.removeGestureRecognizer(self.swipeDowngest)
                    self.collectionerView.removeGestureRecognizer(self.swipeUpGest)
                }
              
            } else {
                self.desLabel.removeFromSuperview()
                self.buttonShowDesc.removeFromSuperview()
            }
                self.reactButton.tag = visibli.row
                if let liked = self.feeds[visibli.row].reacted {
                    print(liked)
                    self.reactButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
                } else {
                    self.reactButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                }
        }
    }
    }
    
    func removeOldImages () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("Posts").observeSingleEvent(of: .value, with: {(snapshot) in
                if let posters = snapshot.value as? [String : AnyObject] {
                    for (one,each) in posters {
                        if let postTime = each as? Int {
                            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                            if timeNow - postTime >= 345600 {
                                let pictureRef = Storage.storage().reference().child(uid).child("posts").child(one)
                                pictureRef.delete { error in
                                    if let error = error {
                                        print(error)
                                        ref.child("users").child(uid).child("Posts").child(one).removeValue()
                                    } else {
                                      ref.child("users").child(uid).child("Posts").child(one).removeValue()
                                    }
                                }
                                
                            }
                        }
                    }
                } else {
                    return
                }
            }, withCancel: nil)
        }
    }
    var dontAllow = false
    var loadcall = true
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if small == true {
        if scrollView == collectionerView {
            let offset:CGPoint = scrollView.contentOffset;
          
           
            let inset: UIEdgeInsets  = scrollView.contentInset
            let y: Float  = Float(offset.x - inset.left);
           
            let reload_distance: Float  = -75; //distance for which you want to load more
            if(y < reload_distance) {
                // write your code getting the more data
                print("yeeeee")
                if self.loadcall == true {
                    self.loadcall = false
                    self.collectionerView.allowsSelection = false
                    self.dontAllow = true
                    self.getFeed()
                }
            }

        }
        }
    }
    
    
   
    let swipeDowngest = UISwipeGestureRecognizer()
    let swipeUpGest = UISwipeGestureRecognizer()
    var desOut = false
    var descriptText: String?
    let desLabel = UILabel()
    @objc func showDescript () {
        if self.desOut == false {
        desLabel.layer.cornerRadius = 12.0
        desLabel.clipsToBounds = true
        desLabel.frame = CGRect(x: 10, y: self.view.frame.height, width: self.view.frame.width - 20, height: 0)
        desLabel.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        desLabel.font = UIFont(name: "Futura", size: 16)
        desLabel.textColor = .white
        desLabel.textAlignment = .center
        self.view.addSubview(self.desLabel)
        self.buttonCam.isHidden = true
        desLabel.numberOfLines = 3
        if let descript = self.descriptText {
            self.desLabel.text = descript
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            
           self.desLabel.frame = CGRect(x: 10, y: self.view.frame.height - 160, width: self.view.frame.width - 20, height: 100)
        }, completion: {(_) -> Void in
            self.desOut = true
            self.buttonShowDesc.setImage(#imageLiteral(resourceName: "hideDown"), for: .normal)
            self.collectionerView.removeGestureRecognizer(self.swipeUpGest)
            self.collectionerView.addGestureRecognizer(self.swipeDowngest)
        })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                
                self.desLabel.frame = CGRect(x: 10, y: self.view.frame.height, width: self.view.frame.width - 20, height: 100)
            }, completion: {(_) -> Void in
                self.buttonCam.isHidden = false
                self.desOut = false
                self.buttonShowDesc.setImage(#imageLiteral(resourceName: "showUp"), for: .normal)
                self.collectionerView.removeGestureRecognizer(self.swipeDowngest)
                self.collectionerView.addGestureRecognizer(self.swipeUpGest)
            })
        }
    }
    
    var reloaders = [String]()
    func getChats (uid: String, interl: Int) {
        let ref = Database.database().reference()
        if let myUid = Auth.auth().currentUser?.uid {
            ref.child("users").child(myUid).child("chats").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                self.reloaders.append("one")
               let aChat = snapshot.value as? [String : AnyObject]
                if let lastMessage = aChat?["lastMessage"] as? Int {
          
                    if let index = self.likers.index(where: {$0.uider == uid}) {
                            if let unseen = aChat?["unseen"] as? String {
                                print(unseen)
                                self.likers[index].isUnseen = unseen
                            } else {
                               
                            }
                            
                            self.likers[index].lastMessage = lastMessage
                            if self.likers.count > 0 {
                                self.likers.sort { $1.lastMessage! < $0.lastMessage! }
                                
                            }

                        }

                }
                if self.reloaders.count == self.matchCount {
                self.tablerView.reloadData()
                self.liveChats()
                self.feedPhotos()
                    print("reloaded whole tblver chats")
                }
                
            }, withCancel: nil)
        }
    }
    
    
    func liveChats () {
        print("live chats ran")
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("chats").observe(.value, with: {(snapshot) in
                if let chatters = snapshot.value as? [String : AnyObject] {
                    
                    print("live chats evoked")
                    var shouldReloadAll = false
                    var shouldReloadOne = false
                    var reloadedOnes = [Int]()
                     var originalOne = self.likers
                    for (_, each) in chatters {
                        if self.likers.count > 0 {
                       
                        if let uideriy = each["theirId"] as? String, let lastMessage = each["lastMessage"] as? Int {
                         
                             if let indext = self.likers.index( where: { $0.uider == uideriy }) {
                                if self.likers[indext].lastMessage != nil {
                                    if self.likers[indext].lastMessage != lastMessage {
                                        
                                        if let unsern = each["unseen"] as? String {
                                            self.likers[indext].isUnseen = unsern
                                            originalOne[indext].isUnseen = unsern
                                        } else {
                                            print("nilo")
                                        }
                                        self.likers[indext].lastMessage = lastMessage
                                        originalOne[indext].lastMessage = lastMessage
                                        if self.likers.count != 0 {
                                           
                                                if reloadedOnes.contains(indext) {
                                                    
                                                } else {
                                                    reloadedOnes.append(indext)
                                                }
                                        }
                                        
                                    } else {
                                        if let unseenps = self.likers[indext].isUnseen {
                                            if let unsern = each["unseen"] as? String {
                                                if unseenps != unsern {
                                                    self.likers[indext].isUnseen = unsern
                                                    originalOne[indext].isUnseen = unsern
                                                    if self.likers.count != 0 {
                                                    
                                                        if reloadedOnes.contains(indext) {
                                                            
                                                        } else {
                                                        reloadedOnes.append(indext)
                                                        
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                }
                             } else {
                            
                            }
                        }
                    }
                    var sorted = false
                    if self.likers.count != 0 {
                         self.likers.sort { $1.lastMessage! < $0.lastMessage! }
                        sorted = true
                    }
                    if sorted == true {
                    if originalOne == self.likers {
                        shouldReloadOne = true
                        shouldReloadAll = false
                    } else {
                        shouldReloadOne = false
                        shouldReloadAll = true
                        originalOne.removeAll()
                    }
                    if shouldReloadAll == true {
                         DispatchQueue.main.async {
                        self.tablerView.reloadData()
                            print("reloaded all live")
                        }
                        shouldReloadAll = false
                    } else if shouldReloadOne == true {
                        if reloadedOnes.count != 0 {
                            for each in reloadedOnes {
                            let indexPather = IndexPath(row: each, section: 0)
                         DispatchQueue.main.async {
                            self.tablerView.reloadRows(at: [indexPather], with: .automatic)
                            print("reloading rows live")
                            }
                        }
                            reloadedOnes.removeAll()
                            originalOne.removeAll()
                            shouldReloadOne = false
                        }
                    }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func feedPhotos () {
        if self.feeds.count != 0 {
            if self.likers.count != 0 {
                for i in 0..<self.likers.count {
                    if let indext = self.feeds.index( where: { $0.uider == self.likers[i].uider }) {
                        self.likers[i].hasFeed = indext
                    let indexpatt = IndexPath(row: i, section: 0)
                        self.tablerView.reloadRows(at: [indexpatt], with: .automatic)
                    }
                        
                    }
                }
            }
        }
    
    
   var dontremove = false
    var scrolled = false
    override func viewWillDisappear(_ animated: Bool) {
        self.liveFunc = true
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if dontremove == false {
            ref.child("users").child(uid).child("inChat").removeValue()
            }
            ref.child("users").child(uid).child("chats").removeAllObservers()
            print("removed live")
        }
        
        
        if scrolled == true {
            scrolled = false
            if self.removes.count != 0 {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    for each in removes {
                        ref.child("users").child(uid).child("Feed").child(each).removeValue()
                    }
                    if self.sendSeens.count != 0 {
                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                        let feedy = [uid : timeStamp]
                        for each in self.sendSeens {
                            ref.child("users").child(each).child("dailyViews").updateChildValues(feedy)
                        }
                    }
                }
            }
        }
        
        if dot.isHidden != true {
            removerDot()
        }
        
        
    }
    
    let reactButton = UIButton()
    func addReaction(index: Int) {
         reactButton.frame = CGRect(x: self.view.frame.width - 48, y: 24, width: 32, height: 32)
        if self.view.frame.height == 812 {
             reactButton.frame = CGRect(x: self.view.frame.width - 48, y: 32, width: 32, height: 32)
        }
        if let reactedAlready = self.feeds[index].reacted {
            print(reactedAlready)
            reactButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
        } else {
    reactButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        self.reactButton.tag = index
        self.reactButton.addTarget(self, action: #selector(self.reactAct(sender:)), for: .touchUpInside)
    self.view.addSubview(reactButton)
    }
    
    func removeReaction () {
        self.reactButton.removeFromSuperview()
    }
  
    @objc func reactAct (sender: UIButton) {
  reactButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
 let indexo = reactButton.tag
        if self.feeds[indexo].reacted == nil {
       self.feeds[indexo].reacted = "like"
            if let ids = self.feeds[indexo].uider {
                if let urler = self.feeds[indexo].photoUrl {
                    self.sendNotifFeed(uid: ids, url: urler)
                }
            }
        }
    }
    
    var alreadySents = [String]()
    func sendNotifFeed (uid: String, url: String) {
        if uid != Auth.auth().currentUser?.uid {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("userKey").observeSingleEvent(of: .value, with: { (snapshot)
            in
            if let usersKey = snapshot.value as? String {
                if self.alreadySents.contains(uid) {
                    
                } else {
                    if let myName = Auth.auth().currentUser?.displayName {
                    let messgae = "\(myName) just liked your post"
                    let data = [
                        "contents": ["en": "\(messgae)"],
                        "include_player_ids":["\(usersKey)"],
                        "ios_badgeType": "Increase",
                        "ios_badgeCount": 1
                        ] as [String : Any]
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                        OneSignal.postNotification(data)
                    }
                        self.alreadySents.append(uid)
                    }
                }
                        if let myId = Auth.auth().currentUser?.uid {
                        if let myName = Auth.auth().currentUser?.displayName {
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let content = "\(myName) just liked your photo"
                            let ref = Database.database().reference()
                            
                            let key = ref.child("users").child(uid).child("Notifications").childByAutoId().key
                            
                            let feed = ["timeStamp" : timeStamp, "key" : key, "theirName" : myName, "shareId" : myId, "theirUrl" : url, "content" : content, "unseen" : "yes", "theirUsername" : "none"] as [String : Any]
                            
                            let final = [key : feed]
                            
                            ref.child("users").child(uid).child("Notifications").updateChildValues(final)
                            return
                            
                            }
                        }
                
            }
            })
        }
    }
    
    
    
}




extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: -5, width: self.frame.width , height: self.frame.height)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func removeAllBlur () {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}


