//
//  Flow.swift
//  QuizEngine
//
//  Created by Pawel Kacela on 22/05/2021.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
}

class Flow {
    
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { [weak self] _ in
                guard let strongSelf = self else { return }
                let firstQuesionIndex = strongSelf.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[firstQuesionIndex+1]
                strongSelf.router.routeTo(question: nextQuestion) { _ in }
            }
        }
    }
    
}
