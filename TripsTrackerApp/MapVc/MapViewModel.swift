//
//  MapViewModel.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//


import Foundation
import CoreLocation
import UIKit
import MapKit

protocol IMapViewModel{
    func getTimerCount() -> Int
    func saveTrip(startPoint: tripPoint, endPoint: tripPoint,tripName:String)
}

class MapViewModel:IMapViewModel{
    
    
    
    
    func getTimerCount() -> Int{
        return 300
    }
    
    func saveTrip(startPoint: tripPoint, endPoint: tripPoint,tripName:String){
            let cellVM = TripCellViewModel(tripName: tripName, tripStartPoint: CLLocationCoordinate2D(latitude: startPoint.latitu, longitude: startPoint.long), tripEndPoint: CLLocationCoordinate2D(latitude: endPoint.latitu, longitude: endPoint.long))
        CoreDataManager.shared.insert(trip: cellVM)
        
        print(CoreDataManager.shared.getAllTrips()[0].tripStartPoint)
}
    
    
  
    
}

