//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 03.08.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBiggerThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}

