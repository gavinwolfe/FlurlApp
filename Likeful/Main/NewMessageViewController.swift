//
//  NewMessageViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    
    var myAgel: Int?
    func myAge () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("age").observeSingleEvent(of: .value, with: {(snapshot) in
                if let valuer = snapshot.value as? Int {
                    self.myAgel = valuer
                }
            })
        }
    }
    
    var users = [Userly]()
    var suggestedUsers = [Userly]()
    var filteredUsers = [Userly]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablerView.delegate = self
        tablerView.dataSource = self

        
      
        myAge()
        grabSuggested()
        filteredUsers = suggestedUsers
        definesPresentationContext = true
        tablerView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = .black
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = .white
          tablerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height  - 64)
        searchController.searchBar.barTintColor = .white
        filteredUsers = suggestedUsers
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
            filteredUsers = suggestedUsers
        }
        if searchController.searchBar.text != "" {
            if filteredUsers.count > 5 {
                return 5
            }
        }
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellNewMessage", for: indexPath) as! NewMessageTableViewCell
        cell.imagerView.layer.cornerRadius = 25.0
        cell.imagerView.clipsToBounds = true
        cell.backView.layer.cornerRadius = 27.0
        cell.backView.clipsToBounds = true
        
        cell.labelMain.frame = CGRect(x: 73, y: 12, width: self.view.frame.width - 95, height: 22)
        cell.subLabel.frame = CGRect(x: 73, y: 36, width: self.view.frame.width - 75, height: 20)
        
        
        if let imager = filteredUsers[indexPath.row].imageUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            
            cell.imagerView.kf.setImage(with: restource)
        } else {
            cell.imagerView.image = #imageLiteral(resourceName: "profiler")
        }
        cell.labelMain.text = filteredUsers[indexPath.row].namer
            cell.subLabel.text = filteredUsers[indexPath.row].username
       
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
      refresher = false
    
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if filteredUsers == suggestedUsers {
            refresher = false 
        } else {
            refresher = true
        }
    }
    var refresher: Bool?
    func updateSearchResults(for searchController: UISearchController) {
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
            if texter.count > 0 {
              
                filteredUsers = suggestedUsers.filter( { ($0.namer.lowercased().contains(searchController.searchBar.text!.lowercased())) })
                self.tablerView.reloadData()
            }
                refresher = true
             
              
    
            }
            
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chosenChat")
            as! UINavigationController
        let dest = vc.viewControllers[0] as! ChosenChatViewController
        dest.theirName = filteredUsers[indexPath.row].namer
        dest.theirUid = filteredUsers[indexPath.row].uider
      
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
    ref.child("users").child(filteredUsers[indexPath.row].uider).child("blocked").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                print("blocked")
            } else {
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                    
                }
            }
        })
        }
       
            
        self.searchController.isActive = false
        self.searchController.dismiss(animated: true, completion: nil)
            
        self.tablerView.deselectRow(at: indexPath, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var dismisserler: UIBarButtonItem!
    @IBAction func dismisslyAct(_ sender: Any) {
       self.searchController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    var matched = [String]()
    func grabSuggested () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
                if let matchers = snapshot.value as? [String : AnyObject] {
                    
                    for (one,_) in matchers {
                        self.loadUser(uid: one)
                        self.matched.append(one)
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 80)
                    label.font = UIFont(name: "Futura", size: 18)
                    label.numberOfLines = 2
                    label.textAlignment = .center
                    label.text = "Connect with people to chat with them."
                    label.textColor = .black
                    self.view.addSubview(label)
                }
            })
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
                if self.suggestedUsers.contains( where: { $0.uider == newpUser.uider } ) || newpUser.uider == Auth.auth().currentUser?.uid {
                    print("no")
                } else {
                    self.suggestedUsers.append(newpUser)
                    reload = true
                    
                }
            }
            if reload == true {
            self.tablerView.reloadData()
            }
        })
    }
    
 
   
    
   
   
    
    
}
