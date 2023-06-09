//
//  LocationManagerTests.swift
//
//
//  Created by Óscar Morales Vivó on 6/1/23.
//

import CoreLocation
@testable import LocationDependency
import SwiftUX
import XCTest

/**
 Tests the common location manager flows.
 */
final class LocationManagerTests: XCTestCase {
    private static let petersCreek = CLLocation(latitude: 37.27661, longitude: -122.19913) // You should go there.

    /**
     Tests that if the user is already authorized to access location then `verifyUserPermissionToAccessLocation` just
     returns (the test would fail if the call throws)
     */
    func testVerifyUserPermissionToAccessLocationAlreadyAuthorized() async throws {
        let authorizationStatusProperty: WritableProperty<CLAuthorizationStatus> = .root(
            initialValue: .authorizedAlways
        )
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = authorizationStatusProperty

        try await mockLocationManager.verifyUserPermissionToAccessLocation()
    }

    /**
     Tests the flow where the user is asked for authorization.
     */
    func testVerifyUserPermissionToAccessLocationNeedsAuthorization() async throws {
        let authorizationStatusProperty: WritableProperty<CLAuthorizationStatus> = .root(
            initialValue: .notDetermined
        )
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = authorizationStatusProperty

        let requestAuthorizationExpectation = expectation(description: "Requesting authorization")
        let noChangeExpectation = expectation(description: "Not changing things")
        let changedExpectation = expectation(description: "Changed things")
        mockLocationManager.requestWhenInUseAuthorizationOverride = {
            requestAuthorizationExpectation.fulfill()

            Task {
                noChangeExpectation.fulfill()
                authorizationStatusProperty.value = .notDetermined

                Task {
                    changedExpectation.fulfill()
                    authorizationStatusProperty.value = .authorizedAlways // Not what iOS would do but builds on mac.
                }
            }
        }

        try await mockLocationManager.verifyUserPermissionToAccessLocation()

        await fulfillment(of: [requestAuthorizationExpectation, noChangeExpectation, changedExpectation])
    }

    /**
     Tests that `verifyUserPermissionToAccessLocation` throws the expected error when the location access authorization
     is denied.
     */
    func testVerifyUserPermissionToAccessLocationDenied() async throws {
        try await verifyUserPermissionThrows(authorization: .denied)
    }

    /**
     Tests that `verifyUserPermissionToAccessLocation` throws the expected error when the location access authorization
     is restricted.
     */
    func testVerifyUserPermissionToAccessLocationRestricted() async throws {
        try await verifyUserPermissionThrows(authorization: .restricted)
    }

    private func verifyUserPermissionThrows(authorization: CLAuthorizationStatus) async throws {
        let authorizationStatusProperty: WritableProperty<CLAuthorizationStatus> = .root(
            initialValue: authorization
        )
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = authorizationStatusProperty

        do {
            try await mockLocationManager.verifyUserPermissionToAccessLocation()
            XCTFail("verifyUserPermissionToAccessLocation should have thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, MockLocationManager.ErrorDomain)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    /**
     Checks that the happy path of obtaining current location works right, with the location manager finding a location
     after `startUpdatingLocation` being called by `obtainCurrentLocation`
     */
    func testObtainCurrentLocationHappyPath() async throws {
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = WritableProperty.root(initialValue: .authorizedAlways)

        let expectedlocation = Self.petersCreek
        let locationProperty: WritableProperty<TrackedLocation> = .root(initialValue: .unknown)
        mockLocationManager.currentLocation = locationProperty

        let startUpdatingExpectation = expectation(description: "Called `startUpdatingLocation`")
        mockLocationManager.startUpdatingLocationOverride = {
            startUpdatingExpectation.fulfill()
            Task {
                locationProperty.value = .located(expectedlocation)
            }
        }

        let resultingLocation = try await mockLocationManager.obtainCurrentLocation()

        await fulfillment(of: [startUpdatingExpectation])

        XCTAssertEqual(resultingLocation, expectedlocation)
    }

    /**
     Checks that if there's already a location it gets returned immediately.
     */
    func testObtainCurrentLocationAlreadyAvailable() async throws {
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = WritableProperty.root(initialValue: .authorizedAlways)

        let expectedlocation = Self.petersCreek
        let locationProperty: WritableProperty<TrackedLocation> = .root(initialValue: .located(expectedlocation))
        mockLocationManager.currentLocation = locationProperty

        let startUpdatingExpectation = expectation(description: "Called `startUpdatingLocation`")
        mockLocationManager.startUpdatingLocationOverride = {
            startUpdatingExpectation.fulfill()
        }

        let resultingLocation = try await mockLocationManager.obtainCurrentLocation()

        await fulfillment(of: [startUpdatingExpectation])

        XCTAssertEqual(resultingLocation, expectedlocation)
    }

    /**
     Checks that an error when trying to obtain current location propagates properly.
     */
    func testObtainCurrentLocationSadPath() async throws {
        let mockLocationManager = MockLocationManager()
        mockLocationManager.authorizationStatus = WritableProperty.root(initialValue: .authorizedAlways)

        let locationProperty: WritableProperty<TrackedLocation> = .root(initialValue: .unknown)
        mockLocationManager.currentLocation = locationProperty

        let startUpdatingExpectation = expectation(description: "Called `startUpdatingLocation`")
        mockLocationManager.startUpdatingLocationOverride = {
            startUpdatingExpectation.fulfill()
            Task {
                locationProperty.value = .failure(MockLocationManager.MockError.mock)
            }
        }

        do {
            _ = try await mockLocationManager.obtainCurrentLocation()
            XCTFail("Unexpectedly succeeded at getting the current location")
        } catch MockLocationManager.MockError.mock {
            // This statement intentionally left blank.
        } catch {
            XCTFail("Unexpected error found \(error)")
        }

        await fulfillment(of: [startUpdatingExpectation])
    }
}
