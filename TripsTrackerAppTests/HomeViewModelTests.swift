//
//  File.swift
//  TripsTrackerAppTests
//
//  Created by Hasan onur Can on 18.08.2022.
//

import Foundation
import XCTest
import MapKit
@testable import TripsTrackerApp

class HomeViewModelTests: XCTestCase {
    
    var viewModel: IHomeViewModel!
    var cellVM: TripCellViewModel!
    var arrOfTrips: [TripCellViewModel]!
    var coreDataManager: CoreDataManager!

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
        cellVM = TripCellViewModel(tripName: "trip 0", tripStartPoint: CLLocationCoordinate2D(latitude: 37.32610125, longitude: -122.02606968), tripEndPoint: CLLocationCoordinate2D(latitude: 37.32610125, longitude: -122.02606968))
        arrOfTrips = [cellVM]
        coreDataManager = CoreDataManager.shared
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cellVM = nil
        arrOfTrips = nil
        coreDataManager = nil
    }
    
    func testHomeViewModel_getTripCellViewModel() throws {
        let index = IndexPath(row: 0, section: 0)
        viewModel.trips = arrOfTrips
        XCTAssertTrue(viewModel.getTripCellViewModel(at: index) == cellVM)
    }
    
    
    func testHomeViewModel_getNumberOfCells() throws {
        XCTAssertEqual(viewModel.getNumberOfCells(), 0)
    }
    



}
