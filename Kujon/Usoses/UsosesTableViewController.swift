//
//  UsosesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UsosesTableViewController: UITableViewController, UsosesProviderDelegate {

    private let UsosCellIdentifier = "reusableUsosCell"
    private let usosProvider = ProvidersProviderImpl.sharedInstance.provideUsosesProvider()
    private var usosList: Array<Usos> = Array()
    let userDataHolder = UserDataHolder.sharedInstance
    var showDemoUniversity = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringHolder.chooseUsos
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UsosesTableViewController.barTapped))
        tapGestureRecognizer.numberOfTapsRequired = 3
        self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.navigationBar.userInteractionEnabled = true
        self.tableView.registerNib(UINib(nibName: "UsosTableViewCell", bundle: nil), forCellReuseIdentifier: UsosCellIdentifier)
        self.usosProvider.delegate = self
        self.usosProvider.loadUsoses()

    }

    func barTapped(){
        self.showDemoUniversity = true
        ToastView.showInParent(self.navigationController?.view,withText: StringHolder.addedDemo, forDuration: 2.0)
        self.tableView.reloadData()
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

            return getShowDemo().count

    }

    private func getShowDemo() -> Array<Usos> {
        if (showDemoUniversity) {
            return self.usosList
        } else {
            return self.usosList.filter({
                usos in
                usos.usosId != StringHolder.demoId
            })
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UsosTableViewCell = tableView.dequeueReusableCellWithIdentifier(UsosCellIdentifier, forIndexPath: indexPath) as! UsosTableViewCell
        var usos = getShowDemo()[indexPath.row] as Usos
        cell.usosImageView?.contentMode = UIViewContentMode.ScaleAspectFit;
        cell.usosImageView?.clipsToBounds = true
        cell.usosImageView?.image = nil
        self.loadImage(usos.image, indexPath: indexPath)
        (cell as! UsosTableViewCell).label.text = usos.name

        return cell
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showAlert(getShowDemo()[indexPath.row] as Usos)
    }


    func showAlert(usos: Usos) {
        let alertController = UIAlertController(title: StringHolder.attention, message: StringHolder.moveToUsos, preferredStyle: .Alert)

        alertController.addAction(UIAlertAction(title: StringHolder.ok, style: .Default, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let controller = SecondLoginViewController()

            self.userDataHolder.usosId = usos.usosId
            self.presentViewController(controller, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: StringHolder.cancel, style: .Cancel, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    func onUsosesLoaded(arrayOfUsoses: Array<Usos>) {
        self.usosList = arrayOfUsoses;
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }

    private func loadImage(urlString: String, indexPath: NSIndexPath) {
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    if var cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                        (cell as! UsosTableViewCell).usosImageView?.contentMode = UIViewContentMode.ScaleAspectFit;
                        (cell as! UsosTableViewCell).usosImageView?.image = image


                    }

                }
            }
        })
        task.resume()
    }
}
