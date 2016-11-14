//
//  SecondLoginViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SecondLoginViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDataDelegate {

    @IBOutlet weak var webView: UIWebView!

    let userDataHolder = UserDataHolder.sharedInstance
    private var headerManager = HeaderManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]

        self.edgesForExtendedLayout = UIRectEdge()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SecondLoginViewController.back), andTitle: "Logowanie do USOS")
        webView.delegate = self
        webView.scalesPageToFit = true;
        let url = String(format: "%@/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", RestApiManager.BASE_URL, userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
        let request = URLRequest(url: URL(string: url)!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func back() {
        self.dismiss(animated: true)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let toCatch = String(format: "%@/authentication/verify", RestApiManager.BASE_URL)
        if let URL = request.url?.absoluteString, URL.contains(toCatch) {
            var requestC = URLRequest(url: Foundation.URL(string: URL)!)
            let cookies = HTTPCookieStorage.shared.cookies(for: Foundation.URL(string: RestApiManager.BASE_URL)!)
            var myMutableString = ""
            for cookie in cookies! {
                myMutableString = myMutableString + (cookie as HTTPCookie).name + "=" + (cookie as HTTPCookie).value + ";"
            }
            requestC.setValue(myMutableString, forHTTPHeaderField: "Cookie")
//            _ = NSURLConnection(request: requestC as URLRequest,delegate:self)

            self.headerManager.addHeadersToRequest(&requestC)
            let session = SessionManager.provideSession()

            let task = session.dataTask(with: requestC as URLRequest, completionHandler: {
                [unowned self]   data, response, error in
                if error == nil {
                 
                    DispatchQueue.main.async {
                           
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            let response = try UsosPaired.decode(json)
                            self.successs()
                        } catch {
                            do{
                                 let json = try JSONSerialization.jsonObject(with: data!, options: [])
                                 let error = try ErrorClass.decode(json)
                                 let alertController = UIAlertController(title: "Błąd logowania ", message: error.message, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) in
                                    alertController.dismiss(animated: true, completion: nil)
                                    self.dismiss(animated: true)
                                }))
                                self.present(alertController, animated: true, completion: nil)

                            }catch{
                                let alertController = UIAlertController(title: "Błąd logowania ", message: "Nieznany błąd", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) in
                                    alertController.dismiss(animated: true, completion: nil)
                                    self.dismiss(animated: true)

                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "Błąd logowania ", message: "Nieznany błąd", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) in
                        alertController.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true)
                        
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                }
            )
            task.resume()

            return false
        }
        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {

        self.webView.stringByEvaluatingJavaScript(from: "javascript:window.HtmlViewer.showHTML" +
                "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');")
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Logged error")
    }

    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {

    }

    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        print("Logged Succesfully")
        self.successs()
    }

    internal func successs() {
        userDataHolder.loggedToUsosForCurrentEmail = true
        let controller = ContainerViewController()
        controller.loadedToUsos = true
        self.present(controller, animated: true, completion: nil)
    }

}
