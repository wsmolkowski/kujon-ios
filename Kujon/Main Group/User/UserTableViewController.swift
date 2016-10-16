//
//  UserTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class UserTableViewController: UITableViewController
        , NavigationDelegate
        , UserDetailsProviderDelegate
        , FacultiesProviderDelegate
        , OnImageLoadedFromRest
        , TermsProviderDelegate
        , ProgrammeProviderDelegate {

    weak var delegate: NavigationMenuProtocol! = nil
    fileprivate let usedDetailCellId = "userDetailViewId"
    fileprivate let StudentProgrammeCellId = "cellIdForStudentProgramme"
    fileprivate let FacultieProgrammeCellId = "cellIdForStudentFacultie"
    fileprivate let termsCellId = "termsCellId"
    let userDetailsProvider: UserDetailsProvider! = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    let facultieProvider: FacultiesProvider! = ProvidersProviderImpl.sharedInstance.providerFacultiesProvider()
    let termsProvider: TermsProvider! = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    let programmeProvider: ProgrammeProvider! = ProvidersProviderImpl.sharedInstance.provideProgrammeProvider()
    let restImageProvider = RestImageProvider.sharedInstance
    fileprivate let userDataHolder = UserDataHolder.sharedInstance

    var userDetail: UserDetail! = nil
    var userFaculties: Array<Facultie>! = nil
    var terms: Array<Term> = Array()
    var programmes: Array<StudentProgramme> = Array()
    var programmeLoaded = false;

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
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
        view.backgroundColor = UIColor.white
        self.tableView.tableFooterView =  UIView()
        self.tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: usedDetailCellId)
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: FacultieProgrammeCellId)
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: termsCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightGray()
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.kujonBlueColor()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(UserTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.beginRefreshingManually()
        self.navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        loadData()
    }

    fileprivate func addNavigationSeparator() {
        guard let navigationController = self.navigationController else {
            return
        }
        let navigationBar = navigationController.navigationBar
        let navigationSeparator = UIView(frame: CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 2))
        navigationSeparator.backgroundColor = UIColor.kujonBlueColor()// Here your custom color
        navigationSeparator.isOpaque = true
        navigationController.navigationBar.addSubview(navigationSeparator)
        let constraints: [NSLayoutConstraint] = [
            navigationSeparator.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            navigationSeparator.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
        ]
            NSLayoutConstraint.activate(constraints)
    }

    func refresh(_ refreshControl: UIRefreshControl) {
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
    fileprivate func loadData(){
        userDetailsProvider.loadUserDetail()
        facultieProvider.loadFaculties()
        termsProvider.loadTerms()
        programmeProvider.loadProgramme()
    }

    func onUserDetailLoaded(_ userDetail: UserDetail) {
        self.userDetail = userDetail;
        self.programmes = userDetail.studentProgrammes
        self.tableView.reloadData()
        self.userDataHolder.userName  = userDetail.firstName + " " + userDetail.lastName
        refreshControl?.endRefreshing()
    }

    func onFacultiesLoaded(_ list: Array<Facultie>) {
        self.userFaculties = list
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func onProgrammeLoaded(_ terms: Array<StudentProgramme>) {
        self.programmes = terms;
        programmeLoaded = true;
        refreshControl?.endRefreshing()
    }


    func onTermsLoaded(_ terms: Array<Term>) {
        self.terms = terms
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }


    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.userDetailsProvider.loadUserDetail()
            self.facultieProvider.loadFaculties()
        }, cancel: {})
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return userDetail == nil ? 0 : 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return userDetail == nil ? 0 : 1
        case 1: return userDetail == nil ? 0 : userDetail.studentProgrammes.count
        case 2: return userFaculties == nil ? 0 : userFaculties.count
        case 3: return userDetail == nil ? 0 : 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch ((indexPath as NSIndexPath).section) {
        case 0: cell = self.configureUserDetails(indexPath)
        case 1: cell = self.configureStudentProgrammeCell(indexPath)
        case 2: cell = self.configureFacultieCell(indexPath)
        case 3: cell = self.configureStatsCellForIndexPath(indexPath)
        default: cell = self.configureUserDetails(indexPath)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellPosition: (section: Int, row: Int) = (section:(indexPath as NSIndexPath).section, row:(indexPath as NSIndexPath).row)
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ((indexPath as NSIndexPath).section) {
        case 0: return 196
        case 1: return 51
        case 2: return 51;
        default: return 51
        }
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0
        case 1: return 51
        case 2: return 51;
        case 3: return 51;
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
        case 1: return createLabelForSectionTitle(StringHolder.kierunki)
        case 2: return createLabelForSectionTitle(StringHolder.faculties)
        case 3: return createLabelForSectionTitle(StringHolder.statistics)
        default: return nil
        }
    }


    fileprivate func configureUserDetails(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: usedDetailCellId, for: indexPath) as! UserDetailsTableViewCell
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
        cell.userImageView.isUserInteractionEnabled = true
        self.loadImageFromUrl(UserDataHolder.sharedInstance.userUsosImage, indexPath: indexPath)
        return cell
    }

    func imageTapped(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: Bundle.main)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailsTableViewCell
            imageController.image = cell.userImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture, forDuration: 2.0)
        }
    }
    fileprivate var isThereImage = false;

    func imageLoaded(_ tag: String, image: UIImage) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailsTableViewCell
        cell.userImageView.image = image
        self.userDataHolder.userImage  = image
        isThereImage = true
    }

    fileprivate func configureStudentProgrammeCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentProgrammeCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let myProgramme: StudentProgramme = self.programmes[(indexPath as NSIndexPath).row]
        cell.plainLabel.text = myProgramme.programme.description
        return cell
    }

    fileprivate func configureFacultieCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacultieProgrammeCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let myFac: Facultie = self.userFaculties[(indexPath as NSIndexPath).row]
        cell.plainLabel.text = myFac.name
        return cell
    }

    fileprivate func configureStatsCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacultieProgrammeCellId, for: indexPath) as! GoFurtherViewCellTableViewCell

        let termsIndex: Int = 0
        let thesesIndex: Int = 1
        var itemName: String = ""
        var itemsCount: Int = 0

        switch (indexPath as NSIndexPath).row {
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

    func clicked(_ forIndexPath: IndexPath) {
        if (programmeLoaded) {
            let myProgramme: StudentProgramme = self.programmes[(forIndexPath as NSIndexPath).row]
            if (myProgramme.programme.duration != nil && myProgramme.programme.name != nil && myProgramme.programme.levelOfStudies != nil) {
                let popController = KierunkiViewController(nibName: "KierunkiViewController", bundle: Bundle.main)
                popController.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(popController, animated: false, completion: { popController.showAnimate(); })

                popController.showInView(withProgramme: myProgramme.programme)
            }else {
                programmeLoaded = false
                programmeProvider.loadProgramme()
            }
        }

    }

    func clickedFacultie(_ forIndexPath: IndexPath) {
        let myFac: Facultie = self.userFaculties[(forIndexPath as NSIndexPath).row]
        let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
        faculiteController.facultie = myFac
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }

    fileprivate func clickedTermsCell() {
        if (terms.count != 0) {
            let termsController = TermsTableViewController()
            self.navigationController?.pushViewController(termsController, animated: true)
            termsController.setUpTerms(self.terms)
        }
    }

    fileprivate func clickedThesesCell() {
        if (userDetail.theses?.count > 0) {
            let thesesTableViewController = ThesesTableViewController()
            thesesTableViewController.theses = userDetail.theses
            self.navigationController?.pushViewController(thesesTableViewController, animated: true)
        }
    }

    fileprivate func loadImageFromUrl(_ urlString: String?, indexPath: IndexPath) {
        guard
            let urlString = urlString,
            let url = URL(string: urlString) else {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                if let cell = self?.tableView.cellForRow(at: indexPath) as? UserDetailsTableViewCell {
                    cell.schoolImageVirw.contentMode = .scaleAspectFit;
                    cell.schoolImageVirw.makeMyselfCircle()
                    cell.schoolImageVirw?.image = image;
                    cell.bigUsosImage?.image = image
                }
            }
        })
        task.resume()
    }
}
