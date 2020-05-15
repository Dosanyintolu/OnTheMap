//
//  AddMapLocationViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/6/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddMapLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var dropPinButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mediaURL = ""
    var location = CLLocation()
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        linkTextField.delegate = self
        locationManager.delegate = self
        loadingIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         unsubscribeToKeyboardNotification()
    }
    
    @IBAction func dropPin(_ sender: Any) {
        enableLoading(Bool: true)
        getCoordinate(addressString: "\(cityTextField.text!), \(stateTextField.text!)") { (location, error) in
            if error == nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.mapView.addAnnotation(annotation)
                self.enableLoading(Bool: false)
            }
        }
    }
    
    @IBAction func shareLocation(_ sender: Any) {
       getUserData(completionHandler: handleGetUserData(success:error:))
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
          let geocoder = CLGeocoder()
          geocoder.geocodeAddressString(addressString) { (placemarks, error) in
              if error == nil {
                  if let placemark = placemarks?[0] {
                      let location = placemark.location!
                      self.location = location
                      
                      let span = MKCoordinateSpan(latitudeDelta: 0.50, longitudeDelta: 0.50)
                      let cordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                      let region = MKCoordinateRegion(center: cordinate, span: span)
                      self.mapView.setRegion(region, animated: true)
                      completionHandler(location.coordinate, nil)
                      return
                  }
              }
            self.geocodingError()
            self.enableLoading(Bool: false)
              completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
          }
      }
      
    func getUserData(completionHandler: @escaping(Bool, Error?) -> Void) {
          UdacityClient.getUserData { (userData, error) in
              if let userData = userData {
                  self.uniqueKey = userData.key
                  self.firstName = userData.firstName
                  self.lastName = userData.lastName
                
                print(self.uniqueKey, self.firstName, self.lastName)
                  completionHandler(true, nil)
              } else {
                  print("error in getting user data")
                  completionHandler(false, error)
              }
          }
      }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          if stateTextField.isEditing {
              linkTextField.isHidden = false
              shareButton.isHidden = false
          }
      }
    
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
      
    
    func subscribeToKeyboardNotification() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    func unsubscribeToKeyboardNotification() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    @objc func keyboardWillHide(_ notification: Notification) {
            view.frame.origin.y = 0
        }
       
    @objc func keyboardWillShow(_ notification: Notification) {
           view.frame.origin.y = 50 - getKeyboardHeight(notification)
       }
    
    func handleGetUserData(success: Bool, error: Error?) {
        if success {
              ParseClient.postStudentLocation(uniquekey: uniqueKey, firstName: firstName, lastName: lastName, mapString: "\(cityTextField.text!), \(stateTextField.text!)", mediaURL: "\(linkTextField.text!)", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completionHandler: handlePostLocation(success:error:))
            
            print(location.coordinate.latitude , location.coordinate.longitude)
        } else {
            postLocationError()
            print(error!.localizedDescription)
        }
    }
    
    func handlePostLocation(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            print(error?.localizedDescription ?? "")
            print("Error in posting location")
        }
    }
       
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           return keyboardSize.cgRectValue.height
       }
    
    func alertView() {
           let alertVC = UIAlertController(title: "Error", message: "Error Finding Location, try another location", preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertVC, animated: true, completion: nil)
    }
    
    func postLocationError() {
        let alertVC = UIAlertController(title: "Error", message: "Error posting location", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func geocodingError() {
        let alertVC = UIAlertController(title: "Error", message: "Error finding location", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func enableLoading(Bool: Bool) {
        if Bool {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
    }
}
