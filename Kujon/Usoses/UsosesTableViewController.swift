//
//  UsosesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol UsosesTableViewControllerDelegate: class {
    func usosesTableViewControllerDidTriggerLogout()
}

class UsosesTableViewController: UITableViewController, UsosesProviderDelegate {

    private let UsosCellIdentifier = "reusableUsosCell"
    private let usosProvider = ProvidersProviderImpl.sharedInstance.provideUsosesProvider()
    private var usosList: Array<Usos> = Array()
    let userDataHolder = UserDataHolder.sharedInstance
    var showDemoUniversity = false
    weak var delegate: UsosesTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = StringHolder.chooseUsos
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.white ]

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "hint-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(UsosesTableViewController.presentInfo))

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UsosesTableViewController.barTapped))
        tapGestureRecognizer.numberOfTapsRequired = 3
        self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()


        self.tableView.register(UINib(nibName: "UsosTableViewCell", bundle: nil), forCellReuseIdentifier: UsosCellIdentifier)
        self.usosProvider.delegate = self
        self.usosProvider.loadUsoses()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(UsosesTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)


    }


    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        usosProvider.reload()
        usosProvider.loadUsoses()

    }


    func barTapped(){
        self.showDemoUniversity = true
        ToastView.showInParent(self.navigationController?.view,withText: StringHolder.addedDemo, forDuration: 2.0)
        self.tableView.reloadData()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UsosTableViewCell = tableView.dequeueReusableCell(withIdentifier: UsosCellIdentifier, for: indexPath) as! UsosTableViewCell
        let usos = getShowDemo()[indexPath.row] as Usos

        let cellEnabled = usos.enable != nil && usos.enable == true
        cell.enabled = cellEnabled
        cell.usosImageView?.contentMode = UIViewContentMode.scaleAspectFit;
        cell.usosImageView?.clipsToBounds = true
        cell.usosImageView?.image = nil
        self.loadImage(usos.image, indexPath: indexPath)
        cell.label.text = usos.name
        return cell
    }


     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UsosTableViewCell {
            let usos = getShowDemo()[indexPath.row] as Usos
            if cell.enabled {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(usos)
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.presentAlertWithMessage(usos.comment, title: "Informacja")
            }
        }
    }


    func showAlert(_ usos: Usos) {
        let alertController = UIAlertController(title: StringHolder.attention, message: StringHolder.moveToUsos, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: StringHolder.ok, style: .default, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            let controller = SecondLoginViewController()
            let  navigationController = UINavigationController(rootViewController: controller)

            self.userDataHolder.usosId = usos.usosId
            self.userDataHolder.usosName = usos.name
            self.present(navigationController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: StringHolder.cancel, style: .cancel, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    func onUsosesLoaded(_ arrayOfUsoses: Array<Usos>) {
        self.usosList = arrayOfUsoses;
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs() {
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {

        self.refreshControl?.endRefreshing()
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.usosProvider.loadUsoses()
        }, cancel: {})

    }

    private func loadImage(_ urlString: String, indexPath: IndexPath) {
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    if let cell = self.tableView.cellForRow(at: indexPath) {
                        (cell as! UsosTableViewCell).usosImageView?.contentMode = UIViewContentMode.scaleAspectFit;
                        (cell as! UsosTableViewCell).usosImageView?.image = image


                    }

                }
            }
        })
        task.resume()
    }

    internal func presentInfo() {
        presentAlertWithMessage(StringHolder.usosesGeneralInfo, title: "Informacja")

    }

    // trigger logout after back button tap
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            delegate?.usosesTableViewControllerDidTriggerLogout()
        }
    }

}
