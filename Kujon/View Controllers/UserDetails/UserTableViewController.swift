//
//  UserTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

private func <<T:Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func ><T:Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class UserTableViewController: RefreshingTableViewController
        , NavigationDelegate
        , SuperUserDetailsProviderDelegate
        , OnImageLoadedFromRest,
        UsosesProviderDelegate {

    weak var delegate: NavigationMenuProtocol! = nil
    private let usedDetailCellId = "userDetailViewId"
    private let StudentProgrammeCellId = "cellIdForStudentProgramme"
    private let FacultieProgrammeCellId = "cellIdForStudentFacultie"
    private let termsCellId = "termsCellId"
    let superUserProvider: SuperUserProvider! = ProvidersProviderImpl.sharedInstance.provideSuperUserProvider()
    let restImageProvider = RestImageProvider.sharedInstance
    private let userDataHolder = UserDataHolder.sharedInstance
    private let usosesProvider = ProvidersProviderImpl.sharedInstance.provideUsosesProvider()
    
    var userDetail: SuperUserDetails! = nil
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
        superUserProvider.delegate = self
        addToProvidersList(provider: superUserProvider)
        addNavigationSeparator()
        view.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: usedDetailCellId)
        self.tableView.register(UINib(nibName: "AccessoryItemCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
        self.tableView.register(UINib(nibName: "AccessoryItemCell", bundle: nil), forCellReuseIdentifier: FacultieProgrammeCellId)
        self.tableView.register(UINib(nibName: "AccessoryItemCell", bundle: nil), forCellReuseIdentifier: termsCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()

    }

    private func addNavigationSeparator() {
        guard let navigationController = self.navigationController else {
            return
        }
        let navigationBar = navigationController.navigationBar
        let navigationSeparator = UIView(frame: CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 2))
        navigationSeparator.backgroundColor = UIColor.kujonBlueColor()
        navigationSeparator.isOpaque = true
        navigationSeparator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        navigationController.navigationBar.addSubview(navigationSeparator)

    }

    override func loadData() {
        superUserProvider.loadUserDetail()
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onUserDetailLoaded(_ userDetails: SuperUserDetails) {
        self.userDetail = userDetails
        self.programmes = userDetails.studentProgrammes
        programmeLoaded = true
        self.terms = userDetails.terms
        self.userFaculties = userDetails.faculties
        self.tableView.reloadData()
        self.userDataHolder.userName = userDetail.firstName + " " + userDetail.lastName
        refreshControl?.endRefreshing()
        loadUSOSImageIfNeeded()
    }


    func onErrorOccurs(_ text: String, retry: Bool) {
        if retry {
            superUserProvider.loadUserDetail()
            return
        }

        self.showAlertApi(StringHolder.attention, text: text, succes: {
            [unowned self] in
            self.superUserProvider.loadUserDetail()
        }, cancel: {
            [unowned self] in
                self.refreshControl?.endRefreshing()
        })
    }


    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    
    func loadUSOSImageIfNeeded() {
        if userDataHolder.userUsosImage == nil {
            usosesProvider.delegate = self
            usosesProvider.loadUsoses()
        }
    }

    func onUsosesLoaded(_ arrayOfUsoses: Array<Usos>) {
        for usos in arrayOfUsoses {
            if usos.usosId == userDetail.usosId {
                UserDataHolder.sharedInstance.userUsosImage = usos.image
                tableView.reloadData()
                return
            }
        }
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
        switch (indexPath.section) {
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
        let cellPosition: (section: Int, row: Int) = (section: indexPath.section, row: indexPath.row)
        switch (cellPosition) {
        case (section:1, row:_):
            clicked(indexPath)
        case (section:2, row:_):
            clickedFacultie(indexPath)
        case (section:3, row:0):
            clickedTermsCell()
        case (section:3, row:1):
            clickedThesesCell()
        default:
            break;
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
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


    private func configureUserDetails(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: usedDetailCellId, for: indexPath) as! UserDetailsTableViewCell
        cell.nameSurnameLabel.text = userDetail.firstName + " " + userDetail.lastName
        cell.studentStatusLabel.text = userDetail.studentStatus
        cell.indexNumberLabel.text = userDetail.studentNumber
        cell.accountNumberLabel.text = userDetail.id
        cell.userImageView.makeMyselfCircleWithBorder()
        cell.userImageView.image = UIImage(named: "user-placeholder")
        if (userDetail.photoUrl != nil && restImageProvider.isFetching == false) {
            self.restImageProvider.loadImage("", urlString: self.userDetail.photoUrl!, onImageLoaded: self)

        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.userImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.userImageView.isUserInteractionEnabled = true
        if restImageProvider.isFetching == false {
            self.loadImageFromUrl(UserDataHolder.sharedInstance.userUsosImage, indexPath: indexPath)
        }
        return cell
    }

    func imageTapped(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag as Any)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: Bundle.main)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailsTableViewCell
            imageController.image = cell.userImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture, forDuration: 2.0)
        }
    }
    private var isThereImage = false;

    func imageLoaded(_ tag: String, image: UIImage) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailsTableViewCell
        cell.userImageView.image = image
        self.userDataHolder.userImage = image
        isThereImage = true
    }

    private func configureStudentProgrammeCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentProgrammeCellId, for: indexPath) as! AccessoryItemCell
        let myProgramme: StudentProgramme = self.programmes[indexPath.row]
        cell.titleLabel.text = myProgramme.programme.nameShort
        cell.setStyle(.arrowRight)
        return cell
    }

    private func configureFacultieCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacultieProgrammeCellId, for: indexPath) as! AccessoryItemCell
        let myFac: Facultie = self.userFaculties[indexPath.row]
        cell.titleLabel.text = myFac.name
        cell.setStyle(.arrowRight)
        return cell
    }

    private func configureStatsCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacultieProgrammeCellId, for: indexPath) as! AccessoryItemCell

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
        cell.setStyle(.arrowRight)
        cell.titleLabel.text = itemName + " (" + String(itemsCount) + ")"
        return cell
    }

    func clicked(_ indexPath: IndexPath) {
        guard programmeLoaded else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard
                let programme: Programme = self?.programmes[indexPath.row].programme,
                let schoolPath: SchoolPath = self?.programmes[indexPath.row].programme.schoolPath else {
                return
            }
            let kierunekDetailController = KierunekDetailViewControllerECTS()
            kierunekDetailController.configureViewController(programme: programme, schoolPath: schoolPath)
            self?.navigationController?.pushViewController(kierunekDetailController, animated: true)
        }

    }

    func clickedFacultie(_ forIndexPath: IndexPath) {
        let myFac: Facultie = self.userFaculties[(forIndexPath as NSIndexPath).row]
        DispatchQueue.main.async { [weak self] in
            let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
            faculiteController.facultie = myFac
            self?.navigationController?.pushViewController(faculiteController, animated: true)
        }
    }

    private func clickedTermsCell() {
        if (terms.count != 0) {
            DispatchQueue.main.async { [weak self] in
                let termsController = TermsTableViewController()
                self?.navigationController?.pushViewController(termsController, animated: true)
                if let terms = self?.terms {
                    termsController.setUpTerms(terms)
                }
            }
        }
    }

    private func clickedThesesCell() {
        if (userDetail.theses?.count > 0) {
            DispatchQueue.main.async { [weak self] in
                let thesesTableViewController = ThesesTableViewController()
                thesesTableViewController.theses = self?.userDetail.theses
                self?.navigationController?.pushViewController(thesesTableViewController, animated: true)
            }
        }
    }

    private func loadImageFromUrl(_ urlString: String?, indexPath: IndexPath) {
        guard
        let urlString = urlString,
        let url = URL(string: urlString) else {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            [weak self] data, response, error in
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
