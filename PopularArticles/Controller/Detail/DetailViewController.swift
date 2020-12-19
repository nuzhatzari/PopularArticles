//
//  DetailViewController.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 17/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var articleUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: articleUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self

        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.hidesWhenStopped = true

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnBackClicked() {
           self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
    }
}
