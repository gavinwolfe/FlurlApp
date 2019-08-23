//
//  InboxViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/11/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var notifications = [Notif]()
    
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tablerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112)
        grabNotifs()
        self.navigationItem.title = "Inbox"
        self.navigationController?.navigationBar.tintColor = .black
        tablerView.delegate = self
        tablerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellInbox", for: indexPath) as! InboxTableViewCell
        if let urler = notifications[indexPath.row].theirProfileUrl {
            let restource = ImageResource(downloadURL: URL(string: urler)!, cacheKey: urler)
            
            cell.imagerView.kf.setImage(with: restource)
        } else {
            cell.imagerView.image = #imageLiteral(resourceName: "libraryButton")
        }
        
        
        cell.imagerView.layer.cornerRadius = 25.0
        cell.imagerView.clipsToBounds = true
        cell.backView.layer.cornerRadius = 27.0
        cell.backView.clipsToBounds = true
        cell.furtherBackView.layer.cornerRadius = 29.0
        cell.furtherBackView.clipsToBounds = true
        
        cell.subLabel.text = notifications[indexPath.row].content
        cell.labelMain.text = notifications[indexPath.row].theirName
        
        cell.unseenView.frame = CGRect(x: cell.frame.width - 36, y: cell.frame.height / 2.3, width: 14, height: 14)
        cell.unseenView.layer.cornerRadius = 7.0
       
        if self.notifications[indexPath.row].usernamel != "none" {
            
        } else {
             cell.labelMain.text = notifications[indexPath.row].content
            cell.subLabel.text = "- Slide to delete"
            cell.imagerView.layer.cornerRadius = 2.0
            cell.imagerView.clipsToBounds = true
            cell.backView.layer.cornerRadius = 4.0
            cell.backView.clipsToBounds = true
            cell.furtherBackView.layer.cornerRadius = 6.0
            cell.furtherBackView.clipsToBounds = true
        }
        
        if let unseener = notifications[indexPath.row].unseen {
            print(unseener)
            if unseener != "" {
                cell.unseenView.backgroundColor = UIColor(red: 1, green: 0.298, blue: 0, alpha: 1.0)
            }
            
        } else {
            cell.unseenView.backgroundColor = .clear
        }
        
        cell.labelMain.frame = CGRect(x: 78, y: 12, width: self.view.frame.width - 95, height: 22)
        cell.subLabel.frame = CGRect(x: 78, y: 36, width: self.view.frame.width - 75, height: 20)
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func grabNotifs () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
        ref.child("users").child(uid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            if let notificationers = snapshot.value as? [String : AnyObject] {
                for (_, val) in notificationers {
                    if let contenter = val["content"] as? String, let theirNamer = val["theirName"] as? String, let theirUider = val["shareId"] as? String, let timesamper = val["timeStamp"] as? Int, let keyer = val["key"] as? String, let usernamrl = val["theirUsername"] as? String {
                        let newNotif = Notif()
                        if let urlert = val["theirUrl"] as? String {
                            newNotif.theirProfileUrl = urlert
                        }
                        if let unseener = val["unseen"] as? String {
                            newNotif.unseen = unseener
                        }
                        newNotif.usernamel = usernamrl
                        newNotif.key = keyer
                        newNotif.theirUid = theirUider
                        newNotif.theirName = theirNamer
                        newNotif.content = contenter
                        newNotif.timeStamp = timesamper
                        
                        if self.notifications.contains( where: { $0.key ==  newNotif.key } ) {
                            
                        } else {
                           
                        self.notifications.append(newNotif)
                             self.notifications.sort { $1.timeStamp < $0.timeStamp }
                        }
                    }
                }
                self.tablerView.reloadData()
            } else {
                let label = UILabel()
                label.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 80)
                label.font = UIFont(name: "Futura", size: 18)
                label.numberOfLines = 3
                label.textAlignment = .center
                label.text = "Users shared with you and likes on posts, will show up here."
                label.textColor = .black
                let imager = UIButton()
                imager.frame = CGRect(x: self.view.frame.width / 2.45, y: 230, width: 70, height: 70)
                imager.setImage(#imageLiteral(resourceName: "inboxey.png"), for: .normal)
                
                imager.layer.cornerRadius = 35
                imager.clipsToBounds = true
                imager.backgroundColor = UIColor(red: 0, green: 0.5922, blue: 0.8275, alpha: 1.0)
                self.view.addSubview(imager)
                self.view.addSubview(label)
            }
            
        })
        }
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVc") as! UserViewController
        
        vc.id = notifications[indexPath.row].theirUid
        vc.namer = notifications[indexPath.row].theirName
        vc.userName = notifications[indexPath.row].usernamel
        
        let celler = tablerView.cellForRow(at: indexPath) as! InboxTableViewCell
        vc.imagel = celler.imagerView.image
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if let notSeener = notifications[indexPath.row].unseen {
            let lipto = tablerView.cellForRow(at: indexPath) as! InboxTableViewCell
            lipto.backgroundColor = .clear
            notifications[indexPath.row].unseen = nil
            tablerView.reloadRows(at: [indexPath], with: .automatic)
            let ref = Database.database().reference()
            if let uid = Auth.auth().currentUser?.uid {
                ref.child("users").child(uid).child("Notifications").child(notifications[indexPath.row].key).child("unseen").removeValue()
            }
            print(notSeener)
        }
        if notifications[indexPath.row].usernamel != "none" {
        DispatchQueue.main.async {
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uidd = Auth.auth().currentUser?.uid
        if let uid = uidd {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
               let ref = Database.database().reference()
                ref.child("users").child(uid).child("Notifications").child(notifications[indexPath.row].key).removeValue()
                self.notifications.remove(at: indexPath.row)
                self.tablerView.reloadData()
            }
        }
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
