//
//  SecondLoginViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SecondLoginViewController: UIViewController,UIWebViewDelegate,NSURLConnectionDataDelegate {

    @IBOutlet weak var webView: UIWebView!

    let userDataHolder = UserDataHolder.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let url = String(format: "https:/api.kujon.mobi/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    func webView(_ webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {

        if(request.URL!.absoluteString.containsString("https://api.kujon.mobi/authentication/verify")){

            var requestC = NSMutableURLRequest(URL: NSURL(string: request.URL!.absoluteString)!)
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: RestApiManager.BASE_URL)!)
            var myMutableString = ""
            for cookie in cookies!{
                myMutableString=myMutableString+(cookie as NSHTTPCookie).name + "=" + (cookie as NSHTTPCookie).value + ";"
            }
            requestC.setValue(myMutableString,forHTTPHeaderField: "Cookie")

            //TODO TEGO NIE JESTEM PEWIEN CZY TAK TO ZROBIC BO COS KRZYCZY ZE DEPRECATED
            let urlConnection = NSURLConnection(request: requestC,delegate:self)
        }
        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView!) {
    }

    func webViewDidFinishLoad(_ webView: UIWebView!) {
        self.webView.stringByEvaluatingJavaScriptFromString("javascript:window.HtmlViewer.showHTML" +
                "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');")
    }

    func webView(_ webView: UIWebView!, didFailLoadWithError error: NSError!) {
    }

    func connection(_ connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {

    }

    func connection(_ connection: NSURLConnection!, didReceiveData data: NSData!) {
        print("Logged Succesfully")
        //TODO TUTAJ BY PEWNIE SIE PRZYDALO DOLOZYC JAKIES PERSIST TYCH TOKENOW FACEBOOKOWYCH
        userDataHolder.loggedToUsosForCurrentEmail = true
        let controller  = ContainerViewController()
        self.presentViewController(controller,animated:true,completion:nil)
    }


}
