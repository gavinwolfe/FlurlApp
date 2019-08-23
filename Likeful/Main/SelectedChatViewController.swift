//
//  SelectedChatViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/4/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var camerButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewler: UIView!
    
    var messages = [Message]()

    var timer: Int?
    var theirNamer: String?
    override func viewWillAppear(_ animated: Bool) {
        textViewer.becomeFirstResponder()
    }
    
    let gestler = UITapGestureRecognizer()
    @IBOutlet weak var tablerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("yuuup")
        timeLabel.layer.shadowColor = UIColor.white.cgColor
        timeLabel.layer.shadowRadius = 4.0
        timeLabel.layer.shadowOpacity = 0.5
        
        gestler.numberOfTapsRequired = 1
        gestler.addTarget(self, action: #selector(hiddenOrNot))
        view.addGestureRecognizer(gestler)
        imagerViewl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        if let lastTime = timer {
            let timerStamp: Int = Int(NSDate().timeIntervalSince1970)
            let timer = timerStamp - lastTime
            
            if timer < 59 {
                timeLabel.text = ("• \(timer)s ago")
                
            }
            if timer > 59 && timer < 3600 {
                let minuters = timer / 60
                timeLabel.text = "• \(minuters)mins ago"
                if minuters == 1 {
                    timeLabel.text = "• \(minuters)min ago"
                }
            }
            if timer > 59 && timer >= 3600 && timer < 86400 {
                let hours = timer / 3600
                timeLabel.text = "• \(hours)hrs ago"
                if hours == 1 {
                    timeLabel.text = "• \(hours)hr ago"
                }
            }
            if timer > 86400 {
                let days = timer / 86400
                timeLabel.text = "• \(days)days ago"
                if days == 1 {
                    timeLabel.text = "• \(days)day ago"
                }
            }
        }

        camerButton.frame = CGRect(x: 6, y: self.view.frame.height / 1.809, width: 40, height: 40)
        textViewer.delegate = self
        viewler.frame = CGRect(x: 50, y: self.view.frame.height / 1.79, width: self.view.frame.width - 51, height: 35)
        textViewer.frame = CGRect(x: 0, y: 0, width: viewler.frame.width, height: viewler.frame.height)
        tablerView.frame = CGRect(x: 5, y: 120, width: self.view.frame.width - 10, height: self.view.frame.height / 2.8)
        viewler.layer.borderColor = UIColor.black.cgColor
        viewler.layer.borderWidth = 1.0
        viewler.layer.cornerRadius = 16.0
        viewler.clipsToBounds = true
        
        
        let onechat = Message()
        onechat.messager = "How far did you have to go?"
        onechat.sender = "notMe"
        messages.append(onechat)
        
        let oonechat = Message()
        oonechat.messager = "Wow thats insane"
        oonechat.sender = "Me"
        messages.append(oonechat)
        let ooonechat = Message()
        ooonechat.messager = "Hi there"
        ooonechat.sender = "notMe"
        messages.append(ooonechat)
        tablerView.delegate = self
        tablerView.dataSource = self
        if let titler = theirNamer {
            self.navigationItem.title = titler
        }
        
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "selectedChatCell", for: indexPath) as! SelectedChatTableViewCell
        cell.backgroundColor = .clear
        
        
        cell.mainLabel.text = messages[indexPath.row].messager
        
        
        
        cell.mainLabel.textAlignment = .center
        
        cell.mainLabel.layer.cornerRadius = 8.0
        cell.mainLabel.clipsToBounds = true
        
        cell.backView.layer.cornerRadius = 8.0
        cell.backView.clipsToBounds = true
        
        if messages[indexPath.row].sender == "notMe" {
            
            cell.mainLabel.frame = CGRect(x: 10, y: 5, width: 200, height: cell.frame.height - 10)
            cell.backView.frame = CGRect(x: 5, y: 5, width: 210, height: cell.frame.height - 10)
            cell.mainLabel.backgroundColor = UIColor(red: 0.9294, green: 0.9333, blue: 0.9373, alpha: 1.0)
            cell.backView.backgroundColor =  UIColor(red: 0.9294, green: 0.9333, blue: 0.9373, alpha: 1.0)
            cell.mainLabel.textColor = UIColor.black
            
           
        } else {
            
            
            cell.mainLabel.frame = CGRect(x: cell.frame.width - 210, y: 5, width: 200, height: cell.frame.height - 10)
            cell.backView.frame = CGRect(x: cell.frame.width - 215, y: 5, width: 210, height: cell.frame.height - 10)
            cell.mainLabel.backgroundColor = UIColor(red: 0, green: 0.7569, blue: 0.9098, alpha: 1.0)
            cell.backView.backgroundColor = UIColor(red: 0, green: 0.7569, blue: 0.9098, alpha: 1.0)
            cell.mainLabel.textColor = .white
            
            
        }
        
        
        return cell
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 80 // Bool
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let newMess = Message()
        if textField.text != "" {
            newMess.messager = textField.text
            newMess.sender = "Me"
            messages.remove(at: 0)
            messages.append(newMess)
            tablerView.reloadData()
            textViewer.text = ""
             timeLabel.text = "Now"
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messages.count != 0 {
            if messages[indexPath.row].messager.count > 26 && messages[indexPath.row].messager.count < 50 {
                return 65
            }
            if messages[indexPath.row].messager.count > 50 {
                return 78
            }
        }
        return 50
    }
    
    @IBOutlet weak var textViewer: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAct(_ sender: Any) {
        textViewer.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func hiddenOrNot () {
        if imagerViewl.image != nil {
        self.navigationController?.navigationBar.isHidden = !(self.navigationController?.navigationBar.isHidden)!
        timeLabel.isHidden = !timeLabel.isHidden
        tablerView.isHidden = !tablerView.isHidden
        camerButton.isHidden = !camerButton.isHidden
        textViewer.isHidden = !textViewer.isHidden
        viewler.isHidden = !viewler.isHidden
        if textViewer.isFirstResponder == true {
            textViewer.resignFirstResponder()
        } else {
            textViewer.becomeFirstResponder()
        }
        }
        
    }
    
    @IBOutlet weak var imagerViewl: UIImageView!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    let imagePicker = UIImagePickerController()
    @IBAction func cameraAction(_ sender: Any) {
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
        
        imagerViewl.image = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    
    
}
