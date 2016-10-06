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

    var userDetail: UserDetail! = nil
    var userFaculties: Array<Facultie>! = nil
    var terms: Array<Term> = Array()
    var programmes: Array<StudentProgramme> = Array()
    var programmeLoaded = false;

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserTableViewController.openDrawer), andTitle: StringHolder.appName)
        userDetailsProvider.delegate = self
        facultieProvider.delegate = self
        termsProvider.delegate = self
        programmeProvider.delegate = self;
        addNavigationSeparator()
        view.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView =  UIView()
        self.tableView.registerNib(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: usedDetailCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: FacultieProgrammeCellId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: termsCellId)
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.lightGray()
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.kujonBlueColor()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(UserTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshingManually()
        self.navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        loadData()
    }

    private func addNavigationSeparator() {
        guard let navigationController = self.navigationController else {
            return
        }
        let navigationBar = navigationController.navigationBar
        let navigationSeparator = UIView(frame: CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 2))
        navigationSeparator.backgroundColor = UIColor.kujonBlueColor()// Here your custom color
        navigationSeparator.opaque = true
        navigationController.navigationBar.addSubview(navigationSeparator)
        let constraints: [NSLayoutConstraint] = [
            navigationSeparator.leadingAnchor.constraintEqualToAnchor(navigationBar.leadingAnchor),
            navigationSeparator.trailingAnchor.constraintEqualToAnchor(navigationBar.trailingAnchor),
        ]
            NSLayoutConstraint.activateConstraints(constraints)
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

    func onUserDetailLoaded(userDetail: UserDetail) {
        self.userDetail = userDetail;
        self.programmes = userDetail.studentProgrammes
        self.tableView.reloadData()
        self.userDataHolder.userName  = userDetail.firstName + " " + userDetail.lastName
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
       return userDetail == nil ? 0 : 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return userDetail == nil ? 0 : 1
        case 1: return userDetail == nil ? 0 : userDetail.studentProgrammes.count
        case 2: return userFaculties == nil ? 0 : userFaculties.count
        case 3: return userDetail == nil ? 0 : 2
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section) {
        case 0: cell = self.configureUserDetails(indexPath)
        case 1: cell = self.configureStudentProgrammeCell(indexPath)
        case 2: cell = self.configureFacultieCell(indexPath)
        case 3: cell = self.configureStatsCellForIndexPath(indexPath)
        default: cell = self.configureUserDetails(indexPath)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellPosition: (section: Int, row: Int) = (section:indexPath.section, row:indexPath.row)
        switch (cellPosition) {
        case (section:1, row: _):
            clicked(indexPath)
        case (section:2, row: _):
            clickedFacultie(indexPath)
        case (section:3, row: 0):
            clickedTermsCell()
        case (section:3, row: 1):
            clickedThesesCell()
        default:
            break;
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 196
        case 1: return 51
        case 2: return 51;
        default: return 51
        }
    }


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0
        case 1: return 51
        case 2: return 51;
        case 3: return 51;
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
        case 1: return createLabelForSectionTitle(StringHolder.kierunki)
        case 2: return createLabelForSectionTitle(StringHolder.faculties)
        case 3: return createLabelForSectionTitle(StringHolder.statistics)
        default: return nil
        }
    }


    private func configureUserDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(usedDetailCellId, forIndexPath: indexPath) as! UserDetailsTableViewCell
        cell.nameSurnameLabel.text = userDetail.firstName + " " + userDetail.lastName
        cell.studentStatusLabel.text = userDetail.studentStatus
//        cell.schoolNameLabel.text = userDetails.usosName
        cell.indexNumberLabel.text = userDetail.studentNumber
        cell.accountNumberLabel.text = userDetail.id
        cell.userImageView.makeMyselfCircleWithBorder()
        cell.userImageView.image = UIImage(named: "user-placeholder")
        if (userDetail.hasPhoto) {
            self.restImageProvider.loadImage("", urlString: self.userDetail.photoUrl!, onImageLoaded: self)

        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserTableViewController.imageTapped))
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

    private func configureStatsCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FacultieProgrammeCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell

        let termsIndex: Int = 0
        let thesesIndex: Int = 1
        var itemName: String = ""
        var itemsCount: Int = 0

        switch indexPath.row {
        case termsIndex:
            itemsCount = terms.count
            itemName = StringHolder.cycles
        case thesesIndex:
            itemsCount = userDetail.theses == nil ? 0 : userDetail.theses!.count
            itemName = StringHolder.theses
        default:
            fatalError("Unidentified cell row in stats section")
        }

        cell.plainLabel.text = itemName + " (" + String(itemsCount) + ")"
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
            }else {
                programmeLoaded = false
                programmeProvider.loadProgramme()
            }
        }

    }

    func clickedFacultie(forIndexPath: NSIndexPath) {
        let myFac: Facultie = self.userFaculties[forIndexPath.row]
        let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: NSBundle.mainBundle())
        faculiteController.facultie = myFac
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }

    private func clickedTermsCell() {
        if (terms.count != 0) {
            let termsController = TermsTableViewController()
            self.navigationController?.pushViewController(termsController, animated: true)
            termsController.setUpTerms(self.terms)
        }
    }

    private func clickedThesesCell() {
        if (userDetail.theses?.count > 0) {
            let thesesTableViewController = ThesesTableViewController()
            thesesTableViewController.theses = userDetail.theses
            self.navigationController?.pushViewController(thesesTableViewController, animated: true)
        }
    }

    private func loadImageFromUrl(urlString: String?, indexPath: NSIndexPath) {
        guard
            let urlString = urlString,
            let url = NSURL(string: urlString) else {
            return
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { [weak self] data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data) else {
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                if let cell = self?.tableView.cellForRowAtIndexPath(indexPath) as? UserDetailsTableViewCell {
                    cell.schoolImageVirw.contentMode = .ScaleAspectFit;
                    cell.schoolImageVirw.makeMyselfCircle()
                    cell.schoolImageVirw?.image = image;
                    cell.bigUsosImage?.image = image
                }
            }
        })
        task.resume()
    }
}
