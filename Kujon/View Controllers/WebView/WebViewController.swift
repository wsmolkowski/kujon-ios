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

    var url: URL? = URL(string: "https://kujon.mobi/regulamin")

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zamknij", style: UIBarButtonItemStyle.done, target: self, action: #selector(WebViewController.done))
    }

    func done() {
        self.dismiss(animated: true, completion: nil)
    }

}
