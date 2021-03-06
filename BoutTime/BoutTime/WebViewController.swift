//
//  WebViewController.swift
//  BoutTime
//
//  Created by davidlaiymani on 22/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView // The all view is a WKWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the URL. If error the WKNavigationDelegate protocol is implemented
        if let urlToLoad = url, let url = URL(string: urlToLoad) {
            webView.load(URLRequest(url: url))
        }
        
        // Display the toolbar with a refresh button
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
    }
    
    // MARK: WKNavigationDelegate protocol
    
    // Display the title when the url finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // Error loading web site
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showAlert(title: "Error Loading Website", message: "The website is unaccessible")
    }
    
    
    // MARK: AlertController
    func showAlert(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissAlert(sender: UIAlertAction) -> Void {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
