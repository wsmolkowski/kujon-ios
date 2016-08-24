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
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String:AnyObject]

        self.edgesForExtendedLayout = UIRectEdge.None
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SecondLoginViewController.back), andTitle: "Logowanie do USOS")
        webView.delegate = self
        webView.scalesPageToFit = true;
        let url = String(format: "https:/api.kujon.mobi/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func back(){
        let controller = UsosHolderController()

        self.presentViewController(controller, animated: true, completion: nil)
    }


    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if(request.URL!.absoluteString.containsString("https://api.kujon.mobi/authentication/verify")){

            let requestC = NSMutableURLRequest(URL: NSURL(string: request.URL!.absoluteString)!)
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: RestApiManager.BASE_URL)!)
            var myMutableString = ""
            for cookie in cookies!{
                myMutableString=myMutableString+(cookie as NSHTTPCookie).name + "=" + (cookie as NSHTTPCookie).value + ";"
            }
            requestC.setValue(myMutableString,forHTTPHeaderField: "Cookie")

            _ = NSURLConnection(request: requestC,delegate:self)
        }
        return true
    }

    func webViewDidStartLoad(webView: UIWebView) {
    }

    func webViewDidFinishLoad(webView: UIWebView) {

//        let contentSize = webView.scrollView.contentSize;
//        let viewSize = webView.bounds.size;
//
//        let rw = viewSize.width / contentSize.width;
//
//        webView.scrollView.minimumZoomScale = rw;
//        webView.scrollView.maximumZoomScale = rw;
//        webView.scrollView.zoomScale = rw;
        self.webView.stringByEvaluatingJavaScriptFromString("javascript:window.HtmlViewer.showHTML" +
                "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');")
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Logged error")
    }

    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {

    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        print("Logged Succesfully")
        userDataHolder.loggedToUsosForCurrentEmail = true
        let controller  = ContainerViewController()
        controller.loadedToUsos = true
        self.presentViewController(controller,animated:true,completion:nil)
    }


}
