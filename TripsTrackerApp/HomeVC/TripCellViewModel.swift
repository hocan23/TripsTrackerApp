//
//  TripCellViewModel.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//

import Foundation
import MapKit

class TripCellViewModel: NSObject, NSCoding{
    

    
    var tripName: String
    var tripStartPoint: CLLocationCoordinate2D
    var tripEndPoint: CLLocationCoordinate2D
    
    init(tripName:String,tripStartPoint:CLLocationCoordinate2D,tripEndPoint:CLLocationCoordinate2D ){
        self.tripName = tripName
        self.tripStartPoint = tripStartPoint
        self.tripEndPoint = tripEndPoint
    }
    
    required init?(coder: NSCoder) {
        tripName = coder.decodeObject(forKey: "tripName") as! String
        tripStartPoint = coder.decodeObject(forKey: "tripStartPoint") as! CLLocationCoordinate2D
        tripEndPoint = coder.decodeObject(forKey: "tripEndPoint") as! CLLocationCoordinate2D
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(tripName, forKey: "tripName")
        coder.encode(tripStartPoint, forKey: "tripStartPoint")
        coder.encode(tripEndPoint, forKey: "tripEndPoint")
        
    }

}

struct tripPoint{
    var long: Double
    var latitu: Double
}
