//
//  UsosesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UsosesTableViewController: UITableViewController,UsosesProviderDelegate {

    private let UsosCellIdentifier = "reusableUsosCell"
    private let usosProvider = UsosesProvider()
    private var usosList :Array<Usos> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wybierz Uczelnię"
//        self.tableView.registerClass(UsosTableViewCell.self, forCellReuseIdentifier:UsosCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "UsosTableViewCell",bundle: nil),forCellReuseIdentifier: UsosCellIdentifier)
        self.usosProvider.delegate = self
        self.usosProvider.loadUsoses()

    }


    @available(iOS 2.0, *)
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        return self.usosList.count
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell :UsosTableViewCell = tableView.dequeueReusableCellWithIdentifier(UsosCellIdentifier,forIndexPath: indexPath) as! UsosTableViewCell
        var usos = usosList[indexPath.row] as Usos
        dispatch_async(dispatch_get_main_queue()) {

            (cell as! UsosTableViewCell).imagePlace?.image = UIImage(data: NSData(contentsOfURL: NSURL(string:usos.image)!)!)
            cell.setNeedsLayout()
        }
        (cell as! UsosTableViewCell).label.text = usos.name

        return cell
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller  = SecondLoginViewController()

        self.presentViewController(controller,animated:true,completion:nil)
    }


    func onUsosesLoaded(arrayOfUsoses: Array<Usos>) {
        self.usosList = arrayOfUsoses;
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }


}
