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
    
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSut(questions: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        makeSut(questions: ["Q1"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        makeSut(questions: ["Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTowQuestions_routesToFirstQuestion() {
        makeSut(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTowQuestions_routesToFirstQuestionTwice() {
        let sut = makeSut(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTowQuestions_routesToSecondQuestion() {
        
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    func test_startAndAnswerTwoQuestions_withThreeQuestions_routesToSecondAndThirdQuestion() {
        
        let sut = Flow(questions: ["Q1", "Q2", "Q3"], router: router)
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doNotRoutesToAnotherQuestion() {
        
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routeToResult() {
        makeSut(questions: []).start()
        
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_drouteToResult() {
        
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers

    func makeSut(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
}


class RouterSpy: Router {

    var routedQuestions: [String] = []
    var routedResult: [String: String]? = nil
    
    var answerCallback: Router.AnswerCallBack = { _ in }

    func routeTo(question: String, answerCallback: @escaping Router.AnswerCallBack) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: [String : String]) {
        routedResult = result
    }
}
