//
//  ViewController.swift
//  Pickit
//
//  Created by Ben Gohlke on 8/24/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class PinsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let latLngDegrees = 0.2
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    var picmarks = [Picmark]()
    var container = CKContainer.default()
    var publicDB: CKDatabase?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        publicDB = container.publicCloudDatabase
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Handlers
    
    func showFullSizeImage()
    {
        let annotation = mapView.selectedAnnotations[0] as! Picmark
        let imageDetailVC = storyboard?.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailVC.image = annotation.image
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    @IBAction func addPhotoTapped(sender: UIBarButtonItem)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Location functions
    
    @IBAction func checkLocationAuthorization()
    {
        if CLLocationManager.authorizationStatus() != .denied && CLLocationManager.authorizationStatus() != .restricted
        {
            if locationManager == nil
            {
                locationManager = CLLocationManager()
                if let mgr = locationManager
                {
                    mgr.delegate = self
                    mgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    if CLLocationManager.authorizationStatus() == .notDetermined
                    {
                        mgr.requestWhenInUseAuthorization()
                    }
                }
            }
            else
            {
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager?.stopUpdatingLocation()
        if let currentLocation = locations.last
        {
            let mapRegion = MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(latLngDegrees, latLngDegrees))
            mapView.setRegion(mapRegion, animated: true)
            self.currentLocation = currentLocation
            refreshPicmarks()
        }
    }
    
    // MARK: - MapKit delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapAnnotation")
        if pinAnnotationView == nil
        {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotation")
        }
        pinAnnotationView?.canShowCallout = true
        let aPicmark = annotation as! Picmark
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32.0, height: 32.0))
        imageView.image = aPicmark.image
        imageView.contentMode = .scaleAspectFit
        pinAnnotationView?.leftCalloutAccessoryView = imageView
        let disclosureButton = UIButton(type: .detailDisclosure)
        pinAnnotationView?.rightCalloutAccessoryView = disclosureButton
        disclosureButton.addTarget(self, action: #selector(PinsViewController.showFullSizeImage), for: .touchUpInside)
        
        
        return pinAnnotationView
    }
    
    // MARK: - CloudKit functions
    
    func refreshPicmarks()
    {
        if let currLoc = currentLocation
        {
            let radius: CGFloat = 10000.0 // meters
            let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(Location,%@) < %f", argumentArray: [currLoc, radius])
            let query = CKQuery(recordType: "Picmark", predicate: predicate)
            publicDB!.perform(query, inZoneWith: nil) {
                results, error in
                if let queryError = error
                {
                    print("Error querying CloudKit: \(queryError.localizedDescription)")
                }
                else
                {
                    DispatchQueue.main.async {
                        self.mapView.removeAnnotations(self.picmarks)
                    }
                    self.picmarks.removeAll()
                    if let picmarkRecords = results
                    {
                        for aRecord in picmarkRecords
                        {
                            let aPicmark = Picmark(with: aRecord)
                            self.picmarks.append(aPicmark)
                        }
                        
                        DispatchQueue.main.async {
                            self.mapView.addAnnotations(self.picmarks)
                        }
                    }
                }
            }
        }
    }
    
    // Mark: - UIImagePickerController delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        if let currLoc = currentLocation
        {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let aPicmark = Picmark(location: currLoc, image: image)
            picmarks.append(aPicmark)
            mapView.addAnnotation(aPicmark)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsPath = paths[0] 
            let fullPath = (documentsPath as NSString).appendingPathComponent("\(aPicmark.uuid()).png")
            if let imageData = UIImagePNGRepresentation(image)
            {
                do
                {
                    let url = URL(fileURLWithPath: fullPath)
                    try imageData.write(to: url, options: .atomic)
                } catch let error as NSError
                {
                    print("Image data could not be written: \(error.localizedDescription)")
                }
                
                let aRecord = CKRecord(recordType: "Picmark")
                aRecord.setObject(currLoc, forKey: "Location")
                let anAsset = CKAsset(fileURL: URL(fileURLWithPath: fullPath))
                aRecord.setObject(anAsset, forKey: "Image")
                aRecord.setObject("A picmark" as CKRecordValue?, forKey: "Title")
                publicDB?.save(aRecord) {
                    record, error in
                }
            }
        }
    }
}

class Picmark: NSObject, MKAnnotation
{
    let location: CLLocation
    var image: UIImage?
    let identifier: UUID
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(location aLocation:CLLocation, image anImage: UIImage)
    {
        location = aLocation
        coordinate = location.coordinate
        image = anImage
        identifier = UUID()
        title = "A Picmark"
    }
    
    init(with record:CKRecord)
    {
        location = record.object(forKey:"Location") as! CLLocation
        coordinate = location.coordinate
        let asset = record.object(forKey:"Image") as! CKAsset
        do {
            let imageData = try Data(contentsOf:asset.fileURL)
            image = UIImage(data:imageData)!
        } catch let error as NSError
        {
            print("Couldn't create image from data: \(error.localizedDescription)")
        }
        identifier = UUID()
        title = "A Picmark"
    }
    
    func uuid() -> String
    {
        return identifier.uuidString
    }
}
