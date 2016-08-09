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
        , OnImageLoadedFromRest
        , TermsProviderDelegate
        , ProgrammeProviderDelegate {

    weak var delegate: NavigationMenuProtocol! = nil
    private let usedDetailCellId = "userDetailViewId"
    private let StudentProgrammeCellId = "cellIdForStudentProgramme"
    private let FacultieProgrammeCellId = "cellIdForStudentFacultie"
    private let termsCellId = "termsCellId"
    let userDetailsProvider: UserDetailsProvider! = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    let facultieProvider: FacultiesProvider! = ProvidersProviderImpl.sharedInstance.providerFacultiesProvider()
    let termsProvider: TermsProvider! = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    let programmeProvider: ProgrammeProvider! = ProvidersProviderImpl.sharedInstance.provideProgrammeProvider()
    let restImageProvider = RestImageProvider.sharedInstance
    private let userDataHolder = UserDataHolder.sharedInstance

    var userDetails: UserDetail! = nil
    var userFaculties: Array<Facultie>! = nil
    var terms: Array<Term> = Array()
    var programmes: Array<StudentProgramme> = Array()
    var programmeLoaded = false;
    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.kujonBlueColor()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserTableViewController.openDrawer), andTitle: StringHolder.appName)
        userDetailsProvider.delegate = self
        facultieProvider.delegate = self
        termsProvider.delegate = self
        programmeProvider.delegate = self;

        loadData()
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: usedDetailCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: FacultieProgrammeCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: termsCellId)
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
    }

    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        userDetailsProvider.reload()
        facultieProvider.reload()
        termsProvider.reload()
        programmeProvider.reload()
        loadData()

    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }
    private func loadData(){
        userDetailsProvider.loadUserDetail()
        facultieProvider.loadFaculties()
        termsProvider.loadTerms()
        programmeProvider.loadProgramme()
    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        self.userDetails = userDetails;
        self.programmes = userDetails.studentProgrammes
        self.tableView.reloadData()
        self.userDataHolder.userName  = userDetails.firstName + " " + userDetails.lastName
        refreshControl?.endRefreshing()
    }

    func onFacultiesLoaded(list: Array<Facultie>) {
        self.userFaculties = list
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func onProgrammeLoaded(terms: Array<StudentProgramme>) {
        self.programmes = terms;
        programmeLoaded = true;
        refreshControl?.endRefreshing()
    }


    func onTermsLoaded(terms: Array<Term>) {
        self.terms = terms
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }


    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.userDetailsProvider.loadUserDetail()
            self.facultieProvider.loadFaculties()
        }, cancel: {})
    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return userDetails == nil ? 0 : 1
        case 1: return userDetails == nil ? 0 : userDetails.studentProgrammes.count
        case 2: return userFaculties == nil ? 0 : userFaculties.count
        case 3:  return 1
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
        case 3: cell = self.configureTermsCell(indexPath)
            break;
        default: cell = self.configureUserDetails(indexPath)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 1:
            self.clicked(indexPath)
            break;
        case 2:
            self.clickedFacultie(indexPath)
            break;
        case 3:
            self.clickedTerms()
            break;
        default:
            break;
        }
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 210
            break;
        case 1: return 51
            break;
        case 2: return 51;
        default: return 51
        }
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0
            break;
        case 1: return 51
            break;
        case 2: return 51;
        case 3: return 51;
        default: return 0
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
            break;
        case 1: return createLabelForSectionTitle(StringHolder.kierunki)
            break;
        case 2: return createLabelForSectionTitle(StringHolder.faculties)
        case 3: return createLabelForSectionTitle(StringHolder.statistics)
        default: return nil
        }
    }


    private func configureUserDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(usedDetailCellId, forIndexPath: indexPath) as! UserDetailsTableViewCell
        cell.nameSurnameLabel.text = userDetails.firstName + " " + userDetails.lastName
        cell.studentStatusLabel.text = userDetails.studentStatus
//        cell.schoolNameLabel.text = userDetails.usosName
        cell.indexNumberLabel.text = userDetails.studentNumber
        cell.accountNumberLabel.text = userDetails.id
        cell.userImageView.makeMyselfCircle()
        cell.userImageView.image = UIImage(named: "user-placeholder")
        if (userDetails.hasPhoto) {
            self.restImageProvider.loadImage("", urlString: self.userDetails.photoUrl!, onImageLoaded: self)

        }

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.userImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.userImageView.userInteractionEnabled = true
        self.loadImageFromUrl(UserDataHolder.sharedInstance.userUsosImage, indexPath: indexPath)
        return cell
    }


    func imageTapped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: NSBundle.mainBundle())
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! UserDetailsTableViewCell
            imageController.image = cell.userImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture, forDuration: 2.0)
        }
    }
    private var isThereImage = false;

    func imageLoaded(tag: String, image: UIImage) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! UserDetailsTableViewCell
        cell.userImageView.image = image
        self.userDataHolder.userImage  = image
        isThereImage = true
    }


    private func configureStudentProgrammeCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StudentProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myProgramme: StudentProgramme = self.programmes[indexPath.row]
        cell.plainLabel.text = myProgramme.programme.description
        return cell
    }

    private func configureFacultieCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FacultieProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myFac: Facultie = self.userFaculties[indexPath.row]
        cell.plainLabel.text = myFac.name
        return cell
    }

    private func configureTermsCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FacultieProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let number = terms.count
        cell.plainLabel.text = StringHolder.cycles + "(" + String(number) + ")"
        return cell
    }

    func clicked(forIndexPath: NSIndexPath) {
        if (programmeLoaded) {
            let myProgramme: StudentProgramme = self.programmes[forIndexPath.row]
            if (myProgramme.programme.duration != nil && myProgramme.programme.name != nil && myProgramme.programme.levelOfStudies != nil) {
                let popController = KierunkiViewController(nibName: "KierunkiViewController", bundle: NSBundle.mainBundle())
                popController.modalPresentationStyle = .OverCurrentContext
                self.navigationController?.presentViewController(popController, animated: false, completion: { popController.showAnimate(); })

                popController.showInView(withProgramme: myProgramme.programme)
            }
        }

    }


    func clickedFacultie(forIndexPath: NSIndexPath) {
        let myFac: Facultie = self.userFaculties[forIndexPath.row]
        let faculiteController = FacultieViewController(nibName: "FacultieViewController", bundle: NSBundle.mainBundle())
        faculiteController.facultie = myFac
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }

    private func clickedTerms() {
        if (terms.count != 0) {
            let termsController = TermsTableViewController()
            self.navigationController?.pushViewController(termsController, animated: true)
            termsController.setUpTerms(self.terms)
        }
    }

    private func loadImageFromUrl(urlString: String, indexPath: NSIndexPath) {
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    if var cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                        (cell as! UserDetailsTableViewCell).schoolImageVirw.contentMode = UIViewContentMode.ScaleAspectFit;
                        (cell as! UserDetailsTableViewCell).schoolImageVirw.makeMyselfCircle()
                        (cell as! UserDetailsTableViewCell).schoolImageVirw?.image = image
                        (cell as! UserDetailsTableViewCell).bigUsosImage?.image = image


                    }

                }
            }
        })
        task.resume()
    }
}
