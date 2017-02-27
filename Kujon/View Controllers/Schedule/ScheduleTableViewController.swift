//
//  ScheduleTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 20/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ScheduleTableViewController:
        UITableViewController,
        NavigationDelegate,
        LectureProviderDelegate {

    weak var delegate: NavigationMenuProtocol! = nil
    let lectureProvider = ProvidersProviderImpl.sharedInstance.provideLectureProvider()
    static let LectureCellId = "lectureCellId"
    static let DayCellId = "dayCellId"
    static let textId = "simpleTextId"
    private let floatingButtonDelegate = FloatingButtonDelegate()
    var isQuering = false
    var lastQueryDate: Date! = nil
    var firstDate: Date! = nil
    var sectionsArray: Array<ScheduleSection> = Array()
    var todaySection: Int = 0
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(ScheduleTableViewController.openDrawer), andTitle: StringHolder.schedule)

        let openCalendarButton = UIBarButtonItem(image: UIImage(named: "calendar"), style: UIBarButtonItemStyle.plain, target: self,
                action: #selector(ScheduleTableViewController.openCalendar))
        self.navigationItem.rightBarButtonItem = openCalendarButton

//        lastQueryDate = NSDate.stringToDate("2015-05-05")
        lastQueryDate = Date.getCurrentStartOfWeek()
        todaySection = lastQueryDate.numberOfDaysUntilDateTime(toDateTime: lastQueryDate, calendar: Calendar.current)
        self.tableView.register(UINib(nibName: "LectureTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.LectureCellId)
        self.tableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.DayCellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        lectureProvider.delegate = self
        askForData()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(ScheduleTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lectureProvider.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.floatingButtonDelegate.viewWillAppear(self, selector: #selector(ScheduleTableViewController.onTodayClick))
    }

    override func viewWillDisappear(_ animated: Bool) {
        floatingButtonDelegate.viewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func onTodayClick() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: todaySection), at: .top, animated: true)

    }


    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        sectionsArray = Array()
        onlyLectureDictionary = Dictionary()
        lastQueryDate = firstDate
        lectureProvider.reload()
        askForData()
    }


    private func askForData() {
        isQuering = true
        for n in 0 ... 6 {
            sectionsArray.append(ScheduleSectionImpl(withDate: lastQueryDate.addDays(n).dateToStringSchedule(), listOfLecture: Array()))
        }
        lectureProvider.loadLectures(lastQueryDate.dateToString())
    }

    func onLectureLoaded(_ lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in LectureWrapper(lecture: lecture)
        }

        let dictionaryOfDays = wrappers.groupBy {
            $0.startDate
        }
        let sortedKeys = dictionaryOfDays.keys
        sortedKeys.forEach {
            key2 in
            let pos = getPositionOfSection(key2)
            if (pos != nil) {
                onlyLectureDictionary[key2] = dictionaryOfDays[key2]!
                let array = dictionaryOfDays[key2]!.map {
                    $0 as CellHandlingStrategy
                }
                (sectionsArray[pos!]).addToList(array)
            }
        }

        self.tableView.reloadData()
        isQuering = false
    }

    func onLectureLoaded(_ lectures: Array<Lecture>, date: Date) {
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    private func getPositionOfSection(_ text: String) -> Int! {
        return sectionsArray.index {
            $0.getSectionTitle() == text
        }
    }


    private func getScheduleSectionAtPosition(_ pos: Int) -> ScheduleSection {

        return sectionsArray[pos]
    }

    func onErrorOccurs(retry: Bool) {
        ToastView.showInParent(self.navigationController?.view, withText: StringHolder.errorOccures, forDuration: 2.0)
        isQuering = false
        if retry {
            askForData()
            return
        }
        self.refreshControl?.endRefreshing()
    }


    func onErrorOccurs(_ text: String, retry: Bool) {
        ToastView.showInParent(self.navigationController?.view, withText: text, forDuration: 2.0)
        isQuering = false
        if retry {
            askForData()
            return
        }
        self.refreshControl?.endRefreshing()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func openCalendar() {
        let calendarViewController = CalendarViewController()
        calendarViewController.onlyLectureDictionary = onlyLectureDictionary
        (calendarViewController).setNavigationProtocol(delegate!)
        calendarViewController.lastQueryDate = lastQueryDate
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionSch = getScheduleSectionAtPosition(section)
        return sectionSch.getSectionSize() == 0 ? 1 : sectionSch.getSectionSize()

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionSch = getScheduleSectionAtPosition(section)
        return createLabel(sectionSch.getSectionTitle())

    }

    private func createLabel(_ text: String) -> UIView {
        let view = HeaderViewTableViewCell.instanceFromNib()
        view.titleLabel.text = text
        return view
    }


    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let height = scrollView.frame.size.height
        let contetyYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contetyYOffset
        if (distanceFromBottom <= height) {
            NSlogManager.showLog("End of list, load more")
            if (!isQuering) {
                lastQueryDate = lastQueryDate.addingTimeInterval(60 * 60 * 24 * 7)
                askForData()
            }
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionSch = getScheduleSectionAtPosition(indexPath.section)
        if (sectionSch.getSectionSize() != 0) {
            let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
            var cell = cellStrategy.giveMeMyCell(tableView, cellForRowAtIndexPath: indexPath)
            let strategy = cellStrategy.giveMyStrategy()
            strategy.handleCell(&cell)
            return cell
        } else {

            let cell = UITableViewCell(style: .default, reuseIdentifier: ScheduleTableViewController.textId)
            cell.textLabel?.font = UIFont.kjnTextStyle2Font()
            cell.textLabel?.text = StringHolder.no_data
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionSch = getScheduleSectionAtPosition(indexPath.section)
        let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
        cellStrategy.handleClick(self.navigationController)
    }


}
