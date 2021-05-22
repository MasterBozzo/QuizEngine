//
//  Flow.swift
//  QuizEngine
//
//  Created by Pawel Kacela on 22/05/2021.
//

import Foundation

protocol Router {
    typealias AnswerCallBack = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallBack)
}

class Flow {
    
   private let router: Router
    private let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallBack {
        return { [ weak self ] _ in
            guard let strongSelf = self else { return }
            if let currentQuestionIndex = strongSelf.questions.firstIndex(of: question) {
                if currentQuestionIndex+1 < strongSelf.questions.count {
                    let nextQuestion = strongSelf.questions[currentQuestionIndex+1]
                    strongSelf.router.routeTo(question: nextQuestion, answerCallback: strongSelf.routeNext(from: nextQuestion))
                }
            }
        }
    }
    
}




