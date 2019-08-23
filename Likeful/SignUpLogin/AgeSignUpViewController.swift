//
//  AgeSignUpViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 2/2/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

protocol cantJoin {
    func youCant()
}

class AgeSignUpViewController: UIViewController {

    @IBOutlet weak var pickerViewer: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        pickerViewer.datePickerMode = UIDatePickerMode.date
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        
        self.titleLabeler.frame = CGRect(x: 70, y: 78, width: self.view.frame.width - 140, height: 22)
        self.pickerViewer.frame = CGRect(x: 25, y: 118, width: self.view.frame.width - 50, height: 170)
        self.nextButton.frame = CGRect(x: 60, y: 310, width: self.view.frame.width - 120, height: 48)
        
        if self.view.frame.height == 812 {
            self.titleLabeler.frame = CGRect(x: 70, y: 98, width: self.view.frame.width - 140, height: 22)
            self.pickerViewer.frame = CGRect(x: 25, y: 138, width: self.view.frame.width - 50, height: 170)
            self.nextButton.frame = CGRect(x: 60, y: 330, width: self.view.frame.width - 120, height: 48)
        }
         if ( UIDevice.current.model.range(of: "iPad") != nil){
            self.titleLabeler.font = UIFont(name:  "HelveticaNeue-Medium", size: 14)
        }
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var nextButton: UIButton!
    var delegate: cantJoin?
    @IBAction func dismisser(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //segueNamely
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var dateSelected: Date?
    @IBAction func selectedDate(_ sender: Any) {
  
     
        dateSelected = pickerViewer.date
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueNamely" {
            if dateSelected != nil {
             
                let now = Date()
                let birthday: Date = dateSelected!
                let calendar = Calendar.current
                
                let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                let age = ageComponents.year!
                ageYears = age
                if age >= 14 {
                    return true
                } else {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.youCant()
                }
                print(age)
            }
        }
        return false
    }
    var ageYears: Int?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNamely" {
            let dest = segue.destination as! NameSignUpViewController
            if let daterSelected = dateSelected {
            dest.dob = daterSelected
                if let ageYearz = self.ageYears {
                dest.years = ageYearz
                }
            }
        }
    }
    
    @IBOutlet weak var titleLabeler: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
