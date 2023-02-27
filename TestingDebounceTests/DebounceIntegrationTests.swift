//
//  DebounceIntegrationTests.swift
//  TestingDebounceTests
//
//  Created by Islom on 26/02/23.
//

import Combine
import XCTest
@testable import TestingDebounce

final class DebounceIntegrationTests: XCTestCase {
    func test() {
        let notificationCenter = NotificationCenter()
        let (sut, loader) = makeSUT(notificationCenter: notificationCenter)
        
        sut.loadViewIfNeeded()
        sut.textField.text = "first message"
        notificationCenter.post(name: UITextField.textDidChangeNotification, object: sut.textField)
                
        XCTAssertEqual(loader.message, "first message")
    }
    
    private func makeSUT(notificationCenter: NotificationCenter = .default) -> (sut: FieldViewController<ImmediateScheduler>, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FieldFactory.makeFieldViewController(notificationCenter: notificationCenter, scheduler: ImmediateScheduler.shared, loader: loader.loadPublisher(for:))
        return (sut, loader)
    }
    
    private class LoaderSpy {
        private(set) var message: String?
        
        func loadPublisher(for text: String) -> AnyPublisher<Void, Error> {
            message = text
            let publisher = PassthroughSubject<Void, Error>()
            return publisher.eraseToAnyPublisher()
        }
    }
}
