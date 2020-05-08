//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var location = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentPins()
        
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        
        performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityClient.logout(completioHandler:handleLogOut(success:error:))
    }
    
    @IBAction func mapRefreshButton(_ sender: Any) {
        getStudentPins()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.tintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
}
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func getStudentPins() {
        StudentClient.getStudentLocation { (studentLocation, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }else{
                self.location = studentLocation
                DispatchQueue.main.async {
                    self.placeStudentPins()
            }
        }
    }
}
    
    func placeStudentPins() {
        
        for dictionary in location {
            let lat = CLLocationDegrees(dictionary.latitude)
            let lon = CLLocationDegrees(dictionary.longitude)
            let cordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = "\(mediaURL)"
            
            annotations.append(annotation)
            mapView.addAnnotations(annotations)
            mapView.addAnnotation(annotation)
        }
    }
    
    func handleLogOut(success: Bool, error: Error?) {
        if success {
            let alertVC = UIAlertController(title: "You are about to log out", message: "Confirm Log Out", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title:"Log Out", style: .destructive, handler: nil))
            present(alertVC, animated: true, completion: nil)
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            }
        } else {
            print(error?.localizedDescription ?? "Log out error")
        }
    }
}

