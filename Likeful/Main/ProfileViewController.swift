//
//  ProfileViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scoreIcon: UIImageView!
    @IBOutlet weak var addStuffLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var labelNamer: UILabel!
    @IBOutlet weak var labelUsernamer: UILabel!
    @IBOutlet weak var theirUsernamelbl: UILabel!
    @IBOutlet weak var textViewName: UITextView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var buttonDaily: UIButton!
    @IBOutlet weak var labelDailyViewers: UILabel!
    
   
    
    @IBOutlet weak var changeProfilePhoto: UIButton!
    @IBAction func dizmisser(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    let activityer = UIActivityIndicatorView()
    
    
    override func viewWillLayoutSubviews() {
        
        
    }
   
    
    
    var photos = [Photo]()
  
 
    @IBOutlet weak var textViewer: UITextView!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionerView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewName.enablesReturnKeyAutomatically = false
        collectionerView.delegate = self
        collectionerView.dataSource = self
        saveButton.frame = CGRect(x: 50, y: self.view.frame.height / 2, width: self.view.frame.width - 100, height: 45)
        saveButton.backgroundColor = UIColor(red: 0, green: 0.4471, blue: 0.8392, alpha: 1.0)
        saveButton.layer.cornerRadius = 22.0
        saveButton.clipsToBounds = true
        saveButton.titleLabel?.font = UIFont(name: "Futura", size: 18)
        saveButton.setTitle("Done", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(exitText), for: .touchUpInside)
        saveButton.isHidden = true
        textViewName.textContainer.maximumNumberOfLines = 1
        textViewName.textContainer.lineBreakMode = .byTruncatingTail
        if self.view.frame.width <= 320 {
            saveButton.frame = CGRect(x: 50, y: self.view.frame.height / 3, width: self.view.frame.width - 100, height: 45)
        }
        labelNext.frame = CGRect(x: 50, y: self.view.frame.height / 2, width: self.view.frame.width - 60, height: 30)
        self.buttonAddOne.frame = CGRect(x: 5, y: self.view.frame.height / 2, width: self.view.frame.width - 100, height: 35)
        
        self.buttonAddOne.addTarget(self, action: #selector(self.addIg), for: .touchUpInside)
        self.view.addSubview(self.buttonAddOne)
        labelNext.font = UIFont(name: "Futura", size: 14)
        labelNext.textColor = UIColor(red: 0, green: 0.6431, blue: 0.898, alpha: 1.0)
        view.addSubview(self.labelNext)
        if let namer = Auth.auth().currentUser?.displayName {
            textViewName.text = namer
            
        }
        scoreLabel.frame = CGRect(x: self.view.frame.width - 160, y: 70, width: 135, height: 21)
        scoreIcon.frame = CGRect(x: self.view.frame.width - 22, y: 71, width: 15, height: 17)
        
        imagePicker.delegate = self
        
        self.topView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        
        collectionerView.frame = CGRect(x: 5, y: self.view.frame.height / 1.65, width: self.view.frame.width - 5, height: self.view.frame.width / 1.8)
        
        profileImageView.frame = CGRect(x: self.view.frame.width / 2.45, y: 78, width: 68, height: 68)
        backView.frame = CGRect(x: profileImageView.frame.origin.x - 2, y: 76, width: 72, height: 72)
        addStuffLabel.frame = CGRect(x: 16.0, y: self.view.frame.height / 1.75, width: self.view.frame.width - 50, height: 25)
        profileImageView.layer.cornerRadius = 34
        profileImageView.clipsToBounds = true
        backView.layer.cornerRadius = 35
        backView.clipsToBounds = true
        textViewName.frame = CGRect(x: 111, y: 178, width: 251, height: 37)
        textViewer.frame = CGRect(x: 64.0, y: 255, width: self.view.frame.width - 70, height: 70)
        print(textViewName.frame)
        bioLabel.frame = CGRect(x: 16, y: 263.0, width: 40, height: 21)
        labelNamer.frame = CGRect(x: 16, y: 186, width: 69, height: 21)
        theirUsernamelbl.frame = CGRect(x: 114.0, y: 222, width: 245, height: 21)
        labelUsernamer.frame = CGRect(x: 16.0, y: 222, width: 99, height: 21)
        self.addImageButton.frame = CGRect(x: self.view.frame.width / 2.3, y: self.view.frame.height - 60, width: 50, height: 50)
        labelDailyViewers.frame = CGRect(x: 5, y: 71, width: 142, height: 21)
        buttonDaily.frame = labelDailyViewers.frame
        
        if self.view.frame.width <= 320 {
            bioLabel.frame = CGRect(x: 16, y: 240, width: 40, height: 21)
            textViewer.frame =  CGRect(x: 64.0, y: 232, width: self.view.frame.width - 70, height: 70)
            labelNamer.frame = CGRect(x: 16, y: 168, width: 69, height: 21)
            theirUsernamelbl.frame = CGRect(x: 114.0, y: 204, width: 245, height: 21)
            labelUsernamer.frame = CGRect(x: 16.0, y: 204, width: 99, height: 21)
            textViewName.frame = CGRect(x: 111, y: 162, width: 251, height: 37)
            self.labelNext.frame = CGRect(x: 50, y: self.view.frame.height / 1.9, width: self.view.frame.width - 60, height: 30)
            self.addImageButton.frame = CGRect(x: self.view.frame.width / 2.3, y: self.view.frame.height - 50, width: 50, height: 50)
             scoreLabel.font = UIFont(name: "Futura", size: 16)
        }
        if self.view.frame.height == 812 {
            bioLabel.frame = CGRect(x: 16, y: 280, width: 40, height: 21)
            textViewer.frame =  CGRect(x: 64.0, y: 272, width: self.view.frame.width - 70, height: 70)
            labelNamer.frame = CGRect(x: 16, y: 208, width: 69, height: 21)
            theirUsernamelbl.frame = CGRect(x: 114.0, y: 244, width: 245, height: 21)
            labelUsernamer.frame = CGRect(x: 16.0, y: 244, width: 99, height: 21)
            textViewName.frame = CGRect(x: 111, y: 202, width: 251, height: 37)
            labelDailyViewers.frame = CGRect(x: 5, y: 89.5, width: 132, height: 21)
            buttonDaily.frame = labelDailyViewers.frame
            self.addImageButton.frame = CGRect(x: self.view.frame.width / 2.3, y: self.view.frame.height - 100, width: 50, height: 50)
            scoreLabel.frame = CGRect(x: self.view.frame.width - 200, y: 89.5, width: 170, height: 25)
            scoreIcon.frame = CGRect(x: self.view.frame.width - 22, y: 93, width: 15, height: 17)
            profileImageView.frame = CGRect(x: self.view.frame.width / 2.45, y: 98, width: 68, height: 68)
            backView.frame = CGRect(x: profileImageView.frame.origin.x - 2, y: 96, width: 72, height: 72)
            self.topView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180)
        }
        if self.view.frame.width == 414 {
            profileImageView.frame = CGRect(x: self.view.frame.width / 2.35, y: 78, width: 68, height: 68)
            backView.frame = CGRect(x: profileImageView.frame.origin.x - 2, y: 76, width: 72, height: 72)
        }
        
        activityer.frame = collectionerView.frame
        activityer.color = .black
        activityer.backgroundColor = UIColor(white: 1, alpha: 0.6)
        self.changeProfilePhoto.frame = backView.frame
        self.view.addSubview(self.activityer)
        profileImageView.image = UIImage(named: "profiler")
        view.addSubview(saveButton)
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            collectionerView.frame = CGRect(x: 5, y: self.view.frame.height / 1.4, width: self.view.frame.width - 5, height: self.view.frame.width / 2.5)
            addStuffLabel.frame = CGRect(x: 15, y: self.view.frame.height / 1.45, width: self.view.frame.width - 30, height: 20)
            
            self.labelNext.frame = CGRect(x: 35, y: self.view.frame.height / 1.6, width: self.view.frame.width - 35, height: 30)
            self.buttonAddOne.frame = CGRect(x: 5, y: self.view.frame.height / 1.6, width: self.view.frame.width - 100, height: 33)
             saveButton.frame = CGRect(x: 50, y: self.view.frame.height / 3.9, width: self.view.frame.width - 100, height: 45)
            
        }
      
        
        
        instagramAccount()
        grabDescript()
        grabYourPhotos()
        grabUsername()
       grabProfilePhoto()
        score()
        grabViewersCount()
        // Do any additional setup after loading the view.
    }
  
    let saveButton = UIButton()
   
    
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isHidden = false
        if textView == textViewer {
            self.currentTextField = "desc"
        } else if textView == textViewName {
            self.currentTextField = "name"
        }
        if self.textViewer.textColor != UIColor.black {
        self.textViewer.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if textView == textViewName {
            return numberOfChars < 30
        }
        return numberOfChars < 105
    }
    var currentTextField: String?
    var descriptor: String?
    @objc func exitText () {
        if let currentTextfield = self.currentTextField {
            if currentTextfield == "name" {
                print("name")
                if textViewName.text != "" {
                    if textViewName.text != Auth.auth().currentUser?.displayName {
                self.textViewName.resignFirstResponder()
                self.saveButton.isHidden = true
                self.checkIfClean(string: textViewName.text, from: "name")
                        print("clean")
                    } else {
                        self.textViewName.resignFirstResponder()
                        self.saveButton.isHidden = true
                        print("already")
                    }
                }
            }
            else {
              
                if textViewer.text != "" {
                    if let previousdesc = self.descriptor {
                        if textViewer.text != previousdesc {
                self.textViewer.resignFirstResponder()
                self.saveButton.isHidden = true
                self.checkIfClean(string: textViewer.text, from: "description")
                        } else {
                            self.textViewer.resignFirstResponder()
                            self.saveButton.isHidden = true
                            
                        }
                        
                    } else {
                        self.textViewer.resignFirstResponder()
                        self.saveButton.isHidden = true
                        self.checkIfClean(string: textViewer.text, from: "description")
                    }
                }
            }
            
       
        }
    }
    
    
    
    func grabDescript () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("description").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    self.textViewer.text = snapshot.value as? String
                    self.descriptor = snapshot.value as? String
                } else {
                    
                   self.descriptor = "Tap to add a bio..."
                   self.textViewer.textColor = UIColor.lightGray
                    
                }
            })
        }
    }
    
    //**** username
    func grabUsername () {
        if let mySavedUn = UserDefaults.standard.value(forKey: "username") as? String {
            self.theirUsernamelbl.text = mySavedUn
        } else {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    if let theUsernm = snapshot.value as? String {
                   self.theirUsernamelbl.text = theUsernm
                        UserDefaults.standard.set(theUsernm, forKey: "username")
                    }
                }
            })
        }
        }
    }
    
    
    // *** profile photo
    func grabProfilePhoto () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("profileUrl").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    if let imager = snapshot.value as? String {
                        let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
                        self.profileImageView.kf.indicatorType = .activity
                        self.profileImageView.kf.setImage(with: restource)
                    }
                }
            })
        }
    }
    
    // ** imagers
    func grabYourPhotos () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("profilePhotos").observeSingleEvent(of: .value, with: {(snapshot) in
                if let photolers = snapshot.value as? [String : AnyObject] {
                    for (un, uno) in photolers {
                        let newPhoto = Photo()
                        newPhoto.key = un
                        newPhoto.photoUrl = uno as? String
                        self.photos.append(newPhoto)
                    }
                    self.collectionerView.reloadData()
                } else {
                 
                }
            }, withCancel: nil)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if ( UIDevice.current.model.range(of: "iPad") != nil){
               return CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
        }
        return CGSize(width: self.view.frame.width / 2, height: self.view.frame.width / 2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "cellProfile", for: indexPath) as! ProfileCollectionViewCell
       
         cell.imagerView.frame = CGRect(x: 0, y: 0, width: cell.frame.width , height: cell.frame.height)
        
        if let imager = photos[indexPath.row].photoUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            
            cell.imagerView.kf.setImage(with: restource)
        } else {
            cell.imagerView.image = nil
        }
      
       
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var addImageButton: UIButton!
    @IBAction func addPhotoAct(_ sender: Any) {
        if photos.count < 4 {
        self.imagePicker.delegate = self
        let buoty = UIButton()
        buoty.frame = CGRect(x: self.view.frame.width - 50, y: 1, width: 40, height: 40)
        buoty.setImage(#imageLiteral(resourceName: "albumo"), for: .normal)
        buoty.backgroundColor = .clear
        self.imagePicker.view.addSubview(buoty)
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        buoty.addTarget(self, action: #selector(photoLibraryAction), for: .touchUpInside)
        
        
        self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func photoLibraryAction () {
        self.imagePicker.dismiss(animated: false, completion: nil)
        
        let imgPick = UIImagePickerController()
        imgPick.delegate = self
        imgPick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(imgPick, animated: false, completion: {
            
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if profiler == true {
            postPhoto(photo: selectedImage, from: "profile")
          
        profileImageView.image = selectedImage
            profiler = false
        } else {
           
            
            postPhoto(photo: selectedImage, from: "add")
        }
        
        
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    // ********** Post action
    func postPhoto(photo: UIImage, from: String) {
        if let uid = Auth.auth().currentUser?.uid {
            if from == "profile" {
                let pictureRef = Storage.storage().reference().child(uid).child("profile.jpg")
                pictureRef.delete { error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        // File deleted successfully
                    }
                }
                let storage = Storage.storage().reference().child(uid).child("profile.jpg")
                if let uploadData = UIImageJPEGRepresentation(photo, 0.34) {
                    storage.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                            
                                let ref = Database.database().reference()
                                let postFeed = ["profileUrl" : imagerUrl]
                                ref.child("users").child(uid).updateChildValues(postFeed)
                            }
                    })
                }
            } else if from == "add" {
                self.activityer.startAnimating()
                let ref = Database.database().reference()
                let randomString = NSUUID().uuidString
                let storage = Storage.storage().reference().child(uid).child("userPhotos").child("photo\(randomString)")
                if let uploadData = UIImageJPEGRepresentation(photo, 0.42) {
                    storage.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            if let imagerUrl = metadata?.downloadURL()?.absoluteString {
                               
                                let newPhoto = Photo()
                                newPhoto.key = randomString
                                newPhoto.photoUrl = imagerUrl
                                self.photos.append(newPhoto)
                                print(randomString)
                                let postFeed = [randomString : imagerUrl]
                                print(self.photos)
                                self.collectionerView.reloadData()
                                self.activityer.stopAnimating()
                                ref.child("users").child(uid).child("profilePhotos").updateChildValues(postFeed)
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
                    })
                }
            }
            
            
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alerto = UIAlertController(title: "Delete Image?", message: "Click delete to remove this image from your profile", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Delete", style:.default, handler: { (alert : UIAlertAction) in
            
           
            let ref = Database.database().reference()
            if let uid = Auth.auth().currentUser?.uid {
                let storage = Storage.storage().reference().child(uid).child("userPhotos").child("photo\(self.photos[indexPath.row].key!)")
                
                storage.delete { error in
                    if let error = error {
                        print(error)
                        
                        
                    } else {
                        // File deleted successfully
                    }
                }
                
            ref.child("users").child(uid).child("profilePhotos").child(self.photos[indexPath.row].key).removeValue()
            }
             self.photos.remove(at: indexPath.row)
            self.collectionerView.reloadData()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerto.addAction(ok)
        alerto.addAction(cancel)
        self.present(alerto, animated: true, completion: nil)
    }
    var profiler = false
    @IBAction func changeImageActor(_ sender: Any) {
        profiler = true
        self.imagePicker.delegate = self
        let buoty = UIButton()
        buoty.frame = CGRect(x: self.view.frame.width - 50, y: 1, width: 40, height: 40)
        buoty.setImage(#imageLiteral(resourceName: "albumo"), for: .normal)
        buoty.backgroundColor = .clear
        self.imagePicker.view.addSubview(buoty)
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        buoty.addTarget(self, action: #selector(photoLibraryAction), for: .touchUpInside)
        
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    let buttonAddOne = UIButton()
     let buttonAdd = UIImageView()
      let labelNext = UILabel()
    func instagramAccount () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("instagramAccount").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    self.labelNext.text = "• Instagram: \(snapshot.value as! String)"
                    self.labelNext.frame = CGRect(x: 18, y: self.view.frame.height / 2, width: self.view.frame.width - 30, height: 30)
                      self.labelNext.font = UIFont(name: "Futura", size: 16)
                    self.usernamerIg = snapshot.value as? String
                    if self.view.frame.width == 320 {
                        self.labelNext.frame = CGRect(x: 15, y: self.view.frame.height / 1.9, width: self.view.frame.width - 60, height: 30)
                    }
                       if ( UIDevice.current.model.range(of: "iPad") != nil){
                            self.labelNext.frame = CGRect(x: 18, y: self.view.frame.height / 1.6, width: self.view.frame.width - 30, height: 30)
                    }
                } else {
               
                    self.buttonAdd.frame = CGRect(x: 15, y: self.view.frame.height / 2, width: 30, height: 30)
                    self.buttonAdd.image = #imageLiteral(resourceName: "instagramdd")
                    if self.view.frame.width == 320 {
                          self.buttonAdd.frame = CGRect(x: 15, y: self.view.frame.height / 1.9, width: 30, height: 30)
                    }
                      if ( UIDevice.current.model.range(of: "iPad") != nil){
                         self.buttonAdd.frame = CGRect(x: 5, y: self.view.frame.height / 1.6, width: 30, height: 30)
                        
                    }
                  self.view.addSubview(self.buttonAdd)
                  self.labelNext.text = "Add your instagram account"
                  
                    
                   
                }
            })
        }
        
    }
    
    var usernamerIg: String?

 
    @objc func addIg () {
      
        let alerto = UIAlertController(title: "Add instagram account", message: "Help others know that its you by including your instagram. Type in your instagram username.", preferredStyle: .alert)
        alerto.addTextField(configurationHandler: { (textField : UITextField) in
            if Auth.auth().currentUser?.displayName != nil {
                textField.placeholder = "Enter your instagram username..."
                if let usernamerl = self.usernamerIg {
                    textField.text = usernamerl
                }
            }
            
        })
        let actor = UIAlertAction(title: "Done", style: .default, handler: { (alert : UIAlertAction) in
            
            if let texter = alerto.textFields?[0].text {
                if texter.count == 0 {
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid {
                        ref.child("users").child(uid).child("instagramAccount").removeValue()
                        self.labelNext.frame = CGRect(x: 50, y: self.view.frame.height / 2, width: self.view.frame.width - 60, height: 30)
                        
                        self.buttonAdd.frame = CGRect(x: 15, y: self.view.frame.height / 2, width: 30, height: 30)
                        if self.view.frame.width == 320 {
                            self.labelNext.frame = CGRect(x: 50, y: self.view.frame.height / 1.9, width: self.view.frame.width - 60, height: 30)
                            
                            self.buttonAdd.frame = CGRect(x: 15, y: self.view.frame.height / 1.9, width: 30, height: 30)
                        }
                        if ( UIDevice.current.model.range(of: "iPad") != nil){
                            
                                self.buttonAdd.frame = CGRect(x: 5, y: self.view.frame.height / 1.6, width: 30, height: 30)
                              self.labelNext.frame = CGRect(x: 45, y: self.view.frame.height / 1.6, width: self.view.frame.width - 60, height: 30)
                        }
                        
                        self.buttonAdd.image = #imageLiteral(resourceName: "instagramdd")
                        self.buttonAdd.isHidden = false
                        self.labelNext.text = "Add your instagram account"
                        self.view.addSubview(self.buttonAdd)
                        self.usernamerIg = ""
                    }
                } else if texter.count > 3 && texter.count < 32 {
                    let feed = ["instagramAccount" : texter]
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid {
                    ref.child("users").child(uid).updateChildValues(feed)
                       
                        self.buttonAdd.isHidden = true
                        self.labelNext.text = "• Instagram: \(texter)"
                        self.usernamerIg = texter
                        self.labelNext.frame = CGRect(x: 18, y: self.view.frame.height / 2, width: self.view.frame.width - 30, height: 30)
                    self.labelNext.font = UIFont(name: "Futura", size: 16)
                        if self.view.frame.width == 320 {
                            self.labelNext.frame = CGRect(x: 15, y: self.view.frame.height / 1.9, width: self.view.frame.width - 60, height: 30)
                        }
                        if ( UIDevice.current.model.range(of: "iPad") != nil){
                            self.labelNext.frame = CGRect(x: 35, y: self.view.frame.height / 1.6, width: self.view.frame.width - 35, height: 30)
                        }
                    }
                    }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerto.addAction(actor)
        alerto.addAction(cancel)
        self.present(alerto, animated: true, completion: nil)
        
    }
    
  
    
    
    func checkIfClean(string: String, from: String) {
        if string.count > 3 {
            if  string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/") || string.contains("hate") || string.contains("\\") || string.contains("\"") ||  string.contains("porn") || string.contains("sex") || string.contains("nigger") || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("klux") || string.contains("kkk") || string.contains("nigga")
                
            {
               
            } else {
                
                if from == "name" {
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    let ref = Database.database().reference()
                    if let currentUser = Auth.auth().currentUser?.uid {
                        changeRequest.displayName = string
                        changeRequest.commitChanges(completion: nil)
                        
                        
                        let newTitle = ["name" : string]
                        ref.child("users").child(currentUser).updateChildValues(newTitle)
                    }
                } else if from == "description" {
                    let newDest = ["description" : string]
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        ref.child("users").child(uid).updateChildValues(newDest)
                        self.descriptor = string
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
}
    
    func score () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
           ref.child("users").child(uid).child("score").observeSingleEvent(of: .value, with: {(snapy) in
            if let score = snapy.value as? Int {
                ref.child("users").child(uid).child("increased").observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists() {
                        self.scoreLabel.text = "Score • \(score)"
                        self.scoreLabel.textColor = UIColor(red: 0, green: 0.7176, blue: 0.2275, alpha: 1.0)
                        self.scoreIcon.image = #imageLiteral(resourceName: "increased")
                        ref.child("users").child(uid).child("increased").removeValue()
                        ref.child("users").child(uid).child("newMatch").observeSingleEvent(of: .value, with: {(snapful)
                            in
                            if snapful.exists() {
                                let newsc = score + 100
                                let anotherUpd = ["score" : newsc]
                                ref.child("users").child(uid).updateChildValues(anotherUpd)
                                ref.child("users").child(uid).child("newMatch").removeValue()
                                 self.scoreLabel.text = "Score • \(newsc)"
                            }
                        })
                    } else {
                        ref.child("users").child(uid).child("decreased").observeSingleEvent(of: .value, with: {(snap) in
                            if snap.exists() {
                                self.scoreLabel.text = "Score • \(score)"
                                self.scoreLabel.textColor = .red
                                self.scoreIcon.image = #imageLiteral(resourceName: "decreased")
                                ref.child("users").child(uid).child("decreased").removeValue()
                            } else {
                                self.scoreLabel.text = "Score • \(score)"
                                self.scoreLabel.textColor = .gray
                                self.scoreIcon.isHidden = true
                                self.scoreLabel.textAlignment = .right
                                self.scoreLabel.frame = CGRect(x: self.view.frame.width - 160, y: 70, width: 152, height: 21)
                                if self.view.frame.height == 812 {
                                    self.scoreLabel.frame = CGRect(x: self.view.frame.width - 160, y: 93, width: 152, height: 21)
                                }
                            }
                        })
                    }
                })
               
            }
           })
        }
    }
    func grabViewersCount () {
        var counters = [String]()
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("dailyViews").observeSingleEvent(of: .value, with: {(snapshot) in
                if let dailies = snapshot.value as? [String : AnyObject] {
                    for (one, each) in dailies {
                        if let interr = each as? Int {
                            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
                            if timeNow - interr < 86400 {
                                
                                counters.append(one)
                                
                            } else {
                                ref.child("users").child(uid).child("dailyViews").child(one).removeValue()
                            }
                        }
                    }
                    self.labelDailyViewers.text = "Daily Views • \(counters.count)"
                } else {
                    self.labelDailyViewers.text = "Daily Views"
                }
            })
        }
    }
    
    
    
    
}



