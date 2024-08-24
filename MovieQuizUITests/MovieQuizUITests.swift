//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Islam Tagirov on 18.08.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        if app != nil {
            app.terminate()
        }
        
        // Устанавливаем app в nil после завершения всех операций
        app = nil
        
        // Теперь вызываем super.tearDownWithError() в самом конце
        try super.tearDownWithError()
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // нашли кнопку "Да" и тапнули её
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() // нашли кнопку "Да" и тапнули её
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertShown() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["GameResultsAlert"]
        sleep(2)
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons["Сыграть еще раз"].exists)
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["GameResultsAlert"]
        alert.buttons.firstMatch.tap()

        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10", indexLabel.label)
    }
    
}

