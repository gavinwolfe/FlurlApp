//
//  SearchViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/2/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import OneSignal
import CoreLocation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,
    UISearchBarDelegate, userMatch, CLLocationManagerDelegate
{
    @IBOutlet weak var topLabel: UILabel!
    
    let manager = CLLocationManager()
  
    var lastOnline: Int?
    override func viewWillLayoutSubviews() {
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        tablerView.frame = CGRect(x: 0, y: 93.0, width: self.view.frame.width, height: self.view.frame.height - 142)
     
        if self.view.frame.height == 812 {
            tablerView.frame = CGRect(x: 0, y: 110, width: self.view.frame.width, height: self.view.frame.height - 160)
           topLabel.frame = CGRect(x: 5, y: 88.5, width: 150, height: 20)
        }
        
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
       
    }
    
    func grabLastOnline () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("lastSearchLog").observeSingleEvent(of: .value, with: {(snapshotr) in
                if let lasterLog = snapshotr.value as? Int {
                    self.lastOnline = lasterLog
                    self.updateSearchLog()
                } else {
                    self.updateSearchLog()
                }
            })
        }
    }
    func updateSearchLog () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
            let feed = ["lastSearchLog" : timeNow]
            ref.child("users").child(uid).updateChildValues(feed)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("locating")
            self.myLocation = location
            
            if self.notCalled == false {
                self.algorithm4()
            }
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                let feed = ["locationLong" : location.coordinate.longitude, "locationLat" : location.coordinate.latitude]
                ref.child("users").child(uid).updateChildValues(feed)
                manager.stopUpdatingLocation()
               
            }
        }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
   var calledLate = false
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
        addAllowLocation()
            self.myLocation = nil
            calledLate = true
              algorithm4()
            self.activityIndc.stopAnimating()
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
           self.manager.startUpdatingLocation()
            calledLate = true
        }
    }
    
  let dispacthyGroup = DispatchGroup()
    let refreshControl = UIRefreshControl()
   let activityIndc = UIActivityIndicatorView()
    let searchController = UISearchController(searchResultsController: nil)
    var suggestedUsers = [Userly]()
    var filteredUsers = [Userly]()
    var users = [Userly]()
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.grabLastOnline()
        myAge()
        
        if self.tabBarController?.tabBar.items?[1].badgeValue != nil {
            let myString = self.tabBarController?.tabBar.items?[1].badgeValue
            let myInt = (myString! as NSString).integerValue
            self.navigationItem.leftBarButtonItem?.addBadge(number: myInt)
        }
        
     self.manager.requestWhenInUseAuthorization()
       manager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case  .restricted, .denied:
                if self.notCalled == false {
                    self.algorithm4()
                }
                addAllowLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("good")
            case .notDetermined:
                print("nope")
            }
        } else  {
           
            print("Location services are not enabled")
        }
        
        grabMatched()
    
        checkIfShowDirections()
        
        algorithmUnseen()
        randomUsers()
        getSuggesteds()
        

         dispacthyGroup.notify(queue: DispatchQueue.main) {
            print("all don")
            if self.suggestedPrior.count > 0 {
            self.checkIfChecked()
            }
        }
        
     
      
        activityIndc.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        activityIndc.color = UIColor.blue
        
        if Auth.auth().currentUser?.uid != nil {
            self.view.addSubview(activityIndc)
            self.activityIndc.startAnimating()
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.2039, green: 0, blue: 0.949, alpha: 1.0)
        
        if #available(iOS 10.0, *) {
            tablerView.refreshControl = refreshControl
            
        } else {
            tablerView.backgroundView = refreshControl
            
        }
     
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 25)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        searchController.searchBar.barTintColor = UIColor(red: 0.851, green: 0.8549, blue: 0.8667, alpha: 1.0)
        
        definesPresentationContext = true
        tablerView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = .black
        searchController.dimsBackgroundDuringPresentation = false
       searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.barTintColor = .white
        print(tablerView.frame)
        filteredUsers = suggestedUsers
        tablerView.frame = CGRect(x: 0, y: 90.0, width: self.view.frame.width, height: self.view.frame.height - 142)
        tablerView.delegate = self
        tablerView.dataSource = self
        
       
        // Do any additional setup after loading the view.
    }
    let buttonEr = UIButton()

    func addAllowLocation () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("locationLat").removeValue()
            ref.child("users").child(uid).child("locationLong").removeValue()
        }
        buttonEr.setTitle("Enable Suggested Users", for: .normal)
        buttonEr.frame = CGRect(x: 20, y: self.view.frame.height - 140, width: self.view.frame.width - 40, height: 50)
        buttonEr.layer.shadowRadius = 0.5
        buttonEr.layer.shadowColor = UIColor.black.cgColor
        buttonEr.layer.shadowOpacity = 1.0
        buttonEr.titleLabel?.font = UIFont(name: "Futura", size: 20)
        buttonEr.setTitleColor(.white, for: .normal)
        buttonEr.backgroundColor = UIColor(red: 0, green: 0.4863, blue: 0.6078, alpha: 1.0)
        buttonEr.layer.cornerRadius = 25.0
        buttonEr.clipsToBounds = true
        buttonEr.addTarget(self, action: #selector(self.makeAlertLocation), for: .touchUpInside)
        
        self.view.addSubview(buttonEr)
    }
   @objc func makeAlertLocation () {
        let alert = UIAlertController(title: "Allow Location", message: "In order for us to find suggested users, we need to access your location only while you are in the app. Your location will never be shared publicly, nor will it be displayed anywhere. We only update your location each time you open the discover portion of the app, and not at any other time in the app. This helps us find people that you may know and that are close to you, so the suggested users are more likely to be familiar people.", preferredStyle: .alert)
    let action1 = UIAlertAction(title: "Settings", style: .default, handler: {(alert: UIAlertAction) -> Void in
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    })
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    self.buttonEr.isHidden = true
    alert.addAction(action1)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func refresh() {
        self.refreshUnseen()
    }
    
    func refreshUnseen () {
        if allowRefreshnow == true {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("unseen").observeSingleEvent(of: .value, with: {(snapshot) in
                if let unseeners = snapshot.value as? [String : AnyObject] {
                    for (un,ip) in unseeners {
                        if ip as? Int != 2 {
                            if self.tested.contains(un) {
                                
                            } else {
                                self.checkNewRefresh(uid: un)
                            }
                            
                        } else {
                            self.dontGrabers.append(uid)
                        }
                    }
                   
                } else {
                
                }
                self.refreshControl.endRefreshing()
            })
        }
        } else {
             self.refreshControl.endRefreshing()
        }
        
    }
    
    func checkNewRefresh(uid: String) {
        if let uider = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
        ref.child("users").child(uid).child("unseen").child(uider).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let theirUnseenInt = snapshot.value as? Int {
                
                if theirUnseenInt != 2 {
                    
                } else {
                
                }
               
            }  else if self.matches.contains(uid) {
                
            } else {
               // self.simpleCount.append(uid)
                self.loadusersForNews(uid: uid, content: "• Suggested User", importance: 1, unseen: "yes")
            }
        })
        }
    }
    
    
   var matches = [String]()
    func grabMatched () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            //remove any unseen users for notifications
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
            filteredUsers = suggestedUsers
        }
        if searchController.searchBar.text != "" {
            if filteredUsers.count > 8 {
                return 8
            }
        }
        if filteredUsers.count > 90 {
            return 90
        }
        return filteredUsers.count
    }
    
    
    var highMem = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.imagerView.layer.cornerRadius = 25.0
        cell.imagerView.clipsToBounds = true
        cell.backView.layer.cornerRadius = 27.0
        cell.backView.clipsToBounds = true
        cell.furtherBackView.layer.cornerRadius = 29.0
        cell.furtherBackView.clipsToBounds = true
        
        cell.unseenViewer.frame = CGRect(x: cell.frame.width - 36, y: cell.frame.height / 2.2, width: 12, height: 12)
        cell.unseenViewer.layer.cornerRadius = 6.0
        
        cell.mainLabel.frame = CGRect(x: 73, y: 12, width: self.view.frame.width - 95, height: 22)
        cell.subLabel.frame = CGRect(x: 73, y: 36, width: self.view.frame.width - 75, height: 20)
        if let imager = filteredUsers[indexPath.row].imageUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
           cell.imagerView.kf.indicatorType = .activity
            if self.highMem == false {
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
        } else {
            cell.imagerView.image = #imageLiteral(resourceName: "profiler")
        }
        cell.mainLabel.text = filteredUsers[indexPath.row].namer
        if let connection = filteredUsers[indexPath.row].connection {
        cell.subLabel.text = connection
        } else {
            cell.subLabel.text = filteredUsers[indexPath.row].username
        }
        if let unseenerYes = filteredUsers[indexPath.row].isUnseen {
            if unseenerYes != "" {
              cell.unseenViewer.backgroundColor = UIColor(red: 0, green: 0.549, blue: 0.9686, alpha: 1.0)
            }
        } else {
              cell.unseenViewer.backgroundColor = .clear
        }
       
        return cell
    }
    var refresher: Bool?
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tablerView.refreshControl = nil
        refresher = false
    }


    func updateSearchResults(for searchController: UISearchController) {
        if (!tablerView.isDragging && !tablerView.isDecelerating) {
        if searchController.searchBar.text == "" {
            filteredUsers = suggestedUsers
            if refresher == true {
                tablerView.reloadData()
            } else {
                print("dont reload")
            }
            
        }
        else {
            let texter = searchController.searchBar.text!
            if texter.count > 1 {
                refresher = true
               self.pullUsersByName(input: texter)
              
            }
         
        }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if filteredUsers == suggestedUsers {
            refresher = false
        } else {
            refresher = true
        }
        if searchBar.text == "" {
            tablerView.refreshControl = refreshControl
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      print("memory warning")
        self.highMem = true
        // Dispose of any resources that can be recreated.
    }
    
    
    ////// #@#$%$#$#$ Segue /////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "segueUser" {
            let dest = segue.destination as! UserViewController
            if let index = tablerView.indexPathForSelectedRow {
            let cell = tablerView.cellForRow(at: index) as! SearchTableViewCell
            dest.imagel = cell.imagerView.image
            if let aurl = filteredUsers[index.row].imageUrl {
                dest.theirUrl = aurl
            } else {
                dest.theirUrl = nil
            }
            dest.namer = filteredUsers[index.row].namer
            dest.userName = filteredUsers[index.row].username
            dest.id = filteredUsers[index.row].uider
            if self.matches.count != 0 {
           dest.myMatches = self.matches
                if self.matches.contains(filteredUsers[index.row].uider) {
                dest.areMatched = "yes"
                }
            }
            if self.showDirections == true {
                dest.showDirections = true
                self.showDirections = false
            }
            if let tokenKey = filteredUsers[index.row].userKey {
                dest.tokenKey = tokenKey
            }
            
                if let privater = filteredUsers[index.row].privater {
                    dest.privateAccnt = privater
                }
            dest.delegate = self
        }
        }
        if segue.identifier == "notifs" {
            self.navigationItem.leftBarButtonItem?.removeBadge()
        }
    }
    
