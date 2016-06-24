//
//  KierunkiViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 24/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class KierunkiViewController: UIViewController{

    
    
  
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var kierunekLabel: UILabel!

    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var trybeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeOfStudyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var myProgramme:Programme! = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(KierunkiViewController.handleTap))

        self.popUpView.addGestureRecognizer(tap)


    }
    func handleTap() {
        removeAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func showInView(view:UIView! ,withProgramme programme : Programme, animated: Bool)
    {
        view.addSubview(self.view)
        self.myProgramme = programme
        levelLabel.text =  myProgramme.levelOfStudies
        descriptionLabel.text = "opis: " + myProgramme.description
        timeOfStudyLabel.text =  myProgramme.duration
        idLabel.text = myProgramme.id
        trybeLabel.text = myProgramme.modeOfStudies
        kierunekLabel.text = myProgramme.name

        if animated
        {
            self.showAnimate()
        }
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }

    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
