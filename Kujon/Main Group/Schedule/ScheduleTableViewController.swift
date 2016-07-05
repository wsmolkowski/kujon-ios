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
    var isQuering = false
    var lastQueryDate: NSDate! = nil
    var sectionsDictionary: Dictionary<String, ScheduleSection> = Dictionary()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(ScheduleTableViewController.openDrawer),andTitle: "Plan Zajęć")

        let openCalendarButton = UIBarButtonItem(title: "calendar", style: UIBarButtonItemStyle.Plain, target: self,
                action: #selector(ScheduleTableViewController.openCalendar))
        self.navigationItem.rightBarButtonItem = openCalendarButton

        lastQueryDate = NSDate.getCurrentStartOfWeek()
        self.tableView.registerNib(UINib(nibName: "LectureTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.LectureCellId)
        self.tableView.registerNib(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewController.DayCellId)
        lectureProvider.delegate = self
//        lectureProvider.test = true
        askForData()

    }

    private func askForData() {
        isQuering = true
        lectureProvider.loadLectures(lastQueryDate.dateToString())
    }

    func onLectureLoaded(lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in LectureWrapper(lecture: lecture)
        }
        let dicMonthYear = wrappers.groupBy {
            $0.mothYearDate
        }
        let sortedKeys = Array(dicMonthYear.keys).sort(<)

        sortedKeys.forEach {
            key in

            var list = Array<CellHandlingStrategy>()
            if (sectionsDictionary[key] != nil) {
                let scheduleSection = sectionsDictionary[key]!
                list = scheduleSection.getList()
            }
            var dict = dicMonthYear[key]!.groupBy {
                $0.startDate
            }
            handleAddingToDictionary(key, oldList: list, dicdays: dict)
        }

        self.tableView.reloadData()
        isQuering = false
    }


    private func handleAddingToDictionary(key: String, oldList: Array<CellHandlingStrategy> = Array(), dicdays: Dictionary<String, [LectureWrapper]>) {

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
        sectionsDictionary[key] = ScheduleSectionImpl(withDate: key, listOfLecture: oldList + listOfCellStrategys)
    }

    private func getScheduleSectionAtPosition(pos: Int) -> ScheduleSection {
        var componentArray = Array(sectionsDictionary.keys).sort(<)
        return sectionsDictionary[componentArray[pos]]!
    }

    func onErrorOccurs() {

        isQuering = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func openCalendar() {
        self.navigationController?.pushViewController(CalendarViewController(), animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsDictionary.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionSch = getScheduleSectionAtPosition(section)
        return sectionSch.getSectionSize()

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
        let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
        var cell = cellStrategy.giveMeMyCell(tableView, cellForRowAtIndexPath: indexPath)
        let strategy = cellStrategy.giveMyStrategy()
        strategy.handleCell(&cell)

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sectionSch = getScheduleSectionAtPosition(indexPath.section)
        let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
        cellStrategy.handleClick(self.navigationController)
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
