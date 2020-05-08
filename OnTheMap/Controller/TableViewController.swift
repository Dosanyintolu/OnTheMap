//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var Locations = [StudentLocation]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    
    
    func getStudentLocations() {
        StudentClient.getStudentLocation { (studentLocation, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                self.Locations = studentLocation
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Locations.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        let locations = Locations[indexPath.row]
        cell.textLabel?.text = "\(locations.firstName) \(locations.lastName)"
        cell.detailTextLabel?.text = "\(locations.mediaURL)"
        cell.imageView?.image = UIImage(named: "mapPin")
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return cell
       }
}

