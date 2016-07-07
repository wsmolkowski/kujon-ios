//
//  StudentDetailsViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 07/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class StudentDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserDetailsProviderDelegate, OnImageLoadedFromRest {
    let kierunekCellId = "kierunekCellId"
    @IBOutlet weak var kierunkiTableView: UITableView!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var studentStatusLabel: UILabel!
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    let restImageProvider = RestImageProvider.sharedInstance
    var provider = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    var user: SimpleUser! = nil
    var studentProgrammes: Array<StudentProgramme> = Array()
    var userDetails: UserDetail! = nil
    var userId: String! = nil
    var isThereImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        kierunkiTableView.delegate = self
        kierunkiTableView.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge.None
        self.kierunkiTableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: kierunekCellId)
        if (userId == nil) {
            userId = user.userId
        }
        provider.delegate = self
        provider.loadUserDetail(userId)
    }


    func onUserDetailLoaded(userDetails: UserDetail) {
        self.userDetails = userDetails;
        studentNameLabel.text = userDetails.firstName + " " + userDetails.lastName
        studentStatusLabel.text = userDetails.studentStatus
        accountNumberLabel.text = userDetails.id

        self.studentProgrammes = userDetails.studentProgrammes
        studentImageView.image = UIImage(named:"user-placeholder")
        if (userDetails.hasPhoto) {
            self.restImageProvider.loadImage("", urlString: self.userDetails.photoUrl!, onImageLoaded: self)

        }
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StudentDetailsViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        studentImageView.addGestureRecognizer(tapGestureRecognizer)
        studentImageView.userInteractionEnabled = true
        kierunkiTableView.reloadData()
    }

    func imageLoaded(tag: String, image: UIImage) {
        studentImageView.image = image
        isThereImage = true
    }

    func imageTapped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: NSBundle.mainBundle())
            imageController.image = studentImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: "Nie ma zdjecia", forDuration: 2.0)
        }
    }

    func onErrorOccurs() {
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        clicked(indexPath)
    }


    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return studentProgrammes.count
    }

    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(kierunekCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myProgramme: StudentProgramme = self.studentProgrammes[indexPath.row]
        cell.plainLabel.text = myProgramme.programme.description
        return cell
    }


    func clicked(forIndexPath: NSIndexPath) {
        let myProgramme: StudentProgramme = self.studentProgrammes[forIndexPath.row]
        let popController = KierunkiViewController(nibName: "KierunkiViewController", bundle: NSBundle.mainBundle())
        popController.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.presentViewController(popController, animated: false, completion: { popController.showAnimate(); })

        popController.showInView(withProgramme: myProgramme.programme)
    }


}
