//
//  ActiveCoursesListTableViewController
//  Kujon
//
//  Created by Adam on 06.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

class ActiveCoursesListTableViewController: RefreshingTableViewController, NavigationDelegate, CourseProviderDelegate, TermsProviderDelegate {
    private let CourseCellId = "courseCellId"
    private let courseProvider = ProvidersProviderImpl.sharedInstance.provideCourseProvider()
    private let termsProvider = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    private var coursesWrappers: [CoursesWrapper] =  []
    private var activeCoursesWrappers: [CoursesWrapper] =  []
    private var terms: [Term] =  []
    weak var delegate: NavigationMenuProtocol! = nil
    private var coursesDidLoad: Bool = false
    private var termsDidLoad: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CoursesTableViewController.openDrawer),andTitle: StringHolder.filesForCourses)
        self.tableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseCellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140

        courseProvider.delegate = self
        termsProvider.delegate = self
        addToProvidersList(provider:courseProvider)
        addToProvidersList(provider:termsProvider)
    }

    override func loadData() {
        courseProvider.provideCourses()
        termsProvider.loadTerms()
    }

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: - Data Providers

    func coursesProvided(_ courses: [CoursesWrapper]) {
        self.coursesWrappers = courses;
        coursesDidLoad = true
        if termsDidLoad {
            dataDidLoad()
        }
    }

    func onTermsLoaded(_ terms: [Term]) {
        self.terms = terms
        termsDidLoad = true
        if coursesDidLoad {
            dataDidLoad()
        }
    }

    func dataDidLoad() {
        activeCoursesWrappers = []
        for courseWrapper in coursesWrappers {
                for term in terms {
                    if term.active && term.termId == courseWrapper.title  {
                        activeCoursesWrappers.append(courseWrapper)
                    }
                }
        }

        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {
        coursesWrappers = []
        activeCoursesWrappers = []
        termsDidLoad = false
        coursesDidLoad = false
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            [unowned self] in
            self.loadData()
            }, cancel: { [unowned self] in
                self.refreshControl?.endRefreshing()
        })
    }

    func onUsosDown() {
        coursesWrappers = []
        activeCoursesWrappers = []
        termsDidLoad = false
        coursesDidLoad = false
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.endRefreshing()
            guard let strongSelf = self else {
                return
            }
            self?.tableView.visibleCells.forEach { $0.isHidden = true }
            EmptyStateView.showUsosDownAlert(inParent: strongSelf.view)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return activeCoursesWrappers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeCoursesWrappers[section].courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCellId, for: indexPath) as! CourseTableViewCell
        let course = activeCoursesWrappers[indexPath.section].courses[indexPath.row]  as Course
        cell.courseNameLabel.text = course.courseName
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = createLabelForSectionTitle(activeCoursesWrappers[section].title, middle: true)
        return header
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = activeCoursesWrappers[indexPath.section].courses[indexPath.row] as Course
        let storyboard = UIStoryboard.init(name: "SharedFilesViewController", bundle: nil)
        let sharedFilesController = storyboard.instantiateViewController(withIdentifier: "SharedFilesViewController") as! SharedFilesViewController
        sharedFilesController.courseId = course.courseId
        sharedFilesController.termId = course.termId
        sharedFilesController.courseName = course.courseName
        navigationController?.pushViewController(sharedFilesController, animated: true)
    }


}
