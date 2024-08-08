//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Islam Tagirov on 30.07.2024.
//

import Foundation
import UIKit

class AlertPresenter{
    
    weak var viewController: UIViewController?
    weak var delegate: AlertPresenterDelegate?
    
    init(viewController: UIViewController?){
        self.viewController = viewController
    }

    func presentAlert(alertView: AlertModel?) {
        let alert = UIAlertController(
            title: alertView?.title,
            message: alertView?.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertView?.buttonText, style: .default) { _ in
            alertView?.completion?()
            self.delegate?.didPresentAlert()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    
}
