//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 21.08.2024.
//

import Foundation

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenter? { get }
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func setButtonsEnabled(_ isEnabled: Bool)
    func didPresentAlert()
}

