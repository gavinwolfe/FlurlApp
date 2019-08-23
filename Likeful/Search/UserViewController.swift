//
//  UserViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/3/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
import Kingfisher

protocol userMatch {
    func userDidMatch(name : String, image: UIImage, url: String, uid: String)
    func findSomeUsers(uid: String, connection: String)
    func sendOffNotification(uid: String, token: String)
  
}

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewer: UICollectionView!
    var delegate: userMatch?
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var suggestedUsersButton: UIButton!
    var myMatches: [String]?
    // unseen is just the array of users who are not matched, but one or both users have rated one another
    // ex if two users have different ratings, they dont match, but instead show up in each others unseen
    
   var photos = [Photo]()
    
    var addScoresOnce = false
    var tokenKey: String?
    var imagel: UIImage?
    var namer: String?
    var userName: String?
    var id: String?
    var theirUrl: String?
    var theirIndex: Int?
    var yourInt: Int?
    var showDirections: Bool?
    var originalVal: Int?
    var privateAccnt: String?
    
    var selectedIndex: Int?
    
    var stuff = ["Interested", "Friends", "Hide"]
    
    var activityIndc = UIActivityIndicatorView()
    var areMatched : String?
       var showDirectos = false
    
    
    @IBOutlet weak var wayBackView: UIView!
    @IBOutlet weak var scorerLabel: UILabel!
    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var seePhotosButton: UIButton!
    @IBOutlet weak var descriptoLabel: UILabel!
    @IBOutlet weak var tablerView: UITableView!
    @IBOutlet weak var furtherBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.activityIndc.backgroundColor = UIColor(white: 1, alpha: 0.6)
        self.activityIndc.color = .black
        self.activityIndc.startAnimating()
        self.view.addSubview(self.activityIndc)
        
        if let indexfler = yourInt {
            selectedIndex = indexfler
            self.theirIndex = indexfler
            
            self.activityIndc.stopAnimating()
            self.originalVal = indexfler
            self.tablerView.reloadData()
        } else {
           
            checkk()
            checkIfYourUnseen()
           
            
        }
        tablerView.delegate = self
        tablerView.dataSource = self
        if let namer = namer {
            labelName.text = namer
            let fullName = namer
            var components = fullName.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
               self.navigationItem.title = firstName
            }
        }
        if let usernamer = userName {
            labelUsername.text = usernamer
          
        }
        if let imageler = imagel {
            imagerView.image = imageler
        }
        if let areMatcher = areMatched {
            print(areMatcher)
            self.furtherBackView.backgroundColor = UIColor(red: 0.0627, green: 0.8667, blue: 0.0078, alpha: 1.0)
        }
      
        collectionViewer.delegate = self
        collectionViewer.dataSource = self
        if self.showDirections == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("showDirections").removeValue()
                showDirection()
            }
            showDirectos = true
            
        }
    
       
        viewProf.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        descriptoLabel.frame = CGRect(x: 16, y: 146, width: self.view.frame.width - 32, height: 51)
        self.descriptoLabel.isHidden = true
        self.scorerLabel.frame = CGRect(x: self.view.frame.width - 200, y: 68, width: 190, height: 20)
        self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 3.3, width: self.view.frame.width - 12, height: 360)
        self.lineView.frame = CGRect(x: 0, y: 172, width: self.view.frame.width, height: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "morey.png"), style: .plain, target: self, action: #selector(showMore))
        self.navigationController?.navigationBar.tintColor = .black
        imagerView.frame = CGRect(x: 12, y: 76, width: 68, height: 68)
        backView.frame = CGRect(x: 10, y: 74, width: 72, height: 72)
        furtherBackView.frame = CGRect(x: 8, y: 72, width: 76, height: 76)
        furtherBackView.layer.cornerRadius = 38
        furtherBackView.clipsToBounds = true
        imagerView.layer.cornerRadius = 34
        imagerView.clipsToBounds = true
        backView.layer.cornerRadius = 36
        backView.clipsToBounds = true
        labelUsername.frame = CGRect(x: 97, y: 110, width: self.view.frame.width - 100, height: 20)
        labelName.frame = CGRect(x: 94, y: 80, width: self.view.frame.width - 100, height: 30)
        self.activityIndc.frame = tablerView.frame
        self.seePhotosButton.frame = furtherBackView.frame
        
        self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 172)
        self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 168, width: self.view.frame.width - 14, height: 105)
        //(310.0, 82.0, 49.0, 40.0)
        self.suggestedUsersButton.frame = CGRect(x: self.view.frame.width - 60, y: 95.0, width: 49, height: 49)
        
        // iphone 5 / 5c / se
        if self.view.frame.width == 320 {
            self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.9, width: self.view.frame.width - 12, height: 320)
            descriptoLabel.frame = CGRect(x: 6, y: 146, width: self.view.frame.width - 12, height: 51)
            self.descriptoLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 168, width: self.view.frame.width - 14, height: 105)
        }
        if self.view.frame.width == 414 {
            
            self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 3.1, width: self.view.frame.width - 12, height: 400)
            self.lineView.frame = CGRect(x: 0, y: 182, width: self.view.frame.width, height: 1)
            descriptoLabel.frame = CGRect(x: 16, y: 156, width: self.view.frame.width - 32, height: 51)
            self.descriptoLabel.font = UIFont(name: "Avenir-Medium", size: 14)
            self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 182)
        }
        
        if self.view.frame.height == 812 {
         self.layoutIphonex()
        }
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            
            self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.7, width: self.view.frame.width - 12, height: 250)
             self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 110, width: self.view.frame.width - 14, height: 55)
            
        } else {
            
        }
      
        self.swipeGest.direction = .down
        self.swipeGest.addTarget(self, action: #selector(self.swipeDown))
        
        grabMatched()
        checkIfUserIsBlocked()
        grabDescript()
        grabPhotos()
        grabScore()
        grabInstagramAccount()
        
        if privateAccnt != nil {
            if  areMatched != nil {

            } else {
                self.privaterCheck()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func grabScore () {
        let ref = Database.database().reference()
        if let theirId = self.id {
        ref.child("users").child(theirId).child("score").observeSingleEvent(of: .value, with: {(snaple) in
            if let scorey = snaple.value as? Int {
                self.scorerLabel.text = "Score • \(scorey)"
            } else {
                self.scorerLabel.text = "Score • \(5)"
            }
        })
        }
    }
    
   
    
    
    func privaterCheck () {
        let ref = Database.database().reference()
        if let id = self.id {
            if let uid = Auth.auth().currentUser?.uid {
                ref.child("users").child(uid).child("unseen").child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists() {
                        
                    } else {
                        self.tablerView.isHidden = true
                        let locker = UIImageView()
                        locker.frame = CGRect(x: self.view.frame.width / 2.5, y: self.view.frame.height / 2, width: 60, height: 60)
                        self.collectionViewer.isHidden = true
                        locker.image = #imageLiteral(resourceName: "locker")
                        self.view.addSubview(locker)
                        let labelWhy = UILabel()
                        labelWhy.frame = CGRect(x: 15, y: self.view.frame.height / 3, width: self.view.frame.width - 30, height: 70)
                        labelWhy.textAlignment = .center
                        labelWhy.numberOfLines = 3
                        labelWhy.font = UIFont(name: "Avenir", size: 16)
                        labelWhy.text = "This user's account is private, meaning they must select an option on your account first, before you can interact with their account."
                        self.view.addSubview(labelWhy)
                    }
                    
                }, withCancel: nil)
            }
        }
    }
    
    var matches = [String]()
    func grabMatched () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            
            
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let values = snapshot.value as? [String : AnyObject] {
                    for (one,_) in values {
                        if self.matches.contains(one) {
                            
                        } else {
                            self.matches.append(one)
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
  
    var blocked = false
    func checkIfUserIsBlocked () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let id = self.id {
                ref.child("users").child(uid).child("blocked").child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists() {
                        self.blocked = true
                    } else {
                        print("not blocked")
                    }
                })
            }
        }
    }
    
    
    func layoutIphonex () {
        imagerView.frame = CGRect(x: 16, y: 107, width: 64, height: 64)
        backView.frame = CGRect(x: 14, y: 105, width: 68, height: 68)
        furtherBackView.frame = CGRect(x: 12, y: 103, width: 72, height: 72)
        labelUsername.frame = CGRect(x: 97, y: 140, width: self.view.frame.width - 100, height: 20)
        labelName.frame = CGRect(x: 94, y: 110, width: self.view.frame.width - 100, height: 30)
        self.seePhotosButton.frame = furtherBackView.frame
        self.suggestedUsersButton.frame = CGRect(x: self.view.frame.width - 60, y: 128.0, width: 49, height: 49)
        descriptoLabel.frame = CGRect(x: 16, y: 178, width: self.view.frame.width - 32, height: 51)
        self.lineView.frame = CGRect(x: 0, y: 212, width: self.view.frame.width - 8, height: 1)
        self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 3.1, width: self.view.frame.width - 12, height: 400)
         self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 212)
        self.scorerLabel.frame = CGRect(x: self.view.frame.width - 200, y: 98, width: 190, height: 20)
        self.descriptoLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 195, width: self.view.frame.width - 14, height: 105)
        
    }
    
    @objc func showMore () {
        
       
        var stringle: String?
        
        if self.blocked == true {
            stringle = "Unblock"
        } else {
            stringle = "Block"
        }
        
        let popup = UIAlertController(title: "Actions", message: "Select what you would like to do", preferredStyle: .actionSheet)
     
        let actionOne = UIAlertAction(title: "Message", style: .default, handler: { (alert : UIAlertAction) -> Void in
            print("message user")
           let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chosenChat") as! UINavigationController
            let des = vc.viewControllers[0] as! ChosenChatViewController
            if let theirNamer = self.namer {
                if let theirId = self.id {
                des.theirUid = theirId
                }
               
                des.theirName = theirNamer
            }
            //check if im blocked before messaging
            if let theirId = self.id {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    ref.child("users").child(theirId).child("blocked").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                        
                        if snapshot.exists() {
                            
                        } else {
                     DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                     
                    })
                }
            }
                
        })
        
        var actionTwo = UIAlertAction()
        if let stringler = stringle {
          actionTwo = UIAlertAction(title: stringler, style: .default, handler: { (alert : UIAlertAction) -> Void in
         
            
            if self.blocked == true {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    if let id = self.id {
                        ref.child("users").child(uid).child("blocked").child(id).removeValue()
                        self.blocked = false
                    }
                }
                print("unblock")
            } else {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    if let id = self.id {
                        let feed = [id : id]
                        ref.child("users").child(uid).child("blocked").updateChildValues(feed)
                        self.blocked = true
                    }
                }
                print("block")
            }
         
        })
        }
   
        let actionThree = UIAlertAction(title: "Report for false age", style: .default, handler: { (alert : UIAlertAction) -> Void in
            let ref = Database.database().reference()
            if let theirId = self.id {
            let feedr = [theirId : theirId]
            ref.child("reportedAge").updateChildValues(feedr)
            }
        })
        
       
        let actionFour = UIAlertAction(title: "Share this user", style: .default, handler: { (alert : UIAlertAction) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shareUser") as! UINavigationController
           let dest = vc.viewControllers[0] as! ShareUserViewController
            if let theirId = self.id {
                dest.theirUid = theirId
            }
            if let theirUrl = self.theirUrl {
                dest.theUrl = theirUrl
            } else {
                dest.theUrl = "none"
            }
            if let namert = self.namer {
                dest.theirName = namert
            }
            if let usernmert = self.userName {
                dest.theirUsername = usernmert
            }
            
             DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
            
        })
        let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
      
      
       actionThree.setValue(UIColor.red, forKey: "titleTextColor")
         actionTwo.setValue(UIColor.red, forKey: "titleTextColor")
        if let werematched = self.areMatched {
            print(werematched)
        popup.addAction(actionOne)
        }
        popup.addAction(actionFour)
        popup.addAction(actionTwo)
        popup.addAction(actionThree)
        popup.addAction(canceler)
        self.present(popup, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            return 55
        }
        if self.view.frame.width == 320 {
            return 70
        }
        if self.view.frame.width == 414 || self.view.frame.height == 812 {
            return 100
        }
       
        return 92
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! SelectedUserTableViewCell
         cell.imagerView.image = nil
        cell.imagerView.backgroundColor = .clear
        cell.mainLabel.layer.cornerRadius = 35.0
        if self.view.frame.width == 320 {
             cell.mainLabel.layer.cornerRadius = 30.0
        }
        cell.mainLabel.numberOfLines = 4
        if indexPath.row == 0 {
           cell.mainLabel.text = "Interested"
        }
        if indexPath.row == 1 {
           
            cell.mainLabel.text = "Friends"
        }
        if indexPath.row == 2 {
            cell.mainLabel.textColor = .darkGray
            cell.mainLabel.text = "Hide"
        }
       
        cell.mainLabel.clipsToBounds = true
       
        cell.mainLabel.textColor = .black
        cell.mainLabel.backgroundColor = UIColor(red: 0.9294, green: 0.9373, blue: 0.949, alpha: 1.0)
        if let selectedIndex = selectedIndex {
            if selectedIndex == 0 {
                if indexPath.row == 0 {
                    cell.mainLabel.backgroundColor = UIColor(red: 0, green: 0.6235, blue: 0.9882, alpha: 1.0)
                        //UIColor(red: 0, green: 0.5843, blue: 0.898, alpha: 1.0)
                    cell.mainLabel.textColor = .white
                
                }
            }
            if selectedIndex == 1 {
                if indexPath.row == 1 {
                    cell.mainLabel.backgroundColor = UIColor(red: 0, green: 0.5843, blue: 0.898, alpha: 1.0)
                    cell.mainLabel.textColor = .white
                   
                }
            }
            if selectedIndex == 2 {
                if indexPath.row == 2 {
                cell.mainLabel.backgroundColor = UIColor(red: 0.7569, green: 0.7412, blue: 0.7333, alpha: 1.0)
                cell.mainLabel.textColor = .white
                }
            }
            
           
            
        }
           
        cell.mainLabel.frame = CGRect(x: 6, y: 10, width: cell.frame.width - 12, height: cell.frame.height - 20)
        if ( UIDevice.current.model.range(of: "iPad") != nil){
              cell.mainLabel.frame = CGRect(x: 6, y: 5, width: cell.frame.width - 12, height: cell.frame.height - 10)
        }
        if self.view.frame.width == 320 {
            cell.mainLabel.frame = CGRect(x: 6, y: 4, width: cell.frame.width - 12, height: cell.frame.height - 8)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        changedValue = true
        if let orginal = originalVal {
            if orginal == indexPath.row {
                changedValue = false
            } else {
                changedValue = true
            }
        }
        
        tablerView.reloadData()
    }
   
    //boom here is the exit function
    
    override func viewWillDisappear(_ animated: Bool) {
    
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = self.id {
                if let selectedIndex = selectedIndex {
                    if changedValue == true {
                        self.changedValue = false
                        let ref = Database.database().reference()
                        if let theirVal = self.theirIndex {
                            if selectedIndex != theirVal {
                                regularUpdate(valur: theirVal)
                            }
                        } else {
                            ref.child("users").child(uid).child("unseen").child(theirId).observeSingleEvent(of: .value, with: {(snapshot) in
                                if let valuer = snapshot.value as? Int {
                                    
                                    if selectedIndex == valuer && selectedIndex != 2 {
                                        // new match
                                        if valuer != 2 {
                                        self.newMatch(valur: valuer)
                                        }
                                    } else {
                                        // close
                                        self.regularUpdate(valur: valuer)
                                    }
                                } else {
                                    // they havent selected anything on you at all, ever
                                    self.regularUpdate(valur: 3)
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }

  
    var changedValue = false
 
    func checkk () {
        if let uid = Auth.auth().currentUser?.uid {
        let ref = Database.database().reference()
        if let theirId = id {
            ref.child("users").child(theirId).child("matches").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                if let valueInt = snapshot.value as? Int {
                  
                            self.originalVal = valueInt
                            self.theirIndex = valueInt
                            self.selectedIndex = valueInt
                            self.activityIndc.stopAnimating()
                            self.tablerView.reloadData()
                  
                } else {
                      self.activityIndc.stopAnimating()
                }
                
                
                
            })
        }
        }
    }
    
  
    func checkIfYourUnseen () {
        if let theirId = id {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(theirId).child("unseen").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let valueInt = snapshot.value as? Int {
                       
                                self.selectedIndex = valueInt
                                self.originalVal = valueInt
                                self.tablerView.reloadData()
                        
                               self.activityIndc.stopAnimating()
                        
                    } else {
                          self.activityIndc.stopAnimating()
                    }
                })
            }
        }
    }
 
    
    
    func grabDescript () {
        if let uid = id {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("description").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                        self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 3, width: self.view.frame.width - 12, height: 377)
                        self.lineView.frame = CGRect(x: 0, y: 205, width: self.view.frame.width, height: 1)
                      self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 205)
                            if self.view.frame.width == 414 {
                                
                                self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.9, width: self.view.frame.width - 12, height: 400)
                                self.lineView.frame = CGRect(x: 0, y: 220, width: self.view.frame.width, height: 1)
                                self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220)
                               
                            }
                        if self.view.frame.width == 320 {
                             self.lineView.frame = CGRect(x: 0, y: 195, width: self.view.frame.width, height: 1)
                           self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.92, width: self.view.frame.width - 12, height: 377)
                            self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 195)
                        }
                            if self.view.frame.height == 812 {
                                self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.75, width: self.view.frame.width - 12, height: 400)
                                self.lineView.frame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: 1)
                                self.wayBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250)
                            }
                        if ( UIDevice.current.model.range(of: "iPad") != nil){
                          
                            self.tablerView.frame = CGRect(x: 6, y: self.view.frame.height / 2.35, width: self.view.frame.width - 12, height: 250)
                          
                        } else {
                           
                        }
                        
                    }, completion: {
                        (value: Bool) in
                        self.descriptoLabel.isHidden = false
                    })
                    self.descriptoLabel.text = snapshot.value as? String
                } else {
                    print("no description")
                }
            })
        }
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory warning")
         DispatchQueue.main.async {
        self.navigationController?.popToRootViewController(animated: true)
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "segueSuggested" {
            let dester = segue.destination as! SuggestedUsersViewController
            dester.theirId = id
            if changedValue == true {
                let ref = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    if let theirId = self.id {
                        if let namer = self.namer {
                        if self.theirIndex == nil {
                ref.child("users").child(uid).child("unseen").child(theirId).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let valuer = snapshot.value as? Int {
                        
                        if self.selectedIndex == valuer && self.selectedIndex != 2 {
                           
                            dester.userMatch(name: namer)
                            
                        }
                        }
                        })
                    }
                    }
                    }
                }
            }
        }
    }
    
    func showDirection() {
        let viewMain = UIView()
        viewMain.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)

        self.labelt.isHidden = true
        self.imagert.isHidden = true
        
        viewMain.layer.cornerRadius = 10.0
        viewMain.clipsToBounds = true
        let labelOn = UILabel()
        labelOn.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        labelOn.numberOfLines = 0
        labelOn.text = "Select an option above, and if they select the same of you, you connect. They cannot see if or what you selected, unless you both connect."
        labelOn.textAlignment = .center
        labelOn.font = UIFont(name: "Avenir-Heavy", size: 20)
        labelOn.textColor = .white
        viewMain.addSubview(labelOn)
        if self.view.frame.width == 320 {
             labelOn.font = UIFont(name: "Avenir-Heavy", size: 18)
        }
      
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            viewMain.frame = CGRect(x: 8, y: self.view.frame.height - 200, width: self.view.frame.width - 16, height: 135)

              labelOn.frame = CGRect(x: 5, y: 6, width: viewMain.frame.width - 10, height: viewMain.frame.height - 12)
         
            if self.view.frame.height == 812 {
                viewMain.frame = CGRect(x: 8, y: self.view.frame.height - 230, width: self.view.frame.width - 16, height: 135)
            }
            
            
            
            
        }, completion: nil)
        
        viewMain.backgroundColor = UIColor(red: 0, green: 0.5098, blue: 0.9882, alpha: 1.0)
            //UIColor(red: 0, green: 0.4275, blue: 0.6, alpha: 1.0)
        self.view.addSubview(viewMain)
        let when = DispatchTime.now() + 12
        DispatchQueue.main.asyncAfter(deadline: when){
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                  viewMain.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                       labelOn.frame = CGRect(x: 10, y: self.view.frame.height, width: self.view.frame.width - 20, height: 0)
                    
                
                self.labelt.isHidden = false
                self.imagert.isHidden = false
            }, completion: nil)
        }
    }
    let labelt = UILabel()
     let imagert = UIButton()
    func grabPhotos () {
        if let uid = self.id {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("profilePhotos").observeSingleEvent(of: .value, with: {(snapshot) in
                if let theirPhotos = snapshot.value as? [String : AnyObject] {
            
                    for (_,one) in theirPhotos {
                        let newPhoto = Photo()
                        newPhoto.photoUrl = one as? String
                        self.photos.append(newPhoto)
                    }
                    
                    self.collectionViewer.reloadData()
                } else {
                    
                    
                                    self.labelt.frame = CGRect(x: 15, y: self.view.frame.height - 172, width: self.view.frame.width - 30, height: 80)
                                    self.labelt.font = UIFont(name: "Avenir-Medium", size: 18)
                                    self.labelt.textAlignment = .center
                                    self.labelt.numberOfLines = 3
                                    self.labelt.text = "This user has no public photos. \n Connect so you can chat and view \n their posts."
                                    self.labelt.textColor = .black
                    
                                    self.imagert.frame = CGRect(x: self.view.frame.width / 2.35, y: self.view.frame.height - 105, width: 55, height: 55)
                                    self.imagert.setImage(#imageLiteral(resourceName: "empty"), for: .normal)
                    
                    if self.view.frame.height == 812 {
                         self.imagert.frame = CGRect(x: self.view.frame.width / 2.2, y: self.view.frame.height - 125, width: 35, height: 35)
                         self.labelt.frame = CGRect(x: 15, y: self.view.frame.height - 165, width: self.view.frame.width - 30, height: 40)
                    }
                      if ( UIDevice.current.model.range(of: "iPad") != nil){
                        self.labelt.frame = CGRect(x: 15, y: self.view.frame.height - 120, width: self.view.frame.width - 30, height: 80)
                         self.labelt.font = UIFont(name: "Avenir-Medium", size: 16)
                        self.imagert.isHidden = true
                    }
                                    self.view.addSubview(self.imagert)
                                    self.view.addSubview(self.labelt)
                }
            }, withCancel: nil)
        }
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celll = collectionViewer.dequeueReusableCell(withReuseIdentifier: "suggestedCollection", for: indexPath) as! SuggestedOnUserCollectionViewCell
          celll.imagerView.frame = CGRect(x: 5, y: 5, width: celll.frame.width - 10 , height: celll.frame.height - 10)
   
        celll.imagerView.layer.cornerRadius = 16.0
        celll.imagerView.clipsToBounds = true
        if let imager = photos[indexPath.row].photoUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            celll.imagerView.kf.indicatorType = .activity
            celll.imagerView.kf.setImage(with: restource, completionHandler: {
                (image, error, cacheType, imageUrl) in
                if let error = error {
                    print(error)
                   
                }
            })

            
        } else {
            
            celll.imagerView.image = #imageLiteral(resourceName: "profiler")
        }
         if ( UIDevice.current.model.range(of: "iPad") != nil){
            
        }
        if small == true {
            celll.imagerView.contentMode = .scaleAspectFill
        } else {
            celll.imagerView.contentMode = .scaleAspectFit
        }
        return celll
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if small == true {
            if ( UIDevice.current.model.range(of: "iPad") != nil){
                return CGSize(width: 55, height: 55)
            }
         return CGSize(width: 105, height: 105)
        }
         return CGSize(width: collectionViewer.frame.width, height: collectionViewer.frame.height)
    }
    
  var small = true
    var swipeGest = UISwipeGestureRecognizer()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
           
            
           self.small = false
           
            self.collectionViewer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
          self.scorerLabel.isHidden = true
            self.collectionViewer.isPagingEnabled = true
            self.collectionViewer.reloadData()
        self.wayBackView.backgroundColor = .black
            self.collectionViewer.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
         
            self.collectionViewer.addGestureRecognizer(self.swipeGest)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.collectionViewer.backgroundColor = .black
        }, completion: {(_) -> Void in
            self.addScores()
        })
       
    }
    
    @objc func swipeDown () {
        self.small = true
        self.collectionViewer.reloadData()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            if self.view.frame.height == 812 {
                self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 188, width: self.view.frame.width - 14, height: 105)
            } else {
                if self.view.frame.width == 320 {
                     self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 168, width: self.view.frame.width - 14, height: 105)
                } else {
             self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 168, width: self.view.frame.width - 14, height: 105)
                }
            }
             if ( UIDevice.current.model.range(of: "iPad") != nil){
            self.collectionViewer.frame = CGRect(x: 7, y: self.view.frame.height - 110, width: self.view.frame.width - 14, height: 55)
            }
            self.wayBackView.backgroundColor = .white
           self.scorerLabel.isHidden = false
            self.collectionViewer.isPagingEnabled = false
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
           
            self.collectionViewer.backgroundColor = .clear
            
        }, completion: {(_) -> Void in
            
        })
    }
    
   
    let viewProf = UIView()
    var swipeDis = UISwipeGestureRecognizer()
    @IBAction func seePhotosAct(_ sender: Any) {
         self.viewProf.isHidden = false
        self.viewProf.backgroundColor = .black
        let imageriView = UIImageView()
        imageriView.frame = CGRect(x: 37.5, y: self.view.frame.height / 3.5, width: self.view.frame.width - 75, height: 300)
        if self.view.frame.width == 320 {
             imageriView.frame = CGRect(x: 10, y: self.view.frame.height / 3.5, width: self.view.frame.width - 20, height: 300)
        }
       
        imageriView.layer.cornerRadius = 150
        imageriView.clipsToBounds = true
        if let aImg = self.imagel {
        imageriView.image = aImg
        }
        self.swipeDis.direction = .down
        self.swipeDis.addTarget(self, action: #selector(self.hideProfPhoto))
        imageriView.contentMode = .scaleAspectFill
        self.viewProf.addSubview(imageriView)
       
       
        let buttonOut = UIButton()
        buttonOut.setImage(#imageLiteral(resourceName: "downMatch"), for: .normal)
        buttonOut.frame = CGRect(x: 20, y: 30, width: 60, height: 60)
        buttonOut.addTarget(self, action: #selector(self.hideProfPhoto), for: .touchUpInside)
        self.viewProf.addGestureRecognizer(swipeDis)
        self.viewProf.addSubview(buttonOut)
         if self.imagel != #imageLiteral(resourceName: "profiler") {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(viewProf)
        }
    }
   @objc func hideProfPhoto () {
        self.viewProf.removeFromSuperview()
        self.viewProf.isHidden = true
    self.navigationController?.navigationBar.isHidden = false
    self.tabBarController?.tabBar.isHidden = false
    }
    let instaButton = UIButton()
    func grabInstagramAccount () {
        if let theirid = self.id {
            let ref = Database.database().reference()
            ref.child("users").child(theirid).child("instagramAccount").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    
                    if let usernemrtti = snapshot.value as? String {
                        self.account = usernemrtti
                        self.instaButton.frame = CGRect(x: self.view.frame.width - 80, y: 40, width: 60, height: 60)
                        self.instaButton.setImage(#imageLiteral(resourceName: "instag"), for: .normal)
                        self.instaButton.addTarget(self, action: #selector(self.loadInsta), for: .touchUpInside)
                        self.viewProf.addSubview(self.instaButton)
                        
                    }
                } else {
                    //do nothing
                }
            })
        }
    }
    
    var account: String?
    @objc func loadInsta() {
        if let accounter = self.account {
            let string = "https://www.instagram.com/\(accounter)"
            UIApplication.shared.open(URL(string:string)!, options: [:], completionHandler: nil)
        }
    }
    var oneScore = false
    func addScores () {
        if oneScore == false {
            oneScore = true
        if let uid = Auth.auth().currentUser?.uid {
            if let theirid = self.id {
                let ref = Database.database().reference()
                ref.child("users").child(theirid).child("score").observeSingleEvent(of: .value, with: {(snap) in
                    if let score = snap.value as? Int {
                        let newScore = score + 1
                        let feedi = ["score" : newScore]
                        ref.child("users").child(theirid).updateChildValues(feedi)
                        let incress = ["increased" : "increased"]
                        ref.child("users").child(theirid).updateChildValues(incress)
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
        }
    }
    }
    
    
  
    
    func newMatch (valur: Int) {
        if let theirId = self.id {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
        ref.child("users").child(uid).child("matches").child(theirId).removeValue()
        ref.child("users").child(theirId).child("matches").child(uid).removeValue()
        ref.child("users").child(uid).child("unseen").child(theirId).removeValue()
        ref.child("users").child(theirId).child("unseen").child(uid).removeValue()
            
                let feed = [theirId : valur]
                ref.child("users").child(uid).child("matches").updateChildValues(feed)
                let theirFeed = [uid : valur]
                ref.child("users").child(theirId).child("matches").updateChildValues(theirFeed)
                
     
                
                if let theirUrl = theirUrl {
                    if let imagelr = self.imagel {
                        self.delegate?.userDidMatch(name: namer!, image: imagelr, url: theirUrl, uid: theirId)
                    } else {
                        self.delegate?.userDidMatch(name: namer!, image: #imageLiteral(resourceName: "profiler"), url: theirUrl, uid: theirId)
                    }
                } else {
                    self.delegate?.userDidMatch(name: namer!, image: #imageLiteral(resourceName: "profiler"), url: "none", uid: theirId)
                }
                
                if let theirKey = self.tokenKey {
                    if let myName = Auth.auth().currentUser?.displayName {
                        
                        let messgae = "You just connected with \(myName)"
                        
                        let data = [
                            "contents": ["en": "\(messgae)"],
                            "include_player_ids":["\(theirKey)"],
                            "ios_badgeType": "Increase",
                            "ios_badgeCount": 1
                            ] as [String : Any]
                        OneSignal.postNotification(data)
                    }
                }
                if let mymatch = self.myMatches {
                    if mymatch.contains(theirId) {
                        
                    } else {
                        let updteAdd = ["newMatch" : "new"]
                         let updteInc = ["increased" : "new"]
                        ref.child("users").child(uid).updateChildValues(updteAdd)
                         ref.child("users").child(uid).updateChildValues(updteInc)
                        ref.child("users").child(theirId).updateChildValues(updteAdd)
                         ref.child("users").child(theirId).updateChildValues(updteInc)
                    }
                } else {
                    let updteAdd = ["newMatch" : "new"]
                    let updteInc = ["increased" : "new"]
                    ref.child("users").child(uid).updateChildValues(updteAdd)
                    ref.child("users").child(uid).updateChildValues(updteInc)
                    ref.child("users").child(theirId).updateChildValues(updteAdd)
                    ref.child("users").child(theirId).updateChildValues(updteInc)
                }
        }
        }
    }
    
    func regularUpdate (valur: Int) {
        if let theirId = self.id {
            if let uid = Auth.auth().currentUser?.uid {
                if let selectedIndex = self.selectedIndex {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("matches").child(theirId).removeValue()
                ref.child("users").child(theirId).child("matches").child(uid).removeValue()
                ref.child("users").child(uid).child("unseen").child(theirId).removeValue()
                ref.child("users").child(theirId).child("unseen").child(uid).removeValue()
                
                if valur == 3 {
                    if selectedIndex != 2 {
                        if let token = self.tokenKey {
                            self.delegate?.sendOffNotification(uid: theirId, token: token)
                        }
                    }
                 } else {
                    let myFeed = [theirId : valur]
                    ref.child("users").child(uid).child("unseen").updateChildValues(myFeed)
                }
                let feed = [uid : selectedIndex]
                ref.child("users").child(theirId).child("unseen").updateChildValues(feed)
                
                    if selectedIndex != 2 {
                        self.delegate?.findSomeUsers(uid: theirId, connection: "any")
                    }
                    
                }
            }
        }
    }

}
