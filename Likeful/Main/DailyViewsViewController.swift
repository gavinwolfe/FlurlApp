//
//  DailyViewsViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 2/23/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class DailyViewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var viewers = [Userly]()
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tablerView.frame = CGRect(x: 0, y: 135, width: self.view.frame.width, height: self.view.frame.height - 185)
        self.topLabel.frame = CGRect(x: 28, y: 75, width: self.view.frame.width - 56, height: 52)
        print(topLabel.frame)
        print(tablerView.frame)
        self.grabViewers()
        tablerView.delegate = self
        tablerView.dataSource = self
        self.navigationItem.title = "Daily Views"
        if self.view.frame.height == 812 {
            self.tablerView.frame = CGRect(x: 0, y: 155, width: self.view.frame.width, height: self.view.frame.height - 185)
            self.topLabel.frame = CGRect(x: 28, y: 95, width: self.view.frame.width - 56, height: 52)
        }
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellDaily", for: indexPath) as! DailyViewersTableViewCell
        cell.mainLabel.text = "• \(viewers[indexPath.row].namer!)"
        return cell
    }
    
    
    func grabViewers () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("dailyViews").observeSingleEvent(of: .value, with: {(snapshot) in
                if let dailies = snapshot.value as? [String : AnyObject] {
                    for (one, each) in dailies {
                        if let interr = each as? Int {
                            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                            if timeNow - interr < 86400 {
                                self.loadUser(uid: one)
                            } else {
                                ref.child("users").child(uid).child("dailyViews").child(one).removeValue()
                            }
                        }
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 15, y: 250, width: self.view.frame.width - 30, height: 40)
                    label.numberOfLines = 2
                    label.font = UIFont(name: "Futura", size: 18)
                    label.textAlignment = .center
                    label.text = "No views today"
                    label.textColor = .black
                    self.view.addSubview(label)
                    let imager = UIButton()
                    imager.frame = CGRect(x: self.view.frame.width / 2.45, y: 300, width: 70, height: 70)
                    imager.setImage(#imageLiteral(resourceName: "noViews"), for: .normal)
                    self.view.addSubview(imager)
                }
            })
        }
    }
    
    func loadUser(uid: String) {
        let ref = Database.database().reference()
      
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? [String : AnyObject]
                if let namert = value?["name"] as? String, let uidi = value?["uid"] as? String {
                    let newUser = Userly()
                    newUser.namer = namert
                    newUser.uider = uidi
                   if self.viewers.contains( where: { $0.uider == newUser.uider } ) || newUser.uider == Auth.auth().currentUser?.uid {
                    } else {
                    self.viewers.append(newUser)
                    }
                }
                self.tablerView.reloadData()
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
