//
//  FieldFactory.swift
//  TestingDebounce
//
//  Created by Islom on 26/02/23.
//

import Foundation
import Combine

final class FieldFactory {
    private init() {}
    
    static func makeFieldViewController<S: Scheduler>(notificationCenter: NotificationCenter = .default, scheduler: S, loader: @escaping (String) -> AnyPublisher<Void, Error>) -> FieldViewController<S> {
        let viewModel = FieldViewModel(scheduler: scheduler, loader: loader)
        let viewController = FieldViewController(notificationCenter: notificationCenter, viewModel: viewModel)
        return viewController
    }
}
