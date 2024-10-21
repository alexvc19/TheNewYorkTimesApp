//
//  MPArticleDetailRouter.swift
//  TheNewYorkTimes
//
//  Created by CRISTIAN ALEJANDRO VELASCO CERNAS on 18/10/24.
//

import Foundation
import UIKit
class MPArticleDetailRouter {
    var article: Article?
    init(article: Article? = nil) {
        self.article = article
    }
    private var mainView: UIViewController?
    var viewController: UIViewController {
        return navViewController()
    }
    func setMainView(_ mainView: UIViewController?) {
        guard let view = mainView else {
            fatalError("Error")
        }
        self.mainView = view
    }
    private func navViewController() -> UIViewController {
        let view = MPArticleDetailVC(nibName: "MPArticleDetailVC", bundle: Bundle.main)
        view.article = article
        return view
    }
}
