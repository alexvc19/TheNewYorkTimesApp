//
//  LMPEmailArticlesRouter.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import UIKit
class LMPEmailArticlesRouter: UIViewController {
    private var mainView: UIViewController?
    var viewController: UIViewController {
        return navViewController()
    }
    private func navViewController() -> UIViewController {
        let view = LMPEmailArticlesVC(nibName: "LMPEmailArticlesVC", bundle: Bundle.main)
        return view
    }
    func setMainView(_ mainView: UIViewController?) {
        guard let view = mainView else {
            fatalError("Error")
        }
        self.mainView = view
    }
}
