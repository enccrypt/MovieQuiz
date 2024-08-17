//
//  QuestionFactoryDelegate .swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 27.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() 
    func didFailToLoadData(with error: Error)
}
