//
//  FacultieViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 29/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class FacultieViewController: UIViewController {
    @IBOutlet weak var facultieImage: UIImageView!
    @IBOutlet weak var facultieAdress: UILabel!
    @IBOutlet weak var facultiePhoneNumber: UILabel!
    @IBOutlet weak var programmeNumber: UILabel!
    @IBOutlet weak var cursantNumber: UILabel!

    @IBOutlet weak var employeeNumber: UILabel!
    @IBOutlet weak var facultieWebPage: UILabel!
    @IBOutlet weak var facultieName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
