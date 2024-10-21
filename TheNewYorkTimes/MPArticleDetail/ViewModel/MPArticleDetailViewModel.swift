//
//  MPArticleDetailViewModel.swift
//  TheNewYorkTimes
//
//  Created by CRISTIAN ALEJANDRO VELASCO CERNAS on 18/10/24.
//

import Foundation
class MPArticleDetailViewModel {
    private(set) var view: MPArticleDetailVC?
    private var router: MPArticleDetailRouter?
    func bind(view: MPArticleDetailVC, router: MPArticleDetailRouter){
        self.view = view
        self.router = router
        self.router?.setMainView(view)
    }
}
