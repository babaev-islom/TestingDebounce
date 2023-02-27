//
//  FieldViewController.swift
//  TestingDebounce
//
//  Created by Islom on 26/02/23.
//

import UIKit
import Combine

final class FieldViewController<S: Scheduler>: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Type..."
        field.textColor = .red
        field.backgroundColor = .lightGray
        return field
    }()
    
    private let notificationCenter: NotificationCenter
    private let viewModel: FieldViewModel<S>
    
    init(notificationCenter: NotificationCenter, viewModel: FieldViewModel<S>) {
        self.notificationCenter = notificationCenter
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
        
        notificationCenter.publisher(
            for: UITextField.textDidChangeNotification,
            object: textField
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .subscribe(viewModel.textPublisher)
        .store(in: &cancellables)
        
        viewModel.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame = CGRect(x: 40, y: 100, width: 300, height: 50)
    }
}
