//
//  UserImagesViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/3/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class UserImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let labelWhere = UILabel()
    var should: String?
    var image1: String?
    var namly: String?
    var imagers = [Photo]()
    var theirId: String? 
    let activityer = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image1 = self.image1 {
            print("\(image1) ttottititit")
            let newpotot = Photo()
            newpotot.photoUrl = image1
            self.imagers.append(newpotot)
            self.collectionerView.reloadData()
            if let uider = theirId {
                grabPhotos(uid: uider)
                self.activityer.startAnimating()
            }
        }
       
        labelWhere.frame = CGRect(x: 50, y: self.view.frame.height - 80, width: self.view.frame.width - 100, height: 25)
        if self.view.frame.height == 812 {
            labelWhere.frame = CGRect(x: 50, y: self.view.frame.height - 105, width: self.view.frame.width - 100, height: 25)
        }
        labelWhere.textColor = .black
        labelWhere.font = UIFont(name: "Futura", size: 16)
        labelWhere.textAlignment = .center
        self.view.addSubview(labelWhere)
        if let shoulder = self.should {
            print(shoulder)
        addScores()
        }
        grabInstagramAccount()
        
        if let namer = namly {
            self.navigationItem.title = namer
        }
        collectionerView.clipsToBounds = false
        collectionerView.frame = CGRect(x: 0, y: 110, width: self.view.frame.width, height: self.view.frame.height - 200)
        collectionerView.delegate = self
        collectionerView.dataSource = self
        activityer.frame = collectionerView.frame
        activityer.color = .black
        activityer.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.addSubview(activityer)
        activityer.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    func addScores () {
        if let uid = Auth.auth().currentUser?.uid {
            if let theirid = self.theirId {
                let ref = Database.database().reference()
                ref.child("users").child(theirid).child("score").observeSingleEvent(of: .value, with: {(snap) in
                    if let score = snap.value as? Int {
                        let newScore = score + 1
                        let feedi = ["score" : newScore]
                        ref.child("users").child(theirid).updateChildValues(feedi)
                        let incress = ["increased" : "increased"]
                        ref.child("users").child(theirid).updateChildValues(incress)
                    }
                })
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
  
    func grabPhotos (uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("profilePhotos").observeSingleEvent(of: .value, with: {(snapshot) in
            if let theirPhotos = snapshot.value as? [String : AnyObject] {
                self.labelWhere.text = "1/\(theirPhotos.count + 1)"
                for (_,one) in theirPhotos {
                    let newPhoto = Photo()
                    newPhoto.photoUrl = one as? String
                    self.imagers.append(newPhoto)
                }
                
                self.collectionerView.reloadData()
            } else {
                self.activityer.stopAnimating()
//                let label = UILabel()
//                label.frame = CGRect(x: 15, y: 150, width: self.view.frame.width - 30, height: 40)
//                label.font = UIFont(name: "Futura", size: 18)
//                label.textAlignment = .center
//                label.text = "This user has no images"
//                label.textColor = .black
//                let imager = UIButton()
//                imager.frame = CGRect(x: self.view.frame.width / 2.45, y: 210, width: 70, height: 70)
//                imager.setImage(#imageLiteral(resourceName: "empty"), for: .normal)
//
//
//
//                self.view.addSubview(imager)
//                self.view.addSubview(label)
            }
        }, withCancel: nil)
    }
    
    func grabInstagramAccount () {
        if let theirid = theirId {
            let ref = Database.database().reference()
            ref.child("users").child(theirid).child("instagramAccount").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    
                    if let usernemrtti = snapshot.value as? String {
                        self.account = usernemrtti
                
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "instag"), style: .plain, target: self, action: #selector(self.loadInsta))
                       self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.8784, green: 0, blue: 0.349, alpha: 1.0)
                    }
                } else {
                    //do nothing
                }
            })
        }
    }
   
    var account: String?
    @objc func loadInsta() {
        if let accounter = self.account {
            let string = "https://www.instagram.com/\(accounter)"
            UIApplication.shared.open(URL(string:string)!, options: [:], completionHandler: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionerView.frame.width, height: collectionerView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "theirPhotos", for: indexPath) as! UserImagelsCollectionViewCell
        cell.imagerView.layer.cornerRadius = 16.0
        cell.imagerView.clipsToBounds = true
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "theirPhotos", for: indexPath) as! UserImagelsCollectionViewCell
        
       
        cell.imagerView.frame = CGRect(x: 10, y: 10, width: cell.frame.width - 20, height: cell.frame.height - 20)
      
        if let imager = imagers[indexPath.row].photoUrl {
            let restource = ImageResource(downloadURL: URL(string: imager)!, cacheKey: imager)
            self.activityer.stopAnimating()
            cell.imagerView.kf.setImage(with: restource)
        } else {
            cell.imagerView.image = nil
        }
        
        if indexPath.row == 0 {
            cell.imagerView.contentMode = .scaleAspectFill
            cell.imagerView.frame = CGRect(x: 35, y: 80, width: 300, height: 300)
           cell.imagerView.layer.cornerRadius = 150
            if self.view.frame.height == 812 {
                //375
                cell.imagerView.frame = CGRect(x: 34, y: 150, width: 300, height: 300)
                cell.imagerView.layer.cornerRadius = 150
            }
            if self.view.frame.width == 414 {
                cell.imagerView.frame = CGRect(x: 57, y: 80, width: 300, height: 300)
                cell.imagerView.layer.cornerRadius = 150
            }
            if self.view.frame.width == 320 {
                 cell.imagerView.frame = CGRect(x: 20, y: 50, width: 280, height: 280)
                 cell.imagerView.layer.cornerRadius = 140
            }
           
            cell.imagerView.clipsToBounds = true
        } else if indexPath.row != 0 {
             cell.imagerView.contentMode = .scaleAspectFit
             cell.imagerView.frame = CGRect(x: 10, y: 10, width: cell.frame.width - 20, height: cell.frame.height - 20)
            cell.imagerView.layer.cornerRadius = 0
            cell.imagerView.clipsToBounds = true
        }
       
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var collectionerView: UICollectionView!
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionerView.contentOffset
        visibleRect.size = collectionerView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX - 1, y: visibleRect.midY - 1)
        let visibli: NSIndexPath = collectionerView.indexPathForItem(at: visiblePoint)! as IndexPath as NSIndexPath
        print(visibli.row)
        if imagers.count != 0 {
            labelWhere.text = "\(visibli.row + 1)/\(imagers.count)"

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
