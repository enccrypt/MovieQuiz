//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 03.08.2024.
//

import Foundation

// Расширяем при объявлении
final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    var correctAnswersAmount: Int
    
    private enum Keys{
        static let gamesCountKey = "gamesCount"
        static let bestGameCorrectKey = "bestGameCorrect"
        static let bestGameTotalKey = "bestGameTotal"
        static let bestGameDateKey = "bestGameDate"
        static let totalAccuracyKey = "totalAccuracy"
    }
    
    init(correctAnswersAmount: Int) {
        self.correctAnswersAmount = correctAnswersAmount
    }
    
    var gamesCount: Int {
//        let currentGamesCount = UserDefaults.standard.integer(forKey: "gamesCount")
//        let newGamesCount = currentGamesCount + 1
        get {
            return storage.integer(forKey: Keys.gamesCountKey)
        }
        set {
            storage.set(newValue,forKey: Keys.gamesCountKey)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrectKey)
            let total = storage.integer(forKey: Keys.bestGameTotalKey)
            let date = storage.object(forKey: Keys.bestGameDateKey) as? Date ?? Date.distantPast
            
            return GameResult(correct: correct, total: total, date: date)

        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrectKey)
            storage.set(newValue.total, forKey: Keys.bestGameTotalKey)
            storage.set(newValue.date, forKey: Keys.bestGameDateKey)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return storage.double(forKey: Keys.totalAccuracyKey)
            
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracyKey)
        }
    }
    
    func store(resultOfGame: GameResult) {
        totalAccuracy = 0.0
        let newGamesCount = gamesCount + 1
        gamesCount = newGamesCount
        
        let totalQuestionsCount = Double(gamesCount) * 10.0
        let correctAnswersCount = totalAccuracy * totalQuestionsCount / 100.0 + Double(resultOfGame.correct)
        
        guard gamesCount != 0 else {
            return
        }
        
        let newAccuracy = (correctAnswersCount/totalQuestionsCount) * 100
        totalAccuracy = newAccuracy
        
        if resultOfGame.isBiggerThan(bestGame) {
            bestGame = resultOfGame
        }
    }
    
  
}
