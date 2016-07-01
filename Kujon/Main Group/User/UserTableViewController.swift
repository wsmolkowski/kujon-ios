//
//  UserTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController
        , NavigationDelegate
        , UserDetailsProviderDelegate
        , FacultiesProviderDelegate
        , OnImageLoadedFromRest {
    weak var delegate: NavigationMenuProtocol! = nil
    private let usedDetailCellId = "userDetailViewId"
    private let StudentProgrammeCellId = "cellIdForStudentProgramme"
    private let FacultieProgrammeCellId = "cellIdForStudentFacultie"
    let userDetailsProvider: UserDetailsProvider! = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    let facultieProvider: FacultiesProvider! = ProvidersProviderImpl.sharedInstance.providerFacultiesProvider()
    let restImageProvider = RestImageProvider.sharedInstance

    var userDetails: UserDetail! = nil
    var userFaculties: Array<Facultie>! = nil

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserTableViewController.openDrawer))
        userDetailsProvider.delegate = self
        userDetailsProvider.loadUserDetail()
        facultieProvider.delegate = self
        facultieProvider.loadFaculties()


        self.tableView.registerNib(UINib(nibName: "UserDetailView", bundle: nil), forCellReuseIdentifier: usedDetailCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: FacultieProgrammeCellId)
    }


    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        self.userDetails = userDetails;
        self.tableView.reloadData()
    }

    func onFacultiesLoaded(list: Array<Facultie>) {
        self.userFaculties = list
        self.tableView.reloadData()
    }


    func onErrorOccurs() {
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return userDetails == nil ? 0 : 1
        case 1: return userDetails == nil ? 0 : userDetails.studentProgrammes.count
        case 2: return userFaculties == nil ? 0 : userFaculties.count
        default: return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section) {
        case 0: cell = self.configureUserDetails(indexPath)
            break;
        case 1: cell = self.configureStudentProgrammeCell(indexPath)
            break;
        case 2: cell = self.configureFacultieCell(indexPath)
            break;
        default: cell = self.configureUserDetails(indexPath)
        }

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 400
            break;
        case 1: return 48
            break;
        case 2: return 48;
        default: return 48
        }
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0
            break;
        case 1: return 56
            break;
        case 2: return 56;
        default: return 0
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
            break;
        case 1: return createLabel("Kierunki")
            break;
        case 2: return createLabel("Jednostki")
        default: return nil
        }
    }

    private func createLabel(text: String) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 56))
        let label = UILabel(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 48))
        label.text = text
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        return view
    }

    private func configureUserDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(usedDetailCellId, forIndexPath: indexPath) as! UserDetailView
        cell.nameSurnameLabel.text = userDetails.firstName + " " + userDetails.lastName
        cell.studentStatusLabel.text = userDetails.studentStatus
        cell.schoolNameLabel.text = userDetails.usosName
        cell.indexNumberLabel.text = userDetails.studentNumber
        cell.accountNumberLabel.text = userDetails.id
        if (userDetails.hasPhoto) {
            self.restImageProvider.loadImage("", urlString: self.userDetails.photoUrl!, onImageLoaded: self)

        }
        return cell
    }

    func imageLoaded(tag: String, image: UIImage) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! UserDetailView
        cell.userImageView.image = image
    }


    private func configureStudentProgrammeCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StudentProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myProgramme: StudentProgramme = self.userDetails.studentProgrammes[indexPath.row]
        cell.plainLabel.text = myProgramme.programme.description
        cell.goButton.addTarget(self, action: "clicked:", forControlEvents: .TouchUpInside)
        cell.goButton.tag = indexPath.row
        return cell
    }

    private func configureFacultieCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FacultieProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myFac: Facultie = self.userFaculties[indexPath.row]
        cell.plainLabel.text = myFac.name
        cell.goButton.addTarget(self, action: "clickedFacultie:", forControlEvents: .TouchUpInside)
        cell.goButton.tag = indexPath.row
        return cell
    }

    func clicked(sender: UIButton) {
        let buttonTag = sender.tag
        let myProgramme: StudentProgramme = self.userDetails.studentProgrammes[buttonTag as! Int]
//        popController.showInView(self.navigationController?.view, withProgramme: myProgramme.programme, animated: true)

        let popController = KierunkiViewController(nibName: "KierunkiViewController", bundle: NSBundle.mainBundle())
        popController.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.presentViewController(popController, animated: false, completion: {popController.showAnimate();})

        popController.showInView(withProgramme: myProgramme.programme)

    }


    func clickedFacultie(sender: UIButton) {
        let buttonTag = sender.tag
        let myFac: Facultie = self.userFaculties[buttonTag as! Int]
        let faculiteController = FacultieViewController(nibName: "FacultieViewController", bundle: NSBundle.mainBundle())
        faculiteController.facultie = myFac
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
