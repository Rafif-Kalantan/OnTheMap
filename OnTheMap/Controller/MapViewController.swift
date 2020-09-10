//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rafif Kalantan on 04/09/2020.
//  Copyright © 2020 Rafif Kalantan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Declarations
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
    }
    
    // MARK: Logging Out
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.activityIndicator.startAnimating()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Refreshing The Map
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        getStudentsPins()
    }
    
    // MARK: Adding Pins
    func getStudentsPins() {
        self.activityIndicator.startAnimating()
        UdacityClient.getStudentLocations() { locations, error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.locations = locations ?? []
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }else{
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
            }
            }
        }
    }
    
    // MARK: Map Viewing
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
    
}

