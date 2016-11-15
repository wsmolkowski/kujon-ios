//
//  SecondLoginViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SecondLoginViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDataDelegate, VerificationProviderDelegate {

    @IBOutlet weak var webView: UIWebView!

    let userDataHolder = UserDataHolder.sharedInstance
    let verificationProvider = VerificationProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]

        self.edgesForExtendedLayout = UIRectEdge()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SecondLoginViewController.back), andTitle: "Logowanie do USOS")

        verificationProvider.delegate = self

        webView.delegate = self
        webView.scalesPageToFit = true;
        let url = String(format: "%@/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", RestApiManager.BASE_URL, userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
        let request = URLRequest(url: URL(string: url)!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    func back() {
        self.dismiss(animated: true)
    }

    // MARK: UIWebViewDelegate

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let toCatch = String(format: "%@/authentication/verify", RestApiManager.BASE_URL)
        //TODO: Revert to:
        // if let URLString = request.url?.absoluteString, URLString.contains(toCatch) {
        if let URLString = request.url?.absoluteString, !URLString.contains(toCatch) {
            verificationProvider.verify(URLString: URLString)
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

    // MARK: VerificationProviderDelegate

    func onVerificationSuccess(_ data: Data) {
        DispatchQueue.main.async {

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let _ = try UsosPaired.decode(json)
                self.successs()
            } catch {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let error = try ErrorClass.decode(json)

                    self.presentAlertWithMessage(error.message, title: StringHolder.loginError) { [weak self] in
                        self?.dismiss(animated: true)
                    }

                } catch {
                    self.presentAlertWithMessage(StringHolder.unknownErrorMessage, title: StringHolder.loginError) { [weak self] in
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }

    func onErrorOccurs(_ text: String) {
         DispatchQueue.main.async {
            self.presentAlertWithMessage(StringHolder.unknownErrorMessage, title: StringHolder.loginError) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }

    // MARK: NSURLConnectionDataDelegate

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
