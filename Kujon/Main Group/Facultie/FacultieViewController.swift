//
//  FacultieViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 29/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class FacultieViewController: UIViewController, FacultieProviderDelegate {
    @IBOutlet weak var facultieImage: UIImageView!
    @IBOutlet weak var facultieAdress: UILabel!
    @IBOutlet weak var facultiePhoneNumber: UILabel!
    @IBOutlet weak var programmeNumber: UILabel!
    @IBOutlet weak var cursantNumber: UILabel!

    @IBOutlet weak var employeeNumber: UILabel!
    @IBOutlet weak var facultieWebPage: UILabel!
    @IBOutlet weak var facultieName: UILabel!


    var facultie: Facultie! = nil
    var facultieId: String! = nil
    var facultieProvider = ProvidersProviderImpl.sharedInstance.proivdeFacultieProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(FacultieViewController.back),andTitle: "Jednostka")
        if (facultie != nil) {
            facultieImage.contentMode = UIViewContentMode.ScaleAspectFit;
            fillUpData()
        } else if (facultieId != nil) {
            facultieProvider.delegate = self
            facultieProvider.loadFacultie(facultieId)
        }
        // Do any additional setup after loading the view.
    }

    func onFacultieLoaded(fac: Facultie) {
        self.facultie = fac
        fillUpData()
    }

    func onErrorOccurs() {
    }



    private func fillUpData(){
        facultieAdress.text = facultie.postalAdress
        facultiePhoneNumber.numberOfLines = facultie.phoneNumber.count
        var phoneString = ""
        for str in facultie.phoneNumber {
            phoneString = phoneString + str + "\n"
        }
        facultiePhoneNumber.text = phoneString
        programmeNumber.text = "liczba programów: " + String(facultie.schoolStats.programmeCount)
        cursantNumber.text = "liczba kursantów: " + String(facultie.schoolStats.courseCount)
        employeeNumber.text = "liczba pracowników: " + String(facultie.schoolStats.staffCount)
        facultieName.text = facultie.name
        facultieWebPage.text = facultie.homePageUrl
        loadImage(facultie.logUrls.p100x100)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func loadImage(urlString: String) {
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.facultieImage.contentMode = UIViewContentMode.ScaleAspectFit;
                    self.facultieImage.image = image


                }
            }
        })
        task.resume()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
