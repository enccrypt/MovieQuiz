//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 03.08.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(resultOfGame: GameResult)
}
