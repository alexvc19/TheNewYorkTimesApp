//
//  LMPEmailArticlesViewModel.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import Foundation
import RxSwift
class LMPEmailArticlesViewModel {
    private weak var view: LMPEmailArticlesVC?
    private var router: LMPEmailArticlesRouter?
    private var manager = ManagerConnections()
    func bind(view: LMPEmailArticlesVC, router: LMPEmailArticlesRouter){
        self.view = view
        self.router = router
        self.router?.setMainView(view)
    }
    func getLMPEmailArticles() -> Observable<[Article]>{
        return manager.getMPEmailArticles()
    }
    func goToDetailView(article: Article) {
        router?.navToArticleDetail(article: article)
    }
}
