//
//  ImageViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 01/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        imageView.image = image
        if(self.navigationController != nil){
            NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(ImageViewController.back))
        }
    }

    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
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
