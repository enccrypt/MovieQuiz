//
//  QuestionFactoryDelegate .swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 27.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
