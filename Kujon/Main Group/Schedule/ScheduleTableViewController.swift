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
    private let floatingSize: CGFloat = 55.0
    private let floatingMargin: CGFloat = 15.0
    private var floatingButton: UIButton! = nil
    var isQuering = false
    var lastQueryDate: NSDate! = nil
    var firstDate: NSDate! = nil
    var sectionsArray: Array<ScheduleSection> = Array()
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(ScheduleTableViewController.openDrawer), andTitle: StringHolder.schedule)

        let openCalendarButton = UIBarButtonItem(image: UIImage(named: "calendar"), style: UIBarButtonItemStyle.Plain, target: self,
                action: #selector(ScheduleTableViewController.openCalendar))
        self.navigationItem.rightBarButtonItem = openCalendarButton

//        lastQueryDate = NSDate.stringToDate("2015-05-05")
        lastQueryDate = NSDate.getCurrentStartOfWeek()
        firstDate = lastQueryDate
        self.tableView.registerNib(UINib(nibName: "LectureTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.LectureCellId)
        self.tableView.registerNib(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.DayCellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        lectureProvider.delegate = self
        askForData()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

    }

    private func addFloatingButton() {
        floatingButton = UIButton(type: .Custom)
        let xPos = self.view.frame.size.width - floatingSize - floatingMargin
        let yPos = self.view.frame.origin.y + self.view.frame.size.height - floatingSize - floatingMargin
        floatingButton?.frame = CGRectMake(xPos, yPos, floatingSize, floatingSize)
        floatingButton?.setTitle(NSDate().getDayMonth(), forState: .Normal)
        floatingButton?.addTarget(self, action: #selector(ScheduleTableViewController.onTodayClick), forControlEvents: UIControlEvents.TouchUpInside)
        floatingButton?.titleLabel?.font = UIFont.kjnTextStyleFont()
        floatingButton?.backgroundColor = UIColor.kujonBlueColor()
        floatingButton?.makeMyselfCircle()
        self.navigationController?.view.addSubview(floatingButton!)
    }
    override func viewWillDisappear(animated: Bool) {
        floatingButton.removeFromSuperview()
        super.viewWillDisappear(animated)
    }
    func onTodayClick() {

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addFloatingButton()
        lectureProvider.delegate = self
    }



    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        sectionsArray = Array()
        onlyLectureDictionary = Dictionary()
        lastQueryDate = firstDate
        lectureProvider.reload()
        askForData()
    }


    private func askForData() {
        isQuering = true
        let keyOfQuerry = lastQueryDate.getMonthYearString()
        if (sectionsArray.count == 0 || sectionsArray[sectionsArray.count - 1].getSectionTitle() != keyOfQuerry) {
            sectionsArray.append(ScheduleSectionImpl(withDate: keyOfQuerry, listOfLecture: Array()))
        }
        lectureProvider.loadLectures(lastQueryDate.dateToString())
    }

    func onLectureLoaded(lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in LectureWrapper(lecture: lecture)
        }
        let dicMonthYear = wrappers.groupBy {
            $0.monthYearNSDate
        }
        let sortedKeys = dicMonthYear.keys

        sortedKeys.forEach {
            key2 in
            let key = key2.getMonthYearString();
            var list = Array<CellHandlingStrategy>()
            for section in sectionsArray {
                if (section.getSectionTitle() == key) {
                    list = section.getList()
                }
            }
            var dict = dicMonthYear[key2]!.groupBy {
                $0.startDate
            }
            for day in dict.keys {
                onlyLectureDictionary[day] = dict[day]
            }
            handleAddingToArray(key, oldList: list, dicdays: dict)
        }

        self.tableView.reloadData()
        isQuering = false
        self.refreshControl?.endRefreshing()
    }


    private func handleAddingToArray(key: String, oldList: Array<CellHandlingStrategy> = Array(), dicdays: Dictionary<String, [LectureWrapper]>) {

        let sortedKeysDays = Array(dicdays.keys).sort(<)
        var listOfCellStrategys: Array<CellHandlingStrategy> = Array()
        sortedKeysDays.forEach {
            dayKey in
            listOfCellStrategys.append(DayWrapper(withDayTime: dayKey))
            dicdays[dayKey]!.forEach {
                wrap in
                listOfCellStrategys.append(wrap as! CellHandlingStrategy)
            }
        }

        var condition = true
        if (sectionsArray.count > 0) {
            for index in 0 ... sectionsArray.count - 1 {
                if (key == sectionsArray[index].getSectionTitle()) {
                    sectionsArray[index] = ScheduleSectionImpl(withDate: key, listOfLecture: oldList + listOfCellStrategys)
                    condition = false
                }
            }
        }
        if (condition) {
            sectionsArray.append(ScheduleSectionImpl(withDate: key, listOfLecture: oldList + listOfCellStrategys))
        }
    }

    private func getScheduleSectionAtPosition(pos: Int) -> ScheduleSection {

        return sectionsArray[pos]
    }

    func onErrorOccurs() {
        ToastView.showInParent(self.navigationController?.view, withText: StringHolder.errorOccures, forDuration: 2.0)
        isQuering = false
        self.refreshControl?.endRefreshing()
    }


    func onErrorOccurs(text: String) {
        ToastView.showInParent(self.navigationController?.view, withText: text, forDuration: 2.0)
        isQuering = false
        self.refreshControl?.endRefreshing()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func openCalendar() {
        let calendarViewController = CalendarViewController()
        calendarViewController.onlyLectureDictionary = onlyLectureDictionary
        calendarViewController.setNavigationProtocol(delegate!)
        calendarViewController.lastQueryDate = lastQueryDate
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionSch = getScheduleSectionAtPosition(section)
        return sectionSch.getSectionSize() == 0 ? 1 : sectionSch.getSectionSize()

    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionSch = getScheduleSectionAtPosition(section)
        return createLabel(sectionSch.getSectionTitle())

    }

    private func createLabel(text: String) -> UIView {
        let view = HeaderViewTableViewCell.instanceFromNib()
        view.titleLabel.text = text
        return view
    }


    @available(iOS 2.0, *) override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let height = scrollView.frame.size.height
        let contetyYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contetyYOffset
        if (distanceFromBottom <= height) {
            NSlogManager.showLog("End of list, load more")
            if (!isQuering) {
                lastQueryDate = lastQueryDate.dateByAddingTimeInterval(60 * 60 * 24 * 7)
                askForData()
            }
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var sectionSch = getScheduleSectionAtPosition(indexPath.section)
        if (sectionSch.getSectionSize() != 0) {
            let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
            var cell = cellStrategy.giveMeMyCell(tableView, cellForRowAtIndexPath: indexPath)
            let strategy = cellStrategy.giveMyStrategy()
            strategy.handleCell(&cell)
            return cell
        } else {

            var cell = UITableViewCell(style: .Default, reuseIdentifier: ScheduleTableViewController.textId)
            cell.textLabel?.text = StringHolder.no_data
            return cell
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sectionSch = getScheduleSectionAtPosition(indexPath.section)
        let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
        cellStrategy.handleClick(self.navigationController)
    }


}
