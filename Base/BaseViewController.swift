//
//  BaseViewController.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit
import NeoBase

open class BaseViewController<ViewModel>: UIViewController, ViewModelProviding {
    /// ViewModel for the ViewController.
    ///
    /// The `viewModel` property implementation required by the `ViewModelProviding` protocol.
    /// It is marked as `final` to prevent overriding by subclasses.
    public final var viewModel: ViewModel
    
    /// The background color of view.
    ///
    /// Subclasses can directly assign a color to this property to set the view's background color.
    ///
    /// - Important: You don't need to override this property; set it directly in subclasses instead.
    public final var surfaceColor: NeoColor = .neo(.surface, color: .default) {
        didSet {
            view.backgroundColor = surfaceColor.value
        }
    }

    /// Performs initial setup for the view controller.
    ///
    /// This method is called during the initialization phase. Subclasses can override this method
    /// to perform setup tasks that need to be executed early in the lifecycle of the view controller.
    open func setupOnInit() { }
    
    /// Initializes the view controller with a specified view model.
    ///
    /// - Parameter viewModel: The view model associated with the view controller.
    public required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupOnInit()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented x ")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupOnDidLoad()
    }
}

// MARK: - Private Functionality
private extension BaseViewController {
    /// Perform any necessary setup after the view has loaded.
    func setupOnDidLoad() {
        view.backgroundColor = surfaceColor.value
    }
}
