import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(delegate: self)
        self.questionFactory = questionFactory
        
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.delegate = self
        
        statisticService = StatisticService(correctAnswersAmount: correctAnswers)
        
        show(currentIndex: currentQuestionIndex)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didPresentAlert() {
        currentQuestionIndex = 0
        correctAnswers = 0
        show(currentIndex: currentQuestionIndex)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        buttonClicked(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        buttonClicked(false)
    }
    
    private func buttonClicked(_ buttonValue: Bool){
        guard let currentQuestion = currentQuestion else {
            return
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        showAnswerResult(isCorrect: buttonValue == currentQuestion.correctAnswer)

    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return quizStep
    }
    
    private func show(currentIndex: Int){
        questionFactory?.requestNextQuestion() // асинхронный вызов фабрики
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(currentIndex: self.currentQuestionIndex)
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
            imageView.layer.masksToBounds = true // разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки согласно макету
            if isCorrect {
                imageView.layer.borderColor = UIColor.ypGreen.cgColor
                correctAnswers += 1
            } else {
                imageView.layer.borderColor = UIColor.ypRed.cgColor
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // 1
            let currentDate = Date()
            let result = GameResult(
                correct: correctAnswers,
                total: questionsAmount,
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
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.show(currentIndex: self.currentQuestionIndex)
            }
                                        
            alertPresenter?.presentAlert(alertView: alertModel)
        } else { // 2
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() // асинхронный вызов фабрики
            
        }
    }
}


/*
 Mock-данные
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
