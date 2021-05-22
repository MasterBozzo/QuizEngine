//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Pawel Kacela on 22/05/2021.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTowQuestions_routesToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTowQuestions_routesToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTowQuestions_routesToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
}

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback: ((String) -> Void) = { _ in }

    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
}
