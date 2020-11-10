//
//  ViewController.swift
//  project 22
//
//  Created by Kristoffer Eriksson on 2020-11-10.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var circle: UIView!
    @IBOutlet var beaconId: UILabel!
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    var uuidString: String?
    
    var detectedBeacon: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circle.layer.cornerRadius = 128
        circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        circle.layer.zPosition = 0.5
        
        distanceReading.layer.zPosition = 0.8
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
           addBeacon(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "My Beacon")
           addBeacon(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius")
           addBeacon(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "Test 2")
       }
    
    func addBeacon(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "myBeacon")
           
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
    
    func detectBeacon(){
        if detectedBeacon == true {
            detectedBeacon = false
            let ac = UIAlertController(title: "Detected", message: "beacon", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    func update(distance: CLProximity, beacon: String){
        
        //beaconId.text = beacon
        
        UIView.animate(withDuration: 1){ [weak self] in
            
            self?.beaconId.text = beacon
            
            switch distance{
            
            case .far:
                self?.view.backgroundColor = .blue
                self?.distanceReading.text = "FAR"
                self?.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self?.view.backgroundColor = .orange
                self?.distanceReading.text = "NEAR"
                self?.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self?.view.backgroundColor = .red
                self?.distanceReading.text = "RIGHT HERE"
                self?.circle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self?.view.backgroundColor = .gray
                self?.distanceReading.text = "UNKNOWN"
                self?.circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
    }
    // depricated
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity, beacon: region.identifier)
            detectBeacon()
            
        } else {
            update(distance: .unknown, beacon: "unknown")
        }
    }
    
}

