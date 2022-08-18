//
//  MapViewModelTests.swift
//  TripsTrackerAppTests
//
//  Created by Hasan onur Can on 18.08.2022.
//

import Foundation
import XCTest
import MapKit
@testable import TripsTrackerApp

class MapViewModelTests: XCTestCase {

    var viewModel: IMapViewModel!


    override func setUpWithError() throws {
        viewModel = MapViewModel()

    }

    override func tearDownWithError() throws {
        viewModel = nil

    }
    
    func testMapViewModel_getTimerCount() throws {
        XCTAssertEqual(viewModel.getTimerCount(), 300)
    }
    

}
