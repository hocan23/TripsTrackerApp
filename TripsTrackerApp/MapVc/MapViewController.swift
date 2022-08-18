//
//  MapViewController.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAnalytics

class MapViewController: UIViewController {
    
    var showRoute:Bool!
    var cellVmData:TripCellViewModel?
    @IBOutlet weak var endTripButton: UIButton!
    //    weak var coordinator: Coordinator?
    @IBOutlet weak var tripMapView: MKMapView!
    var locationManager = CLLocationManager()
    
    private var timer: Timer!
    private var tripName : String?
    var allLocations: [CLLocation] = []
    var count: Int!
    var viewModel: IMapViewModel?
    
    var startPoint:tripPoint = tripPoint(long: 0.0, latitu: 0.0)
    var endPoint:tripPoint = tripPoint(long: 0.0, latitu: 0.0)
    var tripStartPoint =  CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var tripEndPoint =  CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureTripMap()
        if !showRoute{
            configureLocationManager()
            configureCountForTimer()
            self.endTripButton.isHidden = false
        }else{
            takeTripPoints()
            showRouteOnMap(pickupCoordinate: tripStartPoint, destinationCoordinate: tripEndPoint)
            self.endTripButton.isHidden = true
        }
    }
    
    private func configureViewModel(){
        viewModel = MapViewModel()
    }
    
    private func configureTripMap(){
        tripMapView.showsUserLocation = true
        tripMapView.delegate = self
        tripMapView.mapType = .hybrid
        tripMapView.userTrackingMode = .follow
    }
    
    private func configureLocationManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        
    }
    
    private func configureCountForTimer(){
        count = viewModel?.getTimerCount()
    }
    
    private func takeTripPoints (){
        guard let cellVmData = cellVmData else {return}
        
        tripStartPoint = CLLocationCoordinate2D.init(latitude:cellVmData.tripStartPoint.latitude , longitude: cellVmData.tripStartPoint.longitude)
        tripEndPoint = CLLocationCoordinate2D.init(latitude: cellVmData.tripEndPoint.latitude , longitude: cellVmData.tripEndPoint.latitude)
    }
    
    @IBAction func endTripButtonTap(_ sender: Any) {
        print("Timer has finished")
        timer.invalidate()
        saveTrip()
        locationManager.stopUpdatingLocation()
    }
    
    @objc func timerFired(){
        if(count > 0){
            print("count is \n")
            print(count ?? 0)
            count -= 1
        }else{
            print("Timer has finished")
            timer.invalidate()
            saveTrip()
            viewModel?.saveTrip(startPoint: startPoint, endPoint: endPoint, tripName: tripName!)
            locationManager.stopUpdatingLocation()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveTrip (){
        let alertController = UIAlertController(title: "Trip Name?", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            let inputName = alertController.textFields![0].text
            self.tripName = inputName ?? "trip"
            
            
            self.viewModel?.saveTrip(startPoint: self.startPoint, endPoint: self.endPoint, tripName:self.tripName!)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.tripMapView.setRegion(region, animated: true)
            //
            let previousCoordinate = allLocations.last?.coordinate
            allLocations.append(location)
            //
            if previousCoordinate == nil { return }
            //
            var area = [previousCoordinate!, location.coordinate]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            self.tripMapView.addOverlay(polyline)
            self.count = viewModel?.getTimerCount()
            configurePointsToSave(locations: allLocations)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("location stopped")
        
        
        endTripButton.setTitle("Trip paused", for: .normal)
        timer.fire()
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        allLocations = []
        endTripButton.setTitle("Trip resumed", for: .normal)
        if count == 0 {
            print("should start new trip")
            endTripButton.setTitle("Trip should start new trip", for: .normal)
        }else{
            endTripButton.setTitle("Trip should reassign count number", for: .normal)
            print("should reassign count number")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus)
        
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            print("notDetermined")
            break
        case .authorizedWhenInUse:
            //            Analytics.logEvent("start_trip", parameters: nil)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            print("authorizedWhenInUse")
            
            break
        case .authorizedAlways:
            //            Analytics.logEvent("start_trip", parameters: nil)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            print("authorizedAlways")
            
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            print("restricted")
            
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            print("denied")
            
            break
        default:
            break
        }
    }
    
}


extension MapViewController: MKMapViewDelegate{
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.tripMapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.tripMapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.tripMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapsView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 4
        return polylineRenderer
        
    }
}


extension MapViewController{
    private func configurePointsToSave(locations: [CLLocation]){
        self.startPoint.long = locations[0].coordinate.longitude
        self.startPoint.latitu = locations[0].coordinate.latitude
        self.endPoint.long = locations.last?.coordinate.longitude ?? 0
        self.endPoint.latitu = locations.last?.coordinate.latitude ?? 0
    }
}
