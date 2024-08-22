//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 20.08.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var correctAnswers: Int = 0
    private var questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0

    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService(correctAnswersAmount: correctAnswers)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        viewController.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
       
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func isLastQuestion() -> Bool {
        return currentQuestionIndex >= questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func showModel() {
        self.questionFactory?.requestNextQuestion() // асинхронный вызов фабрики
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
    
    func buttonClicked(_ buttonValue: Bool){
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let userAnswerIsCorrect: Bool = buttonValue == currentQuestion.correctAnswer
        
        if userAnswerIsCorrect{
            correctAnswers += 1
        }
        
        viewController?.setButtonsEnabled(false)
        self.showAnswerResult(isCorrect: userAnswerIsCorrect)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let currentDate = Date()
            let result = GameResult(
                correct: correctAnswers,
                total: self.questionsAmount,
                date: currentDate)
            
            
            statisticService?.store(resultOfGame: result)
            
            guard let gamesCount = statisticService?.gamesCount,
            let bestGame = statisticService?.bestGame,
            let totalAccuracy = statisticService?.totalAccuracy else {
                return
            }
            
            let bestGameDate = bestGame.date.dateTimeString

            let textContent: [String] = [
                "Ваш результат: \(correctAnswers)/10",
                "Количество сыгранных квизов: \(gamesCount)",
                "Рекорд: \(bestGame.correct)/10 (\(bestGameDate))",
                "Средняя точность: \("\(String(format: "%.2f", totalAccuracy))%")"
            ]
                    
            let text = textContent.joined(separator: "\n")
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            }
                                        
            self.viewController?.alertPresenter?.presentAlert(alertView: alertModel)
        } else { 
            self.switchToNextQuestion()
            showModel() // асинхронный вызов фабрики
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
}
