//
//  PrivacyViewController.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webViewer: UIWebView!
    var bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        let termsOfServiceUrl = URL(string: "https://www.berlark.com/flurl-privacy")
        let termsOfServiceUrlRequest = URLRequest(url: termsOfServiceUrl!)
        webViewer.loadRequest(termsOfServiceUrlRequest)
        webViewer.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height - 60)
        // Do any additional setup after loading the view.
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if bool == true {
            return true
        } else {
            return false
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        bool = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismisser(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
