//
//  SaveAnImageViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/16/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase


class SaveAnImageViewController: UIViewController {

    var from: String?
    var imager: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imagly = imager {
            self.imagerView.image = imagly
        }
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func postAct(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            if let photo = imagerView.image {
                let ref = Database.database().reference()
                   let key = ref.child("users").child(uid).child("profilePhotos").childByAutoId().key
                let storage = Storage.storage().reference().child(uid).child("userPhotos").child("photo\(key)")
                if let uploadData = UIImageJPEGRepresentation(photo, 0.6) {
                    storage.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                
                                  let ref = Database.database().reference()
                             
                              
                                    let feed = ["userID": uid,
                                                "url": imagerUrl,
                                                "creatorName" : Auth.auth().currentUser!.displayName!,
                                                "key": key,
                                                "timeStamp" : timeStamp] as [String : Any]
                                    
                                    
                                    
                                    let postFeed = ["\(key)" : feed]
                            
                                ref.child("users").child(uid).child("profilePhotos").updateChildValues(postFeed)
                                self.dismiss(animated: true, completion: nil)
                            }
                    })
                }
            
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
