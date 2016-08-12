//
//  FacultieTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class FacultieTableViewController: UITableViewController, FacultieProviderDelegate {
    var facultie: Facultie! = nil
    var facultieId: String! = nil
    var facultieProvider = ProvidersProviderImpl.sharedInstance.proivdeFacultieProvider()
    static let mapCellId = "MapCellId";
    static let headerCellId = "headerCellId";
    static let telephoneCellId = "telephoneCellId";
    static let wwwCellId = "wwwCellId";

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(FacultieViewController.back), andTitle: StringHolder.faculty)
        if (facultie != nil) {
            
        } else if (facultieId != nil) {
            facultieProvider.delegate = self
            facultieProvider.loadFacultie(facultieId)
        }

      
    }
    
    func onFacultieLoaded(fac: Facultie) {
        self.facultie = fac
        self.tableView.reloadData()
    }

    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.facultieProvider.delegate = self
            self.facultieProvider.loadFacultie(self.facultieId)
            }, cancel: {})
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1: return self.facultie != nil ? 1:0
        case 2: return self.facultie != nil ? self.facultie.phoneNumber.count:0
        case 3: return self.facultie?.homePageUrl != nil ? 1:0
        default:
            0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:

        break;
        case 1:

        break;
        case 2:

        break;
        case 3:

        break;
        default:
            break;
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionSch = getScheduleSectionAtPosition(indexPath.section)
        let cellStrategy = sectionSch.getElementAtPosition(indexPath.row)
        cellStrategy.handleClick(self.navigationController)
    }
   
    
}
