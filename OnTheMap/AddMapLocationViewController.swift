//
//  AddMapLocationViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/6/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import UIKit
import MapKit

class AddMapLocationViewController: UIViewController, MKMapViewDelegate {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var dropPinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
