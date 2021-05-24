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
    func routeTo(result: [String: String])
}

class Flow {
    
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallBack {
        return { [ weak self ] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
    
}




