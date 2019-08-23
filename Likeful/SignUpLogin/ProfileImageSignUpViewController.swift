//
//  ProfileImageSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ProfileImageSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var backView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        print(addButton.frame)
       // furtherBackView.frame = CGRect(x: self.view.frame.width / 2.5, y: 72, width: 68, height: 68)
       
        imagerView.frame = CGRect(x: self.view.frame.width / 2.55, y: 78, width: 70, height: 70)
        backView.frame = CGRect(x: imagerView.frame.origin.x - 2, y: 76, width: 74, height: 74)
        //(62.0, 158.0, 250.0, 52.0)
        addButton.frame = CGRect(x: 62, y: 158, width: self.view.frame.width - 124, height: 52)
        if self.view.frame.width == 320 {
                addButton.frame = CGRect(x: 32, y: 158, width: self.view.frame.width - 64, height: 52)
        }

        if self.view.frame.width == 375 {
            imagerView.frame = CGRect(x: self.view.frame.width / 2.47, y: 78, width: 70, height: 70)
             backView.frame = CGRect(x: imagerView.frame.origin.x - 2, y: 76, width: 74, height: 74)
        }
    addButton.layer.cornerRadius = 6.0
        
       skipButton.frame = CGRect(x: 50, y: self.view.frame.height - 60, width: self.view.frame.width - 100, height: 30)
        backView.layer.cornerRadius = 37
        imagerView.layer.cornerRadius = 35.0
        imagerView.clipsToBounds = true
        backView.clipsToBounds = true
        addButton.clipsToBounds = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Profile Photo"
        if self.view.frame.height == 812 {
            imagerView.frame = CGRect(x: self.view.frame.width / 2.47, y: 98, width: 70, height: 70)
            backView.frame = CGRect(x: imagerView.frame.origin.x - 2, y: 96, width: 74, height: 74)
            addButton.frame = CGRect(x: 62, y: 188, width: self.view.frame.width - 124, height: 52)
        }
        if self.view.frame.width == 414 {
            imagerView.frame = CGRect(x: self.view.frame.width / 2.35, y: 78, width: 68, height: 68)
            backView.frame = CGRect(x: imagerView.frame.origin.x - 2, y: 76, width: 72, height: 72)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
    }
    let imagePicker = UIImagePickerController()
    @IBAction func addAction(_ sender: Any) {
       
        imagePicker.delegate = self
        let pageAlert = UIAlertController(title: "Add Profile Photo", message: "Choose a way to add a profile photo", preferredStyle: UIAlertControllerStyle.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(cancel)
          DispatchQueue.main.async {
        self.present(pageAlert, animated: true, completion: nil)
        }
    }
  
    var tookPhoto = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
      imagerView.image = selectedImage
     addButton.setTitle("Change Image", for: .normal)
        skipButton.setTitle("Done", for: .normal)
        tookPhoto = true
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    
    var once = false
    @IBAction func skipAct(_ sender: Any) {
        if once == false {
            once = true
        if self.tookPhoto == true {
        if imagerView.image != nil {
            if let uid = Auth.auth().currentUser?.uid {
             let storage = Storage.storage().reference().child(uid).child("profile.jpg")
                if let uploadData = UIImageJPEGRepresentation(self.imagerView.image!, 0.34) {
                    storage.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                        if error != nil {
                            print(error!)
                            self.once = false
                            return
                        }
                        if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                            let ref = Database.database().reference()
                              let postFeed = ["profileUrl" : imagerUrl]
                            ref.child("users").child(uid).updateChildValues(postFeed)
                            let vc = self.view.window!.rootViewController as! UITabBarController
                            let dvc = vc.viewControllers![0] as! UINavigationController
                            let dvcv = dvc.viewControllers[0] as! ViewController
                            self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                                dvcv.dothingis()
                                let appDel = AppDelegate()
                                appDel.callNotifs()
                            })
                           
                        }
                    })
                }
        }
       
        }
        }
        else {
            let vc = self.view.window!.rootViewController as! UITabBarController
            let dvc = vc.viewControllers![0] as! UINavigationController
            let dvcv = dvc.viewControllers[0] as! ViewController
            self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                dvcv.dothingis()
                let appDel = AppDelegate()
                appDel.callNotifs()
            })
        }
        }
    }
    
}
