//
//  MainAppRouter.swift
//  MainApp
//
//  Created by Mahmoud Abdelwahab on 03/05/2024.
//

import UIKit
import UniversityList
import UniversityDetails

public class MainAppRouter {
    
    static var shared = MainAppRouter()
    private var navigationController: UINavigationController
    weak var delegate: RefreshScreenActionDelegate?
    
    private init() {
        self.navigationController = UINavigationController()
    }
    
    func start(window: UIWindow?) {
        guard let window = window else {
            fatalError("Window is nil")
        }
        let universityApiService = UniversityApiSevice.shared
        let realmManager = RealmManager.shared
        let initialViewController = UniversityListRouter.assembleModule(universityApiService: universityApiService, realmManager: realmManager, mainAppRouter: self, delegate: &delegate)
        
        navigationController.viewControllers = [initialViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

// MARK: - University List Navigation

extension MainAppRouter : UniversityListRouterProtocol {
    
    public func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController.present(alertController, animated: true, completion: nil)
    }
    
    public func navigateToDetailsScreen(with model: UniversityCellVM) {
        let model = UniversityDetailsViewModel(name: model.name, stateProvince: model.stateProvince, webPage: model.webPage, countryCode: model.countryCode, country: model.country)
        
        let view = UniversityDetailsRouter.assembleModule(universityDetailsModel: model) { [weak self] in
            guard let self else { return}
            let listViewContoller = self.navigationController.viewControllers.first as? UniversityListViewController
            delegate?.didTapRefreshScreenAction()
        }
        navigationController.present(view, animated: true)
    }
}


