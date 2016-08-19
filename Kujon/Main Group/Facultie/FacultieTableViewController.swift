//
//  FacultieTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FacultieTableViewController: UITableViewController, FacultieProviderDelegate, MKMapViewDelegate {
    var facultie: Facultie! = nil
    var facultieId: String! = nil
    var facultieProvider = ProvidersProviderImpl.sharedInstance.proivdeFacultieProvider()
    let mapCellId = "MapCellId";
    let headerCellId = "headerCellId";
    let telephoneCellId = "telephoneCellId";
    let wwwCellId = "wwwCellId";

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(FacultieTableViewController.back), andTitle: StringHolder.faculty)

        self.tableView.registerNib(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: mapCellId)
        self.tableView.registerNib(UINib(nibName: "FacultieHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        self.tableView.registerNib(UINib(nibName: "TelephoneTableViewCell", bundle: nil), forCellReuseIdentifier: telephoneCellId)
        self.tableView.registerNib(UINib(nibName: "WWWTableViewCell", bundle: nil), forCellReuseIdentifier: wwwCellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
        if (facultie != nil) {
        } else if (facultieId != nil) {
            facultieProvider.delegate = self
            facultieProvider.loadFacultie(facultieId)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MapTableViewCell!) {
            cell.mapView.delegate = self;
        }

    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
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

        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.facultie != nil ? 1 : 0
        case 2: return self.facultie != nil ? self.facultie.phoneNumber.count : 0
        case 3: return self.facultie?.homePageUrl != nil ? 1 : 0
        default:
            return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            return configureMapCell(indexPath)
        case 1:
            return configureHeaderCell(indexPath)
        case 2:
            return configurePhoneCell(indexPath)
        case 3:
            return configureWWWCell(indexPath)
        default:
            return configureWWWCell(indexPath)

        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 152
        case 2:
            return 60
        case 3:
            return 60
        default:
            return 60

        }
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 2:

            self.openUrlString("tel://" + self.facultie.phoneNumber[indexPath.row])

            break;
        case 3:
            self.openUrlString(self.facultie.homePageUrl)
            break;
        default: break;
        }
    }

    private func configureMapCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(mapCellId, forIndexPath: indexPath) as! MapTableViewCell
        cell.mapView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FacultieTableViewController.onMapClick))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.mapView.addGestureRecognizer(tapGestureRecognizer)
        cell.mapView.userInteractionEnabled = true

        if (facultie != nil) {
            let geocoder: CLGeocoder = CLGeocoder();
            geocoder.geocodeAddressString(facultie.postalAdress, completionHandler: {
                (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if placemarks?.count > 0 {
                    let topResult: CLPlacemark = placemarks![0];
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult);

                    if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                        let rgn = MKCoordinateRegionMakeWithDistance(
                                placemark.location!.coordinate, 500, 500);

                        (cell as! MapTableViewCell).mapView.setRegion(rgn, animated: true);
                        (cell as! MapTableViewCell).mapView.addAnnotation(placemark);
                    }

                }
            })
        }
        return cell
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = String(stringInterpolationSegment: annotation.coordinate.longitude)
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as! MKAnnotationView!

        if pinView == nil {

            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named: "map-pin-icon")
        }


        return pinView

    }


    private func configureHeaderCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(headerCellId, forIndexPath: indexPath) as! FacultieHeaderTableViewCell
        cell.adressLabel.text = facultie.postalAdress
        cell.facultieNameLabel.text = facultie.name
        loadImage(facultie.logUrls.p100x100, indexPath: indexPath)
        return cell
    }

    func onMapClick() {
        let baseUrl: String = "http://maps.apple.com/?q="
        let encodedName = facultie.postalAdress.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) ?? ""
        let finalUrl = baseUrl + encodedName
        if let url = NSURL(string: finalUrl) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    private func configurePhoneCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(telephoneCellId, forIndexPath: indexPath) as! TelephoneTableViewCell
        cell.telephoneNumberLabel.text = self.facultie.phoneNumber[indexPath.row]
        return cell
    }

    private func configureWWWCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(wwwCellId, forIndexPath: indexPath) as! WWWTableViewCell
        cell.wwwLabel.text = self.facultie.homePageUrl
        return cell
    }


    private func loadImage(urlString: String, indexPath: NSIndexPath) {
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                        (cell as! FacultieHeaderTableViewCell).facultieImageView.image = image
                    }


                }
            }
        })
        task.resume()
    }


}
