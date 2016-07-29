//
//  WebViewController.swift
//  Kujon
//
//  Created by Dmitry Kolesnikov on 7/29/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: "https://kujon.mobi/#disclaimer");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zamknij", style: UIBarButtonItemStyle.Done, target: self, action: "done")
    }

    func done() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
