//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 20.08.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    var questionsAmount: Int = 10
        
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        buttonClicked(true)
    }
    
   func noButtonClicked() {
        buttonClicked(false)
    }
    
    private func buttonClicked(_ buttonValue: Bool){
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        viewController?.showAnswerResult(isCorrect: buttonValue == currentQuestion.correctAnswer)
        
    }
    
    
    
    
}
