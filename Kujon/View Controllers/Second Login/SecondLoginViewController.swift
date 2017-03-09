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
        let url = verificationProvider.getRequestUrl()
        let request = URLRequest(url: URL(string: url)!)
        webView.loadRequest(request)
        webView.isHidden = true
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

        guard let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML") else {
            return
        }

        let jsonString = String.stripHTMLFromString(html)

        guard let data = jsonString.data(using: String.Encoding.utf8) else {
            return
        }

        if let errorResponse = parseError(data: data) {
            presentAlertWithMessage(errorResponse.message, title: StringHolder.errorAlertTitle)
            return
        }
        webView.isHidden = false
        self.webView.stringByEvaluatingJavaScript(from: "javascript:window.HtmlViewer.showHTML" +
            "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');")
    }


    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        NSlogManager.showLog("Load error:  \(error)")
    }

    // MARK: VerificationProviderDelegate

    func onVerificationSuccess() {
            self.successs()
    }

    func onErrorOccurs(_ text: String, retry: Bool) {
        if retry {
            let url = verificationProvider.getRequestUrl()
            let request = URLRequest(url: URL(string: url)!)
            webView.loadRequest(request)
            return
        }
            self.presentAlertWithMessage(text, title: StringHolder.loginError) { [weak self] in
                self?.dismiss(animated: true)
     
        }
    }

    // MARK: NSURLConnectionDataDelegate

    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            presentAlertWithMessage(StringHolder.errorOccures, title: StringHolder.errorAlertTitle)
            webView.stopLoading()
        }

    }

    func connection(_ connection: NSURLConnection, didReceive data: Data) {

        if let errorResponse = parseError(data: data) {
            var errorMessage = errorResponse.message
            if let code = errorResponse.code {
                errorMessage += " (\(code))"
            }
            presentAlertWithMessage(errorMessage, title: StringHolder.errorAlertTitle)
            webView.stopLoading()
            return
        }
        self.successs()
    }

    internal func successs() {

            self.userDataHolder.loggedToUsosForCurrentEmail = true
            let controller = ContainerViewController()
            controller.loadedToUsos = true
            self.present(controller, animated: true, completion: nil)
        
    }


    private func parseError(data: Data) -> ErrorResponse? {

        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let errorResponse = try? ErrorResponse.decode(json) {
            return errorResponse
        }

        return nil
    }




}
