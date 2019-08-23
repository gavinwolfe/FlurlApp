//
//  SettingsViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var essentials = ["Password", "Blocked Users", "Privacy Policy", "Terms of Service", "Report a problem", "Contact Us" , "About Flurl", "App Settings/Permissions", "Private Account", "Share Flurl"]
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        tablerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height  - 64)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))

        tablerView.delegate = self
        tablerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return essentials.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSettings", for: indexPath) as! SettingsTableViewCell
        cell.mainLabel.text = essentials[indexPath.row]
        cell.mainLabel.frame = CGRect(x: 15, y: 20, width: self.view.frame.width - 20, height: 30)
        if indexPath.row == 10 {
            cell.mainLabel.textColor = .blue
        } else if indexPath.row == 0 {
            cell.mainLabel.textColor = .black
        } else if indexPath.row != 0 || indexPath.row != 10 {
             cell.mainLabel.textColor = .black
        }
        return cell
    }
    
    @objc func logout () {
        let alerto = UIAlertController(title: "Logout", message: "Sign out of your account?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Logout", style: .default, handler: { (action : UIAlertAction)
            in
            self.signOut()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpOrLogin")
            self.present(vc, animated: true, completion: nil)
        })
        let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerto.addAction(action)
        alerto.addAction(canceler)
        self.present(alerto, animated: true, completion: nil)
      
    }
    func signOut () {
        if Auth.auth().currentUser?.uid != nil {
            do {
                try! Auth.auth().signOut()
                print("logged out")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueInSettings" {
           let index = tablerView.indexPathForSelectedRow!
            if index.row == 2 {
                return false
            }
            if index.row == 3 {
                return false
            }
            if index.row == 9 {
                return false
            }
            
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueInSettings" {
            let dest = segue.destination as! InsideSettingsViewController
            let index = tablerView.indexPathForSelectedRow!
            dest.indexLor = index
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {

            UIApplication.shared.open(URL(string:"https://www.berlark.com/flurl-privacy")!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 3 {
           UIApplication.shared.open(URL(string:"https://www.berlark.com/flurl-terms-of-service")!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 9 {
            let activityVc = UIActivityViewController(activityItems: ["https://itunes.apple.com/us/app/flurl/id1335278755?mt=8"], applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = self.view
             DispatchQueue.main.async {
            self.present(activityVc, animated: true, completion: nil)
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
