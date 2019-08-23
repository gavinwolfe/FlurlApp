//
//  SavedChatsViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/11/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SavedChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var theirId: String?
    var chatters = [Message]()
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Saved Messages"
         self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 22)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        tablerView.delegate = self
        tablerView.dataSource = self
        self.tablerView.frame = CGRect(x: 2, y: 70, width: self.view.frame.width - 4, height: self.view.frame.height - 70)
        grabChats()
        // Do any additional setup after loading the view.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSaved", for: indexPath) as! SavedTableViewCell
        if chatters[indexPath.row].sender == theirId {
            
            cell.mainLabel.frame = CGRect(x: 10, y: 5, width: 210, height: cell.frame.height - 10)
            cell.backView.frame = CGRect(x: 5, y: 5, width: 220, height: cell.frame.height - 10)
            cell.mainLabel.backgroundColor = UIColor(red: 0.9294, green: 0.9333, blue: 0.9373, alpha: 1.0)
            cell.backView.backgroundColor =  UIColor(red: 0.9294, green: 0.9333, blue: 0.9373, alpha: 1.0)
            cell.mainLabel.textColor = UIColor.black
        } else {
            
            cell.mainLabel.frame = CGRect(x: cell.frame.width - 220, y: 5, width: 210, height: cell.frame.height - 10)
            cell.backView.frame = CGRect(x: cell.frame.width - 225, y: 5, width: 220, height: cell.frame.height - 10)
            cell.mainLabel.backgroundColor = UIColor(red: 0, green: 0.7569, blue: 0.9098, alpha: 1.0)
            cell.backView.backgroundColor = UIColor(red: 0, green: 0.7569, blue: 0.9098, alpha: 1.0)
            cell.mainLabel.textColor = .white
            
        }
        cell.mainLabel.text = chatters[indexPath.row].messager
        
        
        cell.mainLabel.textAlignment = .center
        
        cell.mainLabel.layer.cornerRadius = 8.0
        cell.mainLabel.clipsToBounds = true
        
        cell.backView.layer.cornerRadius = 8.0
        cell.backView.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if chatters.count != 0 {
            if chatters[indexPath.row].messager.count > 26 && chatters[indexPath.row].messager.count < 48 {
                return 70
            }
            if chatters[indexPath.row].messager.count >= 48 {
                return 82
            }
        }
        return 50
    }
    
    func grabChats () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let theirId = theirId {
        ref.child("users").child(uid).child("chats").child(theirId).child("savedMessages").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            if let savedChats = snapshot.value as? [String : AnyObject] {
                for (_, one) in savedChats {
              
                    if let timeStampl = one["timeStamp"] as? Int, let messager = one["message"] as? String, let keyer = one["key"] as? String, let sendler = one["sender"] as? String {
                              print("okk")
                        let newMess = Message()
                        newMess.timeStamp = timeStampl
                        newMess.messager = messager
                        newMess.key = keyer
                        newMess.sender = sendler
                       if self.chatters.contains( where: { $0.key == keyer } ) {
                        
                       } else {
                        self.chatters.append(newMess)
                         self.chatters.sort { $1.timeStamp > $0.timeStamp }
                        }
                            
                    }
                }
                self.tablerView.reloadData()
               
            } else {
                let label = UILabel()
                label.frame = CGRect(x: 15, y: 100, width: self.view.frame.width - 30, height: 40)
                label.font = UIFont(name: "Futura", size: 16)
                label.textAlignment = .center
                label.text = "You do not have any saved messages"
                label.textColor = .black
                self.view.addSubview(label)
            }
        })
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uidd = Auth.auth().currentUser?.uid
        if let uid = uidd {
            if let theirId = self.theirId {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                let ref = Database.database().reference()
           ref.child("users").child(uid).child("chats").child(theirId).child("savedMessages").child(chatters[indexPath.row].key).removeValue()
                self.chatters.remove(at: indexPath.row)
                self.tablerView.reloadData()
                if self.chatters.count == 0 {
                    let label = UILabel()
                    label.frame = CGRect(x: 15, y: 100, width: self.view.frame.width - 30, height: 40)
                    label.font = UIFont(name: "Futura", size: 16)
                    label.textAlignment = .center
                    label.text = "You do not have any saved messages"
                    label.textColor = .black
                    self.view.addSubview(label)
                }
            }
        }
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissly(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    

}
