//  Project name: FwiCore
//  File name   : FwiNetworkManagerTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/20/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
//  All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import XCTest
@testable import FwiCore


class FwiNetworkManagerTest: XCTestCase {
    
    
    fileprivate lazy var instance  = FwiNetworkManager.sharedInstance()
    fileprivate lazy var baseHTTP  = URL(string: "http://httpbin.org")
    fileprivate lazy var baseHTTPS = URL(string: "https://httpbin.org")
    
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Cases
    func testHTTP() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/get", relativeTo: baseHTTP),let request = instance.prepareRequest(url) {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(FwiNetworkStatusIsSuccces(statusCode), "Success connection should return status code range 200 - 299. But found \(statusCode)")
                XCTAssertNil(error, "Success connection should not return error. But found \(error)");
                XCTAssertNotNil(data, "Success connection should return data. But found nil");
                
                if data != nil {
                    completedExpectation.fulfill()
                }
            }
        }
        
        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }
    
    func testHTTPS() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/get", relativeTo: baseHTTPS) , let request = instance.prepareRequest(url) {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(FwiNetworkStatusIsSuccces(statusCode), "Success connection should return status code range 200 - 299. But found \(statusCode)")
                XCTAssertNil(error, "Success connection should not return error. But found \(error)");
                XCTAssertNotNil(data, "Success connection should return data. But found nil");
                
                if data != nil {
                    completedExpectation.fulfill()
                }
            }
        }
        
        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }

    func testNetworkIndicator() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/get", relativeTo: baseHTTP), let req = instance.prepareRequest(url) {

            var request1 = false
            var request2 = false
            var request3 = false
            var request4 = false
            var request5 = false
            
            instance.sendRequest(req) { (data, error, statusCode, response) in
                request1 = true
                if request1 && request2 && request3 && request4 && request5 {
                    completedExpectation.fulfill()
                }
            }
            instance.sendRequest(req) { (data, error, statusCode, response) in
                request2 = true
                if request1 && request2 && request3 && request4 && request5 {
                    completedExpectation.fulfill()
                }
            }
            instance.sendRequest(req) { (data, error, statusCode, response) in
                request3 = true
                if request1 && request2 && request3 && request4 && request5 {
                    completedExpectation.fulfill()
                }
            }
            instance.sendRequest(req) { (data, error, statusCode, response) in
                request4 = true
                if request1 && request2 && request3 && request4 && request5 {
                    completedExpectation.fulfill()
                }
            }
            instance.sendRequest(req) { (data, error, statusCode, response) in
                request5 = true
                if request1 && request2 && request3 && request4 && request5 {
                    completedExpectation.fulfill()
                }
            }
        }
    
        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }

    func testUnsupportedURL() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/", relativeTo: nil), let request = instance.prepareRequest(url)  {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(statusCode == .UnsupportedURL, "Fail connection status should be \(NetworkStatus.UnsupportedURL). But found \(statusCode)")
                XCTAssertNotNil(error, "Fail connection should not return error. But found \(error)");
                XCTAssertNil(data, "Fail connection should return nil data. But found \(data)");
                
                if error != nil && data == nil {
                    completedExpectation.fulfill()
                }
            }
        }

        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }

    func testCannotConnectToHost() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "http://localhost:8080"), let request = instance.prepareRequest(url)  {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(statusCode == .CannotConnectToHost, "Cancelled connection status should be \(NetworkStatus.CannotConnectToHost). But found \(statusCode)")
                XCTAssertNotNil(error, "Cancelled connection should return error. But found nil")
                XCTAssertNil(data, "Cancelled connection should return nil data. But found \(data)")
                
                if error != nil && data == nil {
                    completedExpectation.fulfill()
                }
            }
        }

        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }

    func testStatus3xx() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/redirect/5", relativeTo: baseHTTP), let request = instance.prepareRequest(url) {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertNil(error, "Redirect connection should return nil error. But found \(error)")
                
                if error == nil {
                    completedExpectation.fulfill()
                }
            }
        }

        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }
    
    func testStatus4xx() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/status/404", relativeTo: baseHTTP) , let request = instance.prepareRequest(url){
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(statusCode == .NotFound, "Status should be \(NetworkStatus.NotFound). But found \(statusCode)")
                XCTAssertNotNil(error, "Connection should return error. But found nil")
                
                if error != nil {
                    completedExpectation.fulfill()
                }
            }
        }
        
        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }

    func testStatus5xx() {
        let completedExpectation = self.expectation(description: "Operation completed.")
        if let url = URL(string: "/status/500", relativeTo: baseHTTP), let request = instance.prepareRequest(url) {
            
            instance.sendRequest(request) { (data, error, statusCode, response) in
                XCTAssertTrue(statusCode == .InternalServerError, "Status should be \(NetworkStatus.InternalServerError). But found \(statusCode)")
                XCTAssertNotNil(error, "Connection should return error. But found nil")
                
                if error != nil {
                    completedExpectation.fulfill()
                }
            }
        }
        
        // Wait for timeout handler
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertTrue(error == nil, "Operation could not finish.")
        }
    }
}
