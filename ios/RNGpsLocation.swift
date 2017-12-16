//
//  RNGpsLocation.swift
//  RNGpsLocation
//
//  Created by Malik MAZOUZ on 16/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import CoreLocation

@objc(RNGpsLocation)
class RNGpsLocation: RCTEventEmitter, CLLocationManagerDelegate {
    let GPS = CLLocationManager()
    let distance = CLLocationDistance(exactly: 100)
    let timeout = TimeInterval(exactly: 100)
    let accuracy = kCLLocationAccuracyHundredMeters
    let latitude = CLLocationDegrees(exactly: 48.8963207)
    let longitude = CLLocationDegrees(exactly: 2.3186806)
    var home :CLLocationCoordinate2D? = nil
    var region :CLCircularRegion? = nil
    override init() {
        super.init()
        self.GPS.delegate = self
        self.GPS.activityType = .other
        if #available(iOS 9.0, *) {
            self.GPS.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        self.GPS.allowDeferredLocationUpdates(untilTraveled: self.distance!, timeout: self.timeout!)
        self.GPS.distanceFilter = self.distance!
        self.GPS.desiredAccuracy = self.accuracy
        //        self.GPS.startMonitoringSignificantLocationChanges()
        self.home =  CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        self.region = CLCircularRegion(center: self.home!, radius: self.distance!, identifier: "42")
    }
    override func supportedEvents() -> [String]! {
        return ["Location"]
    }
    @objc func askAuthorization() -> Void {
        self.GPS.requestAlwaysAuthorization()
    }
    
    @objc func startMonitor() -> Void {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                self.region?.notifyOnEntry = true
                self.region?.notifyOnExit = true
                
                self.GPS.startMonitoring(for: self.region!)
            }
        }
    }
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //
    //    }
    @objc func getLocation() -> Void {
        if #available(iOS 9.0, *) {
            print(self.GPS.requestLocation())
        } else {
            // Fallback on earlier versions
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            print("enter")
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            print("exit")
        }
    }
}
