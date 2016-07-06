//
//  TextViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 05/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    var text : String! = nil
    var myTitle: String! = nil
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(TextViewController.back), andTitle: myTitle)
        if(text != nil){
            textView.text  =  text
        }
        // Do any additional setup after loading the view.
    }
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
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