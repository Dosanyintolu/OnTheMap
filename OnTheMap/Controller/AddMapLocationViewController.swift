//
//  AddMapLocationViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/6/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import UIKit
import MapKit

class AddMapLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var dropPinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        linkTextField.delegate = self
        
        linkTextField.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         unsubscribeToKeyboardNotification()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if cityTextField.text != nil && stateTextField.isEditing == false {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString("\(cityTextField.text!),\(stateTextField.text!)") { (placemark, _) in
                if let placemark = placemark {
                    let location = placemark
                    self.linkTextField.isHidden = false
                    print(location)
                } else {
                    self.alertView()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func alertView() {
        let alertVC = UIAlertController(title: "Error", message: "Error Finding Location, try another location", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
       
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           return keyboardSize.cgRectValue.height
       }
}
