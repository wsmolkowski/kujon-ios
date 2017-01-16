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
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FacultieTableViewController: UITableViewController, FacultieProviderDelegate, MKMapViewDelegate, FacultyHeaderTableViewCellDelegate, SupervisingUnitCellDelegate {

    var facultie: Facultie! = nil
    var facultieId: String! = nil
    var facultieProvider = ProvidersProviderImpl.sharedInstance.proivdeFacultieProvider()
    let mapCellId = "MapCellId";
    let headerCellId = "headerCellId";
    let telephoneCellId = "telephoneCellId";
    let wwwCellId = "wwwCellId";
    let statsCellId = "StatisticsCell"
    let superUnitCellId = "SupervisingUnitCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(FacultieTableViewController.back), andTitle: StringHolder.faculty)

        self.tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: mapCellId)
        self.tableView.register(UINib(nibName: "FacultieHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        self.tableView.register(UINib(nibName: "TelephoneTableViewCell", bundle: nil), forCellReuseIdentifier: telephoneCellId)
        self.tableView.register(UINib(nibName: "WWWTableViewCell", bundle: nil), forCellReuseIdentifier: wwwCellId)
        self.tableView.register(UINib(nibName: "StatisticsCell", bundle: nil), forCellReuseIdentifier: statsCellId)
        self.tableView.register(UINib(nibName: "SupervisingUnitCell", bundle: nil), forCellReuseIdentifier: superUnitCellId)

        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200

        if (facultie != nil) {
        } else if (facultieId != nil) {
            facultieProvider.delegate = self
            facultieProvider.loadFacultie(facultieId)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MapTableViewCell!) {
            cell.mapView.delegate = self;
        }

    }

    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func onFacultieLoaded(_ fac: Facultie) {

        self.facultie = fac
        self.tableView.reloadData()
    }

    func onErrorOccurs(_ text: String) {

        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.facultieProvider.delegate = self
            self.facultieProvider.loadFacultie(self.facultieId)
        }, cancel: {})
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.facultie != nil ? 1 : 0
        case 2: return self.facultie != nil ? self.facultie.phoneNumber.count : 0
        case 3: return self.facultie?.homePageUrl != nil ? 1 : 0
        case 4: return self.facultie != nil ? 1 : 0
        case 5: return isSupervisingUnitAvailable() ? 1 : 0
        default:
            return 0
        }
    }

    private func isSupervisingUnitAvailable() -> Bool {
        if let facultie = facultie, !facultie.schoolPath.isEmpty {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            return configureMapCell(indexPath)
        case 1:
            return configureHeaderCell(indexPath)
        case 2:
            return configurePhoneCell(indexPath)
        case 3:
            return configureWWWCell(indexPath)
        case 4:
            return configureStatsCell(indexPath)
        case 5:
            return configureSuperUnitCell(indexPath)
        default:
            return configureWWWCell(indexPath)

        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    private func configureMapCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mapCellId, for: indexPath) as! MapTableViewCell
        cell.mapView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FacultieTableViewController.onMapClick))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.mapView.addGestureRecognizer(tapGestureRecognizer)
        cell.mapView.isUserInteractionEnabled = true

        if (facultie != nil && facultie.postalAdress != nil) {
            let geocoder: CLGeocoder = CLGeocoder();
            geocoder.geocodeAddressString(facultie.postalAdress, completionHandler: {
                placemarks, error in
                if placemarks?.count > 0 {
                    let topResult: CLPlacemark = placemarks![0];
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult);

                    if let cell = self.tableView.cellForRow(at: indexPath) {
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = String(stringInterpolationSegment: annotation.coordinate.longitude)
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as MKAnnotationView!

        if pinView == nil {

            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named: "map-pin-icon")
        }


        return pinView

    }


    private func configureHeaderCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! FacultieHeaderTableViewCell
        cell.adressLabel.text = facultie.postalAdress
        cell.facultieNameLabel.text = facultie.name
        cell.delegate = self
        loadImage(facultie.logUrls.p100x100, indexPath: indexPath)
        return cell
    }

    func onMapClick() {
        openMapView()
    }

    private func openMapView() {
        if(facultie.postalAdress != nil){
            let baseUrl: String = "http://maps.apple.com/?q="
            let encodedName = facultie.postalAdress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let finalUrl = baseUrl + encodedName
            if let url = URL(string: finalUrl) {
                UIApplication.shared.openURL(url)
            }
        }
    }

    private func configurePhoneCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: telephoneCellId, for: indexPath) as! TelephoneTableViewCell
        cell.telephoneNumberLabel.text = self.facultie.phoneNumber[indexPath.row]
        return cell
    }

    private func configureWWWCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wwwCellId, for: indexPath) as! WWWTableViewCell
        cell.wwwLabel.text = self.facultie.homePageUrl
        return cell
    }

    private func configureStatsCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statsCellId, for: indexPath) as! StatisticsCell
        cell.stats = self.facultie.schoolStats
        return cell
    }

    private func configureSuperUnitCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: superUnitCellId, for: indexPath) as! SupervisingUnitCell
        if let unit = facultie?.schoolPath.first {
            cell.supervisingUnit = unit
            cell.delegate = self
        }
        return cell
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
                        (cell as! FacultieHeaderTableViewCell).facultieImageView.image = image
                    }


                }
            }
        })
        task.resume()
    }

    // MARK: FacultyHeaderTableViewCellDelegate

    func facultyHeaderCell(_ cell: FacultieHeaderTableViewCell, didTapPinButton button: UIButton) {
        openMapView()
    }


    // MARK: SupervisingUnitCellDelegate

    func supervisingUnitCell(_ cell: SupervisingUnitCell, didTapSupervisingUnitWithId id: String) {
        let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
        faculiteController.facultieId = id
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }

}
