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
    private let verificationProvider = ProvidersProviderImpl.sharedInstance.provideVerificationProvider()

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
        let url = verificationProvider.getMyUrl()
        let request = URLRequest(url: URL(string: url)!)
        webView.loadRequest(request)
    }

    func back() {
        self.dismiss(animated: true)
    }

    // MARK: UIWebViewDelegate

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let verificationRequirement = verificationProvider.verificationRequirement
        if let URLString = request.url?.absoluteString, URLString.contains(verificationRequirement) {
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
        self.presentAlertWithMessage(error.localizedDescription, title: StringHolder.errorAlertTitle) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    // MARK: VerificationProviderDelegate

    func onVerificationResponse(result: VerificationResult) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.successs()
            case .error(let message):
                self.presentAlertWithMessage(message, title: StringHolder.loginError) { [weak self] in
                    self?.dismiss(animated: true)
                }
            default:
                self.presentAlertWithMessage(StringHolder.unknownErrorMessage, title: StringHolder.loginError) { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
        }
    }

    func onErrorOccurs(_ text: String) {
         DispatchQueue.main.async {
            self.presentAlertWithMessage(text, title: StringHolder.loginError) { [weak self] in
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
