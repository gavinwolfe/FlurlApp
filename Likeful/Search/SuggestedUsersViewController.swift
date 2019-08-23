//
//  SuggestedUsersViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/25/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class SuggestedUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
      let activityIndc = UIActivityIndicatorView()
    var theirId: String?
    var suggested = [Userly]()
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myAge()
        tablerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112)
        self.grabMatched()
        activityIndc.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        activityIndc.color = UIColor(red: 0, green: 0.2824, blue: 0.5294, alpha: 1.0)
        
        if Auth.auth().currentUser?.uid != nil {
            self.view.addSubview(activityIndc)
            self.activityIndc.startAnimating()
        }
        grabSuggested()
        tablerView.delegate = self
        tablerView.dataSource = self
        self.navigationItem.title = "Suggested Users"
        self.possibleMatch()
        // Do any additional setup after loading the view.
    }
    
    var myAgel: Int?
    func myAge () {
        if let age = UserDefaults.standard.value(forKey: "age") as? Int {
            self.myAgel = age
        }
        else {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("age").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let valuer = snapshot.value as? Int {
                        self.myAgel = valuer
                    }
                    print("finished age")
                })
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggested.count > 50 {
            return 50
        }
        return suggested.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSuggested", for: indexPath) as! SuggestedUsersTableViewCell
        cell.imagerView.layer.cornerRadius = 25.0
        cell.imagerView.clipsToBounds = true
        cell.backView.layer.cornerRadius = 27.0
        cell.backView.clipsToBounds = true
        cell.furtherBackView.layer.cornerRadius = 29.0
        cell.furtherBackView.clipsToBounds = true
        
        cell.labelMain.frame = CGRect(x: 78, y: 12, width: self.view.frame.width - 95, height: 22)
        cell.subLabel.frame = CGRect(x: 78, y: 36, width: self.view.frame.width - 75, height: 20)
         cell.labelMain.text = suggested[indexPath.row].namer
        cell.subLabel.text = suggested[indexPath.row].username
        if let imager = suggested[indexPath.row].imageUrl {
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
            cell.imagerView.image = #imageLiteral(resourceName: "profiler")
        }
        if let matchedAlready = suggested[indexPath.row].matched {
            if matchedAlready == "yes" {
                cell.furtherBackView.backgroundColor = UIColor(red: 0.0627, green: 0.8667, blue: 0.0078, alpha: 1.0)
            } else {
                cell.furtherBackView.backgroundColor = UIColor(red: 0.8039, green: 0.851, blue: 0.949, alpha: 1.0)
            }
        } else {
            cell.furtherBackView.backgroundColor = UIColor(red: 0.8039, green: 0.851, blue: 0.949, alpha: 1.0)
        }
        
        
        
        return cell
    }
    

    
    func grabSuggested () {
        if let uider = theirId {
            let ref = Database.database().reference()
          
            ref.child("users").child(uider).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let matches = snapshot.value as? [String : AnyObject] {
                    for (one, two) in matches {
                        if two as? Int == 1  {
                          
                            self.grabUnseens(uid: one, from: "friend")
                            self.grabMore(uid: one)
                           
                          
                        } else if two as? Int == 0 {
                            self.grabUnseens(uid: one, from: "like")
                            
                        }
                    }
                   
                } else {
                self.grabUnseens(uid: uider, from: "all")
                }
            })
        }
    }
    
    var loaders = [String]()
    var oneRel = false
    func loadUser(uid: String) {
        var reload = false
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String, let ageti = value?["age"] as? Int {
                print("suggester")
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                if let urler = value?["profileUrl"] as? String {
                    newpUser.imageUrl = urler
                }
                if let theirKey = value?["userKey"] as? String {
                    newpUser.userKey = theirKey
                }
                if let theyPriv = value?["privateAccount"] as? String {
                    newpUser.privater = theyPriv
                }
                
                if self.matches.contains(uid) {
                    newpUser.matched = "yes"
                } else {
                    newpUser.matched = "no"
                }
                
                if self.suggested.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid {
                    
                } else if self.suggested.count < 52 {
                    if let myAget = self.myAgel {
                        if myAget - ageti <= 4 && myAget - ageti >= -4 {
                    self.suggested.append(newpUser)
                   reload = true
                        }
                    }
                }
            }
            if reload == true {
                if self.oneRel == false {
                    self.oneRel = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
                      self.activityIndc.stopAnimating()
            self.tablerView.reloadData()
                    }
                }
            
            }
        
        }, withCancel: nil)
            
        
    }
    
    
    func grabMore(uid: String) {
        if uid != Auth.auth().currentUser?.uid {
            if let theirId = theirId {
            if uid != theirId {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? [String : AnyObject] {
                for (one, each) in values {
                    
                    
                    if each as? Int == 1 {
                        
                        self.loadUser(uid: one)
                    }
                    
                }
                
               
            }
        }, withCancel: nil)
        }
        }
        }
    }
    
    func grabUnseens (uid: String, from: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("unseen").observeSingleEvent(of: .value, with: {(snapshot) in
            if let unseeners = snapshot.value as? [String : AnyObject] {
                for (one, uno) in unseeners {
                    if from == "like" {
                        if uno as? Int == 0  {
                            self.loadUser(uid: one)
                            print("like")
                        }
                    }
                    if from == "friend" {
                        if uno as? Int == 1 {
                            self.loadUser(uid: one)
                            print("friend")
                        }
                    }
                    if from == "all" && uno as? Int != 2 {
                        print("all")
                        self.loadUser(uid: one)
                    }
                }
                
            } else {
                if from == "all" {
                       let label = UILabel()
                       label.frame = CGRect(x: 15, y: 100, width: self.view.frame.width - 30, height: 40)
                        label.font = UIFont(name: "Futura", size: 16)
                        label.textAlignment = .center
                        label.text = "Sorry we could not find any suggested users"
                        label.textColor = .black
                        self.view.addSubview(label)
                      self.activityIndc.stopAnimating()
                }
            }
        })
    }

    
    var memoryFull = false
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.suggested.removeAll()
        self.tablerView.reloadData()
         DispatchQueue.main.async {
       self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVc") as! UserViewController
     
        vc.id = suggested[indexPath.row].uider
        vc.namer = suggested[indexPath.row].namer
        vc.userName = suggested[indexPath.row].username
        if let key = suggested[indexPath.row].userKey {
            vc.tokenKey = key
        }
        if let theirirUrl = suggested[indexPath.row].imageUrl {
            vc.theirUrl = theirirUrl
        }
        if let wereMatched = suggested[indexPath.row].matched {
            if wereMatched != "no" {
                vc.areMatched = wereMatched
            }
        }
        if let isPrivate = suggested[indexPath.row].privater {
            vc.privateAccnt = isPrivate
        }
        let celler = tablerView.cellForRow(at: indexPath) as! SuggestedUsersTableViewCell
        vc.imagel = celler.imagerView.image
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
          DispatchQueue.main.async {
            
       self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.tablerView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let blueView = UIView()
    func userMatch(name: String) {
        self.viewer.isHidden = true
        blueView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        blueView.backgroundColor = UIColor(red: 0.0039, green: 0.502, blue: 0.5686, alpha: 1.0)
        //UIColor(red: 0, green: 0.451, blue: 0.6588, alpha: 1.0)
        
        
        view.addSubview(blueView)
        let minorLabel = UILabel()
        minorLabel.font = UIFont(name: "Futura", size: 17)
        minorLabel.textColor = .white
        minorLabel.text = "You have just connected with \(name)"
        minorLabel.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        minorLabel.textAlignment = .center
        
        self.blueView.addSubview(minorLabel)
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseIn, animations: {
            self.blueView.frame = CGRect(x: 0, y: self.view.frame.height - 106, width: self.view.frame.width, height: 65)
            minorLabel.frame = CGRect(x: 5, y: 14, width: self.blueView.frame.width - 10, height: 30)
            
            if self.view.frame.height == 812 {
                  self.blueView.frame = CGRect(x: 0, y: self.view.frame.height - 145, width: self.view.frame.width, height: 95)
            }
        }, completion: nil)
        
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.blueView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                
                minorLabel.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                
                self.viewer.isHidden = false
            }, completion: nil)
        }
        
    }
    
    func possibleMatch () {
        let ref = Database.database().reference()
        if let theirId = self.theirId {
            ref.child("users").child(theirId).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let matchess = snapshot.value as? [String : AnyObject] {
                    for (one, uno) in matchess {
                        if uno as? Int == 1 {
                            self.foundFriend(uid: one)
                        }
                    }
                }
            })
        }
    }
    var unseenFriend = Userly()
    func foundFriend(uid: String) {
        if let uider = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("unseen").child(uider).observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    
                } else {
                    if self.matches.contains(uid) {
                        
                    }
                    else {
                        if self.one == false {
                            if uid == Auth.auth().currentUser?.uid {
                            
                            } else {
                        self.loadSuggester(uid: uid)
                            }
                        }
                    }
                    
                }
            })
        }
    }
 
    var one = false
    func loadSuggester (uid: String) {
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
                if let theirKey = value?["userKey"] as? String {
                    newpUser.userKey = theirKey
                }
                if let theyPriv = value?["privateAccount"] as? String {
                    newpUser.privater = theyPriv
                }
             
                if self.one == false {
                    self.one = true
                    self.showSuggestedUser(user: newpUser)
                    self.suggestedUser = newpUser
                } else {
                    return
                }
                
                
            }
        })
    }
     let imageView = UIImageView()
       let viewer = UIView()
    var suggestedUser: Userly?
    func showSuggestedUser(user: Userly) {
     
        viewer.frame = CGRect(x: 6, y: self.view.frame.height - 120, width: self.view.frame.width - 12, height: 65)
        viewer.backgroundColor = UIColor(red: 0.9608, green: 0.9569, blue: 0.9686, alpha: 1.0)
       
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.frame = CGRect(x: 8, y: 10, width: 42, height: 42)
        if let imager = user.imageUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            
            self.imageView.kf.setImage(with: restource)
            
        } else {
            imageView.image = #imageLiteral(resourceName: "profiler")
        }
        let nameLabel = UILabel()
        nameLabel.text = "\(user.namer!) • suggested"
        nameLabel.font = UIFont(name: "Futura", size: 14)
        nameLabel.frame = CGRect(x: 55, y: 20, width: viewer.frame.width - 56, height: 20)
        nameLabel.textColor = .black
        viewer.layer.shadowRadius = 1.0
        viewer.layer.shadowColor = UIColor.black.cgColor
        viewer.layer.shadowOpacity = 0.5
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        viewer.addSubview(nameLabel)
        let clickButton = UIButton()
        clickButton.frame = CGRect(x: 0, y: 0, width: self.viewer.frame.width, height: self.viewer.frame.height)
        clickButton.setTitle("", for: .normal)
        
        clickButton.addTarget(self, action: #selector(self.clicked), for: .touchUpInside)
       
        let exitButton = UIButton()
        exitButton.frame = CGRect(x: self.viewer.frame.width - 50, y: 18, width: 30, height: 30)
        exitButton.setImage(#imageLiteral(resourceName: "crossOut"), for: .normal)
        exitButton.setTitle("", for: .normal)
        exitButton.addTarget(self, action: #selector(removeSuggested), for: .touchUpInside)
        viewer.addSubview(imageView)
        print(user.namer)
        if self.view.frame.height == 812 {
             viewer.frame = CGRect(x: 6, y: self.view.frame.height - 170, width: self.view.frame.width - 12, height: 65)
        }
         viewer.addSubview(clickButton)
        viewer.addSubview(exitButton)
        self.view.addSubview(viewer)
    }
    
    @objc func removeSuggested () {
        self.viewer.isHidden = true
    }
  
    @objc func clicked() {
        if let userlt = self.suggestedUser {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVc") as! UserViewController
            
            vc.id = userlt.uider
            vc.namer = userlt.namer
            vc.userName = userlt.username
            
            if let key = userlt.userKey {
                vc.tokenKey = key
            }
            if let isPrivt = userlt.privater {
                vc.privateAccnt = isPrivt
            }
     
           vc.imagel = imageView.image
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            DispatchQueue.main.async {
                
                self.navigationController?.pushViewController(vc, animated: true)
                self.viewer.isHidden = true
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uidd = suggested[indexPath.row].uider
        if let uid = uidd {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                let ref = Database.database().reference()
                let feed = [uid : uid]
                ref.child("reported").updateChildValues(feed)
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Report"
    }

}
