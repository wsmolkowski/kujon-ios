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
    private let usosProvider = ProvidersProviderImpl.sharedInstance.provideUsosesProvider()
    private var usosList :Array<Usos> = Array()
    let userDataHolder = UserDataHolder.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wybierz Uczelnię"
        self.tableView.registerNib(UINib(nibName: "UsosTableViewCell",bundle: nil),forCellReuseIdentifier: UsosCellIdentifier)
        self.usosProvider.delegate = self
        self.usosProvider.loadUsoses()

    }


    @available(iOS 2.0, *)
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        return self.usosList.count
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell :UsosTableViewCell = tableView.dequeueReusableCellWithIdentifier(UsosCellIdentifier,forIndexPath: indexPath) as! UsosTableViewCell
        var usos = usosList[indexPath.row] as Usos
        cell.usosImageView?.contentMode = UIViewContentMode.ScaleAspectFit;
        cell.usosImageView?.clipsToBounds = true
        cell.usosImageView?.image = nil
        self.loadImage(usos.image,indexPath: indexPath)
        (cell as! UsosTableViewCell).label.text = usos.name

        return cell
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller  = SecondLoginViewController()
        var usos = usosList[indexPath.row] as Usos
        userDataHolder.usosId = usos.usosId
        self.presentViewController(controller,animated:true,completion:nil)
    }


    func onUsosesLoaded(arrayOfUsoses: Array<Usos>) {
        self.usosList = arrayOfUsoses;
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }

    private func loadImage(urlString:String,indexPath:NSIndexPath){
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            if(data != nil ){
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    if var cell = self.tableView.cellForRowAtIndexPath(indexPath){
                        (cell as! UsosTableViewCell).usosImageView?.contentMode = UIViewContentMode.ScaleAspectFit;
                        (cell as! UsosTableViewCell).usosImageView?.image = image


                    }

                }
            }
        })
        task.resume()
    }
}
