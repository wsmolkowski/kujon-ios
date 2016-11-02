//
//  CoursesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CoursesTableViewController: RefreshingTableViewController, NavigationDelegate,CourseProviderDelegate, TermsProviderDelegate {
    private let CourseCellId = "courseCellId"
    private let courseProvider = ProvidersProviderImpl.sharedInstance.provideCourseProvider()
    private let termsProvider = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    private var courseWrappers = Array<CoursesWrapper>()
    weak var delegate: NavigationMenuProtocol! = nil
    private var selectedTermId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CoursesTableViewController.openDrawer),andTitle: StringHolder.courses)
        self.tableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseCellId)
        courseProvider.delegate = self
        courseProvider.provideCourses()
        termsProvider.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
    }

    override func loadData() {
        courseProvider.provideCourses()
    }

    override func clearCachedResponse() {
        courseProvider.reload()
    }


    func coursesProvided(_ courses: Array<CoursesWrapper>) {

        self.courseWrappers = courses;
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()

    }
    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            [unowned self] in
            self.courseProvider.provideCourses()
        }, cancel: {})
    }


    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return courseWrappers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseWrappers[section].courses.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.course = course
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCellId, for: indexPath) as! CourseTableViewCell
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course

        cell.courseNameLabel.text = course.courseName
        cell.selectionStyle = UITableViewCellSelectionStyle.none


        return cell
    }



    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = createLabelForSectionTitle(courseWrappers[section].title, middle: true)
        let tapRecognizer = IdentifiedTapGestureRecognizer(target: self, action: #selector(CoursesTableViewController.headerDidTap(with:)))
        tapRecognizer.id = section
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        header.addGestureRecognizer(tapRecognizer)
        return header
    }

    // MARK: Term Detail Popup

    func headerDidTap(with tapGestureRecognizer: IdentifiedTapGestureRecognizer) {
        let section = tapGestureRecognizer.id
        selectedTermId = courseWrappers[section].courses[0].termId
        termsProvider.loadTerms()

    }

    private func presentPopUpWithTerm(_ term:Term) {
        let termPopUp = TermsPopUpViewController(nibName: "TermsPopUpViewController", bundle: nil)
        termPopUp.modalPresentationStyle = .overCurrentContext
        present(termPopUp, animated: false) { [unowned termPopUp] in
            termPopUp.showAnimate();
        }
        termPopUp.showInView(term)
    }

    // MARK: TermsProviderDelegate

    func onTermsLoaded(_ terms: Array<Term>) {
        guard let termId = selectedTermId else {
            return
        }
        for term in terms {
            if term.termId == termId {
                presentPopUpWithTerm(term)
                break
            }
        }
        selectedTermId = nil
    }

}
