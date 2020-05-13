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
        tableView.dataSource = self
        getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completioHandler: handleLogoutResponse(success:error:))
    }
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdd", sender: nil)
    }
    
    @IBAction func reloadData(_ sender: Any) {
        getStudentLocations()
    }
    
   
    func getStudentLocations() {
        ParseClient.getStudentLocation { (studentLocation, error) in
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
        return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(ParseClient.Endpoint.udacityURL.url, options: [:], completionHandler: nil)

    }
    
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            alertView()
        } else {
            errorView()
        }
    }
    func alertView() {
           let alertVC = UIAlertController(title: "You are about to log out", message: "Confirm Log Out", preferredStyle: .alert)
                  alertVC.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (_) in
                       DispatchQueue.main.async {
                                     self.dismiss(animated: true, completion: nil)
                                 }
                  }))
                  alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                  present(alertVC, animated: true)
       }
    
    func errorView() {
           let alert = UIAlertController(title: "Error", message: "Application Error", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
}

