//
//  CoreDataManager.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//



import Foundation
import CoreData
import MapKit

class CoreDataManager{
    
    
    static let shared = CoreDataManager()
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TripTrackSaveModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert(trip: TripCellViewModel){
        let managedObjectContext = persistentContainer.viewContext
        let entity          = NSEntityDescription.entity(forEntityName: "TripTrackSaveModel", in: managedObjectContext)!
        let tripModel = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        if trip.tripName == ""{
            trip.tripName = "Unnamed Trip"
        }
        tripModel.setValue(trip.tripName, forKey: "tripName")
        tripModel.setValue(trip.tripStartPoint.longitude, forKey: "startLocLong")
        tripModel.setValue(trip.tripStartPoint.latitude, forKey: "startLocLat")
        tripModel.setValue(trip.tripEndPoint.longitude, forKey: "endLocLong")
        tripModel.setValue(trip.tripEndPoint.latitude, forKey: "endLocLat")
        print(trip.tripName)
        do{
            try managedObjectContext.save()
            print("new trip saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getAllTrips() -> [TripCellViewModel]
    {
        let context = self.persistentContainer.viewContext
        var objects:[NSManagedObject] = []
        var products:[TripCellViewModel] = []
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "TripTrackSaveModel")
        do{
            objects = try context.fetch(fetchReq)
            for trips in objects{
                let t = TripCellViewModel(tripName: trips.value(forKey: "tripName")as! String , tripStartPoint: CLLocationCoordinate2D(latitude: trips.value(forKey: "startLocLong")as! Double, longitude: trips.value(forKey: "startLocLat")as! Double), tripEndPoint: CLLocationCoordinate2D(latitude: trips.value(forKey: "endLocLong")as! Double, longitude: trips.value(forKey: "endLocLat")as! Double))
                print(t)
                products.append(t)
            }
        }catch let error as NSError{
            print(error)
        }
        return products
    }
    
    
}