var showDirections = false
    func checkIfShowDirections () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("showDirections").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    self.showDirections = true
                    self.showDirection()
                } else {
                    return
                }
            })
        }
    }

   // start
 var maxSomeUsers = [String]()
    func randomUsers () {
         if CLLocationManager.locationServicesEnabled() {
            let mark = CLLocationManager.authorizationStatus()
            if  mark == .authorizedWhenInUse {
        self.dispacthyGroup.enter()
        if let myAget = UserDefaults.standard.object(forKey: "age") as? Int {

            let ref = Database.database().reference()
            ref.child("newUsers").observeSingleEvent(of: .value, with: {(snapshoter) in
                if let valuer = snapshoter.value as? [String : AnyObject] {
                     let dispatchGroup = DispatchGroup()
                    for (one,_) in valuer {
                         dispatchGroup.enter()
                        ref.child("users").child(one).child("age").observeSingleEvent(of: .value, with: {(snap) in
                            if let agerti = snap.value as? Int {
                                if myAget - agerti <= 1 && myAget - agerti >= -1 {
                                    if self.maxSomeUsers.contains(one) || self.maxSomeUsers.count > 60 {

                                    } else {
                                        self.maxSomeUsers.append(one)
                                        if self.tested.contains(one) {

                                        } else {
                                            self.suggestedPrior.append("\(one)#")
                                         print("yeep")
                                            self.tested.append(one)
                                        }

                                    }
                                }
                            }
                            dispatchGroup.leave()
                        })

                    }

                    dispatchGroup.notify(queue: DispatchQueue.main) {
                      self.dispacthyGroup.leave()
                    }
                }
            })
        }
        }
        }
    }
    
    
    
    
    var suggestedPrior = [String]()
    var tested = [String]()
    var onc = false
    func getSuggesteds () {
        self.dispacthyGroup.enter()
        if onc == false {
            onc = true
            print("heres call")
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let matcherts = snapshot.value as? [String : AnyObject] {
                      let dispatcherGroup = DispatchGroup()
                    for (uno, _) in matcherts {
                        dispatcherGroup.enter()
                        ref.child("users").child(uno).child("matches").observeSingleEvent(of: .value, with: {(snap) in
                            if let aMatched = snapshot.value as? [String : AnyObject] {
                                for (i, _) in aMatched {
                                    if i != uid {
                                        if self.tested.contains(i) || self.dontGrabers.contains(i) {
                                            
                                        } else {
                                            self.tested.append(i)
                                         self.suggestedPrior.append("\(i)!")
                                        print("appending")
                                            self.grabSomeMore(uid: i)
                                        }
                                    }
                                }
                            }
                            dispatcherGroup.leave()
                        })
                    }
                    
                     dispatcherGroup.notify(queue: DispatchQueue.main) {
                        self.dispacthyGroup.leave()
                    }
                } else {
                    self.dispacthyGroup.leave()
                }
            })
        
        }
        }
    }
   
    func grabSomeMore (uid: String) {
        dispacthyGroup.enter()
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
            if let matcherts = snapshot.value as? [String : AnyObject] {
                for (uno, _) in matcherts {
                    if self.tested.contains(uno) || self.dontGrabers.contains(uno) {
                        
                    } else {
                        
                        self.tested.append(uno)
                       self.suggestedPrior.append("\(uno)!")
                        print("added sugg")
                    }
                }
            }
        })
        
          ref.child("users").child(uid).child("unseen").observeSingleEvent(of: .value, with: {(snapshoti) in
            if let unseens = snapshoti.value as? [String : AnyObject] {
                  let dispatchGroupu = DispatchGroup()
                for (a,b) in unseens {
                    dispatchGroupu.enter()
                    if b as? Int != 2 {
                        if self.tested.contains(a) || self.dontGrabers.contains(a) {
                            
                        } else {
                            
                            self.tested.append(a)
                           self.suggestedPrior.append("\(a)!")
                           print("added suggi")
                        }
                    }
                    dispatchGroupu.leave()
                }
                dispatchGroupu.notify(queue: DispatchQueue.main) {
                    self.dispacthyGroup.leave()
                }
            } else {
             self.dispacthyGroup.leave()
            }
         })
        
    }
    
   var notCalled = false
  
    var myLocation: CLLocation?

  // load new users
    var maxNewUsers = [String]()
    func algorithm4 () {
        print("calling alg4")
      
      self.notCalled = true
         if CLLocationManager.locationServicesEnabled() {
            let mark = CLLocationManager.authorizationStatus()
            if mark == .denied || mark == .restricted {
                print("sloop")
                  dispacthyGroup.enter()
               let refer = Database.database().reference()
                  if let myAget = self.myAgel {
                refer.child("newUsers").observeSingleEvent(of: .value, with: {(snapshoter) in
                    if let valuer = snapshoter.value as? [String : AnyObject] {
                         let dispatchGrouper = DispatchGroup()
                        for (one,_) in valuer {
                            dispatchGrouper.enter()
                            refer.child("users").child(one).child("age").observeSingleEvent(of: .value, with: {(snap) in
                                if let agerti = snap.value as? Int {
                                        if myAget - agerti <= 1 && myAget - agerti >= -1 {
                                            if self.tested.contains(one) {
                                            } else {
                                              if self.maxNewUsers.contains(one) || self.dontGrabers.contains(one) {
                                              } else if self.maxNewUsers.count < 95 {
                                                self.maxNewUsers.append(one)
                                                self.tested.append(one)
                                                self.suggestedPrior.append("\(one)#")
                                            
                                                }
                                            }
                                    }
                                }
                                dispatchGrouper.leave()
                            })
                        }
                        dispatchGrouper.notify(queue: DispatchQueue.main) {
                            self.dispacthyGroup.leave()
                            if self.calledLate == true {
                                print("yeelow")
                               self.newIfChecked()
                                self.calledLate = false
                                return
                            }
                        }
                    }
                })
            }
            }
         }
        
        if let uid = Auth.auth().currentUser?.uid {
         print(uid)
           
            let ref = Database.database().reference()
            if let myLocationer = myLocation {
             dispacthyGroup.enter()
                ref.child("users").queryOrdered(byChild:"locationLat").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let userlers = snapshot.value as? [String : AnyObject] {
                         let dispatchGroupel = DispatchGroup()
                        for (_,val) in userlers {
                            dispatchGroupel.enter()
                            if let long = val["locationLong"] as? Double, let lat = val["locationLat"] as? Double, let aUid = val["uid"] as? String, let aget = val["age"] as? Int {
                                if let myAget = self.myAgel {
                                    if myAget - aget <= 1 && myAget - aget >= -1 {
                                        if self.maxNewUsers.contains(aUid) {
                                            
                                        } else if self.maxNewUsers.count <  80 {
                                            
                                            if self.distance(lat1: myLocationer.coordinate.latitude, lon1: myLocationer.coordinate.longitude, lat2: lat, lon2: long) == true {
                                                if aUid != Auth.auth().currentUser?.uid {
                                                    
                                                    if self.tested.contains(aUid) || self.dontGrabers.contains(aUid) {
                                                        
                                                    } else {
                                                        self.maxNewUsers.append(aUid)
                                                        self.tested.append(aUid)
                                                        self.suggestedPrior.append("\(aUid)@")
                                                        print("duloc")
                                                    }
                                                    
                                                }
                                            }
                                        }
                            }
                                }
                            }
                            dispatchGroupel.leave()
                          
                        }
                      dispatchGroupel.notify(queue: DispatchQueue.main) {
                        self.dispacthyGroup.leave()
                        if self.calledLate == true {
                            print("yeelow")
                            self.newIfChecked()
                            self.calledLate = false
                        }
                        }
                    }
                    
                })
            }
           
        }
    }
    
    
    func newIfChecked () {
        if self.suggestedPrior.count != 0 {
            for (intc,each) in suggestedPrior.enumerated() {
                let context = "• Suggested User"
                   let realVal = each.dropLast()
                  let diceRoll = Int(arc4random_uniform(20) + 6)
                  if intc == self.suggestedPrior.endIndex-1 {
                self.loadUser(uid: String(realVal), content: context, importance: diceRoll, unseen: "yes", last: "true")
                
                  } else {
                     self.loadUser(uid: String(realVal), content: context, importance: diceRoll, unseen: "yes", last: "no")
                }
            }
        }
    }
    
   
    
    // find distance between function
    func distance(lat1: Double , lon1: Double, lat2: Double, lon2: Double) -> Bool {
    let p = 0.017453292519943295;    // Math.PI / 180
    
    let a = 0.5 - cos((lat2 - lat1) * p)/2 +
    cos(lat1 * p) * cos(lat2 * p) *
    (1 - cos((lon2 - lon1) * p))/2;
    
    let returner = Int(12742 * asin(sqrt(a)))
        if returner < 21 {
           return true
        }
        return false
    }
   
    
    
  var allowRefreshnow = false
  var dontGrabers = [String]()
    var noners = false
    func algorithmUnseen () {
        self.dispacthyGroup.enter()
        print("unseen algorithm")
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("unseen").observeSingleEvent(of: .value, with: {(snapshot) in
                if let unseeners = snapshot.value as? [String : AnyObject] {
                     let dispatchGroupet = DispatchGroup()
                    for (un,ip) in unseeners {
                        dispatchGroupet.enter()
                        if ip as? Int != 2 {
                            if self.tested.contains(un) {
                                
                            } else {
                          self.suggestedPrior.append("\(un)~")
                                self.tested.append(un)
                            }
                        } else {
                          self.dontGrabers.append(un)
                        }
                        dispatchGroupet.leave()
                    }
                    dispatchGroupet.notify(queue: DispatchQueue.main) {
                        self.dispacthyGroup.leave()
                    }
                   
                } else {
                    self.noners = true
                        self.dispacthyGroup.leave()
                }
             self.allowRefreshnow = true
            })
        }
    }
    
   
  var luxCheck = [String]()
    func checkIfChecked () {
        print("onceler")
        
print(suggestedPrior.count)
        if self.suggestedPrior.count != 0 {
            for (indx, each) in self.suggestedPrior.enumerated() {
        if let uider = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            
           let realVal = each.dropLast()
            print("checking!!!!!")
            ref.child("users").child(String(realVal)).child("unseen").child(uider).observeSingleEvent(of: .value, with: { (snapshot) in

                if let theirUnseenInt = snapshot.value as? Int {

                    if theirUnseenInt != 2 {

                    } else {
                      
                    }
                    
                    if indx == self.suggestedPrior.endIndex-1 {
                        self.loadUser(uid: "hhh", content: "nope", importance: 5, unseen: "yes", last: "true")
                        print("edn index")
                    }
                }  else {
                    if self.matches.contains(String(realVal)) || self.dontGrabers.contains(String(realVal)) {
                        if indx == self.suggestedPrior.endIndex-1 {
                            self.loadUser(uid: "hhh", content: "nope", importance: 5, unseen: "yes", last: "true")
                            print("edn index")
                        }
                    } else {
                        var content = "• Suggested User"
                        var diceRoll = Int(arc4random_uniform(20) + 6)
                        if each.contains("~") {
                            diceRoll = Int(arc4random_uniform(12) + 1)
                        }
                        if each.contains("!") {
                            if diceRoll >= 12 {
                                content = "• Has mutual connections"
                            }
                        }
                        if each.contains("@") {
                            diceRoll = Int(arc4random_uniform(20) + 12)
                        }
                        if each.contains("#") {
                            diceRoll = Int(arc4random_uniform(20) + 18)
                            content = "• New to Flurl"
                        }
                        
                            self.loadUser(uid: String(realVal), content: content, importance: diceRoll, unseen: "yes", last: "no")
                        
                        if indx == self.suggestedPrior.endIndex-1 {
                            self.loadUser(uid: String(realVal), content: "nope", importance: diceRoll, unseen: "yes", last: "true")
                            print("edn index")
                        }
                        
                        print("done callaing check")
                    }
                }
            })
        }
                if indx == self.suggestedPrior.endIndex-1 {
                    self.loadUser(uid: "jj", content: "nope", importance: 5, unseen: "yes", last: "true")
                    print("edn index")
                }
                
            }
        } else {
           
            labelov.frame = CGRect(x: 15, y: 140, width: self.view.frame.width - 30, height: 160)
            labelov.font = UIFont(name: "Futura", size: 18)
            labelov.numberOfLines = 6
            labelov.textAlignment = .center
            labelov.text = "Because there aren't enough users near you right now, find some people you know by searching them, then we can find suggested users for you."
            labelov.textColor = .black
            self.view.addSubview(labelov)
        }
    }
     let labelov = UILabel()
    
   
    var checkedalready = [String]()
    
    func loadUser(uid: String, content: String, importance: Int, unseen: String, last: String) {

        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String, let ager = value?["age"] as? Int {
               
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                newpUser.connection = content
                newpUser.interl = importance
                if let urler = value?["profileUrl"] as? String {
                    newpUser.imageUrl = urler
                }
                if let theirKey = value?["userKey"] as? String {
                    newpUser.userKey = theirKey
                }
                if let theyPriv = value?["privateAccount"] as? String {
                    newpUser.privater = theyPriv
                }
                if unseen == "yes" {
                    if let theirNew = value?["newUser"] as? Int {
                        if let lastOnliner = self.lastOnline {
                            if theirNew > lastOnliner {
                               newpUser.isUnseen = "unseen"
                                newpUser.connection = "• New Suggested User"
                        }
                    }
                    }
                    
                }
                if self.suggestedUsers.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid {
                    print("denied \(importance)")
                
                } else if self.suggestedUsers.count < 125 {
                    if let myAget = self.myAgel {
                        if myAget - ager <= 4 && myAget - ager >= -4 {
                           
                    self.suggestedUsers.append(newpUser)
                            if self.labelov.isHidden == false {
                                self.labelov.isHidden = true
                            }
                    if self.suggestedUsers.count != 0 {
                        print("added user")
                        print(self.suggestedUsers.count)
                       
                    }
                        } else {
                        
                            print("denied age")
                        }
                    }
                }
            
                self.activityIndc.stopAnimating()
          
                if last == "true" {
                    print("we have reloaded")
                    self.tablerView.reloadData()
                }
            } else {

                if last == "true" {
                    self.tablerView.reloadData()
                    print("reload")
                }
            
            }
    
        })
        if last == "true" {
            self.tablerView.reloadData()
            print("reload")
        }

    }
    
    
   
    
    
    func pullUsersByName (input: String) {
      
        if let uid = Auth.auth().currentUser?.uid {
               self.filteredUsers.removeAll()
            self.tablerView.reloadData()
            let ref = Database.database().reference()
            ref.child("users").queryOrdered(byChild: "name").queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userer = snapshot.value as? [String : AnyObject] {
                    for (_, each) in userer {
                        if let usernamer = each["username"] as? String, let namerl = each["name"] as? String, let uiderl = each["uid"] as? String, let ageti = each["age"] as? Int {
                            let newr = Userly()
                            newr.username = usernamer
                            newr.namer = namerl
                            newr.uider = uiderl
                            if let urler = each["profileUrl"] as? String {
                                newr.imageUrl = urler
                            }
                            if let theirKey = each["userKey"] as? String {
                                newr.userKey = theirKey
                            }
                            if let theyPriv = each["privateAccount"] as? String {
                                newr.privater = theyPriv
                            }
                            if self.matches.contains(uid) {
                                newr.matched = "yes"
                            } else {
                                newr.matched = "no"
                            }
                            print("onne")
                            if self.filteredUsers.contains( where: { $0.uider == newr.uider } ) || newr.uider == uid {
                                print("no")
                            } else {
                                if self.filteredUsers.count < 20 {
                                    if let myAget = self.myAgel {
                                        if myAget - ageti <= 3 && myAget - ageti >= -3 {
                                self.filteredUsers.append(newr)
                                            if self.labelov.isHidden == false {
                                                self.labelov.isHidden = true
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    self.activityIndc.stopAnimating()
                    
                    self.tablerView.reloadData()
                    
                } else {
                    let inputer = input.lowercased()
                    self.pullUsersByUsername(input: inputer)
                }
            }, withCancel: nil)
        }
        
    }
    
    func pullUsersByUsername (input: String) {
        if let uid = Auth.auth().currentUser?.uid {
         
            let ref = Database.database().reference()
            ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userer = snapshot.value as? [String : AnyObject] {
                     self.filteredUsers.removeAll()
                    for (_, each) in userer {
                        if let usernamer = each["username"] as? String, let namerl = each["name"] as? String, let uiderl = each["uid"] as? String, let ageti = each["age"] as? Int {
                            let newr = Userly()
                            newr.username = usernamer
                            newr.namer = namerl
                            newr.uider = uiderl
                            if let urler = each["profileUrl"] as? String {
                                newr.imageUrl = urler
                            }
                            if let theirKey = each["userKey"] as? String {
                                newr.userKey = theirKey
                            }
                            if let theyPriv = each["privateAccount"] as? String {
                                newr.privater = theyPriv
                            }
                            if self.matches.contains(uid) {
                                newr.matched = "yes"
                            } else {
                                newr.matched = "no"
                            }
                            print("onne")
                            if self.filteredUsers.contains( where: { $0.uider == newr.uider } ) || newr.uider == uid {
                                print("no")
                            } else {
                                if self.filteredUsers.count < 20 {
                                    if let myAget = self.myAgel {
                                        if myAget - ageti <= 3 && myAget - ageti >= -3 {
                                self.filteredUsers.append(newr)
                                            if self.labelov.isHidden == false {
                                                self.labelov.isHidden = true
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        self.activityIndc.stopAnimating()
                    }
                    self.tablerView.reloadData()
                
                    
                } else {
                     self.tablerView.reloadData()
                }
            }, withCancel: nil)
        }
    }
    
     let exitButton = UIButton()
    let imagetView = UIImageView()
    let viewer = UIView()
     let nameLabel = UILabel()
    func userDidMatch(name: String, image: UIImage, url: String, uid: String) {
        viewer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        viewer.backgroundColor = UIColor(red: 0.1451, green: 0.5529, blue: 0.9882, alpha: 1.0)
        self.passName = name
        self.passUid = uid
        self.hiderButton.isHidden = true
          self.viewer.isHidden = false
        self.imagetView.contentMode = .scaleAspectFill
        self.imagetView.frame = CGRect(x: 8, y: 12, width: 50, height: 50)
     imagetView.image = image
       
        nameLabel.text = "\(name) \n • You both just connected"
        nameLabel.font = UIFont(name: "Futura", size: 15)
        nameLabel.frame = CGRect(x: 68, y: 12, width: viewer.frame.width - 56, height: 42)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
      
     
        let aroundView = UIView()
        aroundView.frame = CGRect(x: 6, y: 10, width: 54, height: 54)
        aroundView.backgroundColor = .white
        aroundView.layer.cornerRadius = 27
        aroundView.clipsToBounds = true
        imagetView.layer.cornerRadius = 25
        imagetView.clipsToBounds = true
        viewer.addSubview(nameLabel)
    
       
        self.exitButton.frame = CGRect(x: self.viewer.frame.width - 55, y: 18, width: 40, height: 40)
        self.exitButton.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
        self.exitButton.setTitle("", for: .normal)
    
        self.exitButton.addTarget(self, action: #selector(self.slideUp), for: .touchUpInside)
        viewer.addSubview(aroundView)
        viewer.addSubview(imagetView)
      
        if self.view.frame.height == 812 {
            viewer.frame = CGRect(x: 6, y: self.view.frame.height - 170, width: self.view.frame.width - 12, height: 65)
        }
      
        viewer.addSubview(self.exitButton)
        self.view.addSubview(viewer)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
               self.viewer.frame = CGRect(x: 0, y: self.view.frame.height - 125, width: self.view.frame.width, height: 75)
            if self.view.frame.height == 812 {
                 self.viewer.frame = CGRect(x: 0, y: self.view.frame.height - 145, width: self.view.frame.width, height: 75)
            }
        })
        
        
        let when = DispatchTime.now() + 12
        DispatchQueue.main.asyncAfter(deadline: when){
            if self.dontRemove == false {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                 self.viewer.frame = CGRect(x: 6, y: self.view.frame.height , width: self.view.frame.width - 12, height: 0)
            })
            }
            
        }
    }
    let hiderButton = UIButton()
    let buttonMessage = UIButton()
   var dontRemove = false
   @objc func slideUp () {
    dontRemove = true
   buttonMessage.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: 0)
    buttonMessage.layer.borderColor = UIColor.white.cgColor
    buttonMessage.layer.borderWidth = 2.0
    buttonMessage.setTitle("Message", for: .normal)
    buttonMessage.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
    buttonMessage.setTitleColor(.white, for: .normal)
    buttonMessage.layer.cornerRadius = 20.0
    buttonMessage.clipsToBounds = true
    buttonMessage.addTarget(self, action: #selector(self.messageUsert), for: .touchUpInside)
    self.hiderButton.isHidden = false
    hiderButton.frame = CGRect(x: self.viewer.frame.width - 40, y: 10, width: 35, height: 35)
    hiderButton.tintColor = .white
    hiderButton.tintAdjustmentMode = .normal
    hiderButton.addTarget(self, action: #selector(self.hideMatcher), for: .touchUpInside)
    hiderButton.setImage(#imageLiteral(resourceName: "hideDown"), for: .normal)
    self.viewer.addSubview(hiderButton)
 
    self.viewer.addSubview(buttonMessage)
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
        self.viewer.frame = CGRect(x: 0, y: self.view.frame.height - 185, width: self.view.frame.width, height: 135)
        self.exitButton.isHidden = true
          self.buttonMessage.frame = CGRect(x: 20, y: 80, width: self.view.frame.width - 40, height: 38)
         if self.view.frame.height == 812 {
        self.viewer.frame = CGRect(x: 0, y: self.view.frame.height - 205, width: self.view.frame.width, height: 135)
        }
        }, completion: nil)
   
    }
    var passUid: String?
    var passName: String?
    
    @objc func messageUsert () {
        if let passUider = self.passUid {
            if let passNamer = self.passName {
                
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chosenChat") as! UINavigationController
                    let des = vc.viewControllers[0] as! ChosenChatViewController
                    des.theirUid = passUider
                    des.theirName = passNamer
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                     self.hiderButton.isHidden = false
                    self.viewer.isHidden = true

                
            }
        }
    }
    
    @objc func hideMatcher () {
        if self.viewer.isHidden == false {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.viewer.frame = CGRect(x: 6, y: self.view.frame.height , width: self.view.frame.width - 12, height: 0)
            self.dontRemove = false
            self.hiderButton.isHidden = true
            self.exitButton.isHidden = false
        })
        }
    }
    
    func loadusersForNews (uid: String, content: String, importance: Int, unseen: String) {
        
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String, let ager = value?["age"] as? Int {
                
                let newpUser = Userly()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                newpUser.connection = content
                newpUser.interl = importance
                if let urler = value?["profileUrl"] as? String {
                    newpUser.imageUrl = urler
                }
                if let theirKey = value?["userKey"] as? String {
                    newpUser.userKey = theirKey
                }
                if let theyPriv = value?["privateAccount"] as? String {
                    newpUser.privater = theyPriv
                }
                if unseen == "yes" {
                    if let theirNew = value?["newUser"] as? Int {
                        if let lastOnliner = self.lastOnline {
                            if theirNew > lastOnliner {
                                newpUser.isUnseen = "unseen"
                                newpUser.connection = "• New Suggested User"
                            }
                        }
                    }
                    
                }
                if self.suggestedUsers.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid {
                    print("denied \(importance)")
                }
                else {
                    if let myAget = self.myAgel {
                        if myAget - ager <= 2 && myAget - ager >= -2 {
                            
                            self.suggestedUsers.append(newpUser)
                            if self.labelov.isHidden == false {
                                self.labelov.isHidden = true
                            }
                            if self.suggestedUsers.count != 0 {
                                print("added user")
                                print(self.suggestedUsers.count)
                            }
                        } else {
                            print("denied age")
                        }
                    }
                    
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tablerView.reloadData()
            })
            })
         
    }
    
    func findSomeUsers(uid: String, connection: String) {
        if self.searchController.searchBar.text == "" {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
            if let matchers = snapshot.value as? [String : AnyObject] {
                if matchers.count <= 2 {
                    self.grabUnseensSuggested(uid: uid, from: connection)
                }
                for (each, one) in matchers {
                    if one as? Int == 1 {
                        if connection == "any" {
                       
                          if self.suggestedUsers.contains( where: { $0.uider == each } ) || each == Auth.auth().currentUser?.uid {
                            print("already contains")
                        } else {
                         
                            self.loadusersForNews(uid: each, content: "Suggested User", importance: 1, unseen: "no")
                        }
                        }
                        
                    } else {
                        if connection == "friend" {
                           
                            if self.suggestedUsers.contains( where: { $0.uider == each } ) || each == Auth.auth().currentUser?.uid {
                                print("already contains")
                            } else {
                              
                                self.loadusersForNews(uid: each, content: "Suggested User", importance: 1, unseen: "no")
                            }
                        }
                        
                    }
                }
             
            } else {
                self.grabUnseensSuggested(uid: uid, from: connection)
            }
        
        })
        }
    }
    
    func grabUnseensSuggested (uid: String, from: String) {
        let ref = Database.database().reference()
        print("calling unseen suggested")
        ref.child("users").child(uid).child("unseen").observeSingleEvent(of: .value, with: {(snapshot) in
            if let unseeners = snapshot.value as? [String : AnyObject] {
                for (one, uno) in unseeners {
                    if from == "friend" {
                        if uno as? Int == 0  {
                            
                             if self.suggestedUsers.contains( where: { $0.uider == one } ) || one == Auth.auth().currentUser?.uid {
                                print("already contains")
                            } else {
                              
                                self.loadusersForNews(uid: one, content: "Suggested User", importance: 1, unseen: "no")
                            }
                        
                        }
                    }
                    if from == "any" {
                        if uno as? Int == 1 {
                            
                           if self.suggestedUsers.contains( where: { $0.uider == one } ) || one == Auth.auth().currentUser?.uid {
                                print("already contains")
                            } else {
                          
                                self.loadusersForNews(uid: one, content: "Suggested User", importance: 1, unseen: "no")
                            }
                           
                        }
                    }
                   
                }
            } else {
              print("well, nothing")
            }
        })
    }
    
   
    func sendOffNotification(uid: String, token: String) {
        if let myUid = Auth.auth().currentUser?.uid {
            print(myUid)
        let ref = Database.database().reference()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
            ref.child("users").child(uid).child("lastNotification").observeSingleEvent(of: .value, with: {(snap) in
                                if snap.exists() {
                                    // if have last notif - check if over 24 hours since last message
                                    if let lastNotif = snap.value as? Int {
                                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                        let timer = timeStamp - lastNotif
                                        let hours = timer /  3600
                                        if hours >= 24 {
                                            
                                            let feedTime = ["lastNotification" : timeStamp]
                                           
                                            //update last notif
                                        ref.child("users").child(uid).updateChildValues(feedTime)
                                            let messgae = "People have tried to connect with you."
                                           print("sending notif")
                                            let data = [
                                                "contents": ["en": "\(messgae)"],
                                                "include_player_ids":["\(token)"],
                                                "ios_badgeType": "Increase",
                                                "ios_badgeCount": 1
                                                ] as [String : Any]
                                            OneSignal.postNotification(data)
                                           
                                           
                                        }
                                        else {
                                            print("too soon")
                                        return
                                        }
                                    }
                                    // if user doesnt have a last notification
                                } else {
                                    let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                    let feedTime = ["lastNotification" : timeStamp]
                                    ref.child("users").child(uid).updateChildValues(feedTime)
                                    let messgae = "People have tried to connect with you."
                                  
                                    print("sending notif no recent")
                                    let data = [
                                        "contents": ["en": "\(messgae)"],
                                        "include_player_ids":["\(token)"],
                                        "ios_badgeType": "Increase",
                                        "ios_badgeCount": 1
                                        ] as [String : Any]
                                    OneSignal.postNotification(data)
                                 
                                        }
                            })
            }
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove all observers
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("matches").removeAllObservers()
            ref.child("users").removeAllObservers()
            ref.removeAllObservers()
        }
    }
    
    func showDirection() {
        let viewMain = UIView()
        viewMain.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        
        
        viewMain.layer.cornerRadius = 10.0
        viewMain.clipsToBounds = true
        let labelOn = UILabel()
        labelOn.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        labelOn.numberOfLines = 4
        labelOn.text = "Welcome to Discover. This is where you can find people you know, and connect with them."
        labelOn.textAlignment = .center
        labelOn.font = UIFont(name: "Avenir-Heavy", size: 20)
        if self.view.frame.width == 320 {
            labelOn.font = UIFont(name: "Avenir-Heavy", size: 19)
        }
        labelOn.textColor = .white
        viewMain.addSubview(labelOn)
        self.view.addSubview(viewMain)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            viewMain.frame = CGRect(x: 6, y: self.view.frame.height - 160, width: self.view.frame.width - 12, height: 95)
            self.buttonEr.isHidden = true
            labelOn.frame = CGRect(x: 8, y: 5, width: viewMain.frame.width - 16, height: viewMain.frame.height - 10)
            if self.view.frame.height == 812 {
                viewMain.frame = CGRect(x: 6, y: self.view.frame.height - 200, width: self.view.frame.width - 12, height: 95)
                
            }
         
        }, completion: nil)
        
        viewMain.backgroundColor = UIColor(red: 0, green: 0.5098, blue: 0.9882, alpha: 1.0)
        //UIColor(red: 0, green: 0.4275, blue: 0.6, alpha: 1.0)
        
        let when = DispatchTime.now() + 8
        DispatchQueue.main.asyncAfter(deadline: when){
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                viewMain.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                labelOn.frame = CGRect(x: 10, y: self.view.frame.height, width: self.view.frame.width - 20, height: 0)
                self.buttonEr.isHidden = false
                
            }, completion: nil)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonEr.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let unseen = filteredUsers[indexPath.row].isUnseen {
            print(unseen)
                   let lipto = tablerView.cellForRow(at: indexPath) as! SearchTableViewCell
                lipto.backgroundColor = .clear
                filteredUsers[indexPath.row].isUnseen = nil
                tablerView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uidd = filteredUsers[indexPath.row].uider
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





