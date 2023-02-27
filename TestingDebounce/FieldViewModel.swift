//
//  FieldViewModel.swift
//  TestingDebounce
//
//  Created by Islom on 26/02/23.
//

import Combine
import Foundation

final class FieldViewModel<S: Scheduler> {
    private var cancellables = Set<AnyCancellable>()
    let textPublisher = CurrentValueSubject<String, Never>("")
    
    private let scheduler: S
    private let loader: (String) -> AnyPublisher<Void, Error>
    
    init(scheduler: S, loader: @escaping (String) -> AnyPublisher<Void, Error>) {
        self.scheduler = scheduler
        self.loader = loader
    }
    
    func loadData() {
        textPublisher
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: scheduler)
            .flatMap { [loader] text in
                loader(text)
            }
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
}
