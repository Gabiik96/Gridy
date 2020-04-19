//
//  GridyUITests.swift
//  GridyUITests
//
//  Created by Gabriel Balta on 11/04/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import XCTest

class GridyUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// testing if image picked by user is same like image shown on screen
    func testPickUserImage() {
        
        let app = XCUIApplication()
        XCUIApplication().launch()
        app.buttons["Pick"].tap()
        
        let image = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .image).element
        
        let userPickedImage = app.images["PickedImage"]

        XCTAssert(image != userPickedImage, "User picked image and shown image are different!")
    }
    
    /// testing hintBtn is pressed if hintImage is shown
    func testHintImage() {
        
        let app = XCUIApplication()
        XCUIApplication().launch()
        app.buttons["Pick"].tap()
        app.images["PickedImage"].swipeDown()
        app.buttons["  Start  "].tap()
        app.buttons["Gridy lookup"].tap()
        
        let hintImage = app.images["HintImage"]
        XCTAssert(hintImage.isHittable == true, "HintImage should be shown after pressing hintBtn!")
        
        
    }
    
    /// testing speakerBtn toggle functionality to turn sound on/off when pressed
    func testSoundToggle() {
        
        let app = XCUIApplication()
        XCUIApplication().launch()
        app.buttons["Pick"].tap()
        app.buttons["  Start  "].tap()
        let soundBtnBefore = app.buttons["speaker.slash.fill"].screenshot()
        app.buttons["speaker.slash.fill"].tap()
        let soundBtnAfter = app.buttons["speaker.slash.fill"].screenshot()
        
        XCTAssert(soundBtnBefore != soundBtnAfter, "SpeakerBtn should change it's image when tapped")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 2)
        element.children(matching: .image).element(boundBy: 3).swipeDown()
        let speakerBtnBefore = app.buttons["speaker.slash.fill"].screenshot()
        app.buttons["speaker.slash.fill"].tap()
        let speakerBtnAfter = app.buttons["speaker.slash.fill"].screenshot()
        
        XCTAssert(speakerBtnBefore != speakerBtnAfter, "SpeakerBtn should change it's image when tapped")
        
        
    }
}
