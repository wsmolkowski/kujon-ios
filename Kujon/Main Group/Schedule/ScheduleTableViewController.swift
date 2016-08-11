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

        lastQueryDate = NSDate.stringToDate("2015-05-05")
//        lastQueryDate = NSDate.getCurrentStartOfWeek()
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
        refreshControl?.addTarget(self, action: #selector(ScheduleTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

    }

    private func addFloatingButton() {
        floatingButton = UIButton(type: .Custom)
        let xPos = self.view.frame.size.width - floatingSize - floatingMargin
        let yPos = self.view.frame.origin.y + self.view.frame.size.height - floatingSize - floatingMargin
        floatingButton?.frame = CGRectMake(xPos, yPos, floatingSize, floatingSize)
        floatingButton?.titleLabel?.numberOfLines = 2
        floatingButton?.titleLabel?.textAlignment = .Center
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
        NSlogManager.showLog("Kliknalem FABaaaa")
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)

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


        for n in 0 ... 6 {
            sectionsArray.append(ScheduleSectionImpl(withDate: lastQueryDate.addDays(n).dateToStringSchedule(), listOfLecture: Array()))
        }
        lectureProvider.loadLectures(lastQueryDate.dateToString())
    }

    func onLectureLoaded(lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in LectureWrapper(lecture: lecture)
        }
//        let dicMonthYear = wrappers.groupBy {
//            $0.monthYearNSDate
////        }
        let dictionaryOfDays = wrappers.groupBy {
            $0.startDate
        }
        let sortedKeys = dictionaryOfDays.keys
//
        sortedKeys.forEach {
            key2 in

            let pos = getPositionOfSection(key2)
            if(pos != nil){
                onlyLectureDictionary[key2] = dictionaryOfDays[key2]!
                let array = dictionaryOfDays[key2]!.map{ $0 as! CellHandlingStrategy}
                (sectionsArray[pos] as! ScheduleSection).addToList(array)

            }
        }

        self.tableView.reloadData()
        isQuering = false
    }

    private func getPositionOfSection(text:String) ->Int!{
        return sectionsArray.indexOf{$0.getSectionTitle() == text}
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
