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
    
    func testGameFinish() {
        // Запуск игры
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        // Объявляем ожидание для появления алерта
        let alert = app.alerts["Game results"]
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: alert, handler: nil)
        
        // Ожидание появления алерта
        waitForExpectations(timeout: 10, handler: nil)
        
        // Проверка правильного заголовка алерта
        XCTAssertTrue(alert.staticTexts["Этот раунд окончен!"].exists, "Alert title is incorrect")
        
        // Проверка существования кнопки
        XCTAssertTrue(alert.buttons["RetryButton"].exists, "Retry button does not exist")
    }


    
    func testAlertShown() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
        sleep(2)
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }
    
}


