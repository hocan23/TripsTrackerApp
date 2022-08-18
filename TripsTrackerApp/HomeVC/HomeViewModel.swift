//
//  HomeViewModel.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//


import Foundation
import UIKit

protocol IHomeViewModel{
    func getTripCellViewModel(at index: IndexPath) -> TripCellViewModel
    func getNumberOfCells() -> Int
    func fetchTripsFromCoreData()
    var trips: [TripCellViewModel]  { get set }
    var updateTableViewClosure: ()->()  { get set }
}

class HomeViewModel:IHomeViewModel{

    
    
    var trips: [TripCellViewModel] = []{
        didSet{
            self.updateTableViewClosure()
        }
    }
    
    
    var updateTableViewClosure: ()->() = {}
    
    
    
    func getTripCellViewModel(at index: IndexPath) -> TripCellViewModel {
        return trips[index.row]
    }
    
    func getNumberOfCells() -> Int{
        return trips.count
    }
    
    func fetchTripsFromCoreData(){
        self.trips = CoreDataManager.shared.getAllTrips()
    }
    
  
    
}

