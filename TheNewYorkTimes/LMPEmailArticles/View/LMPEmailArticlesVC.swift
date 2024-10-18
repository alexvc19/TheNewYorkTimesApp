//
//  LMPEmailArticlesVC.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import UIKit
import RxSwift
class LMPEmailArticlesVC: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var router = LMPEmailArticlesRouter()
    private var viewModel = LMPEmailArticlesViewModel()
    private var listOfArticles = [Article]()
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Most emailed articles"
        configureTable()
        viewModel.bind(view: self, router: router)
        getData()
    }
    private func getData() {
        return viewModel.getLMPEmailArticles()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { listOfArticles in
                self.listOfArticles = listOfArticles
                self.reloadTable()
            } onError: { error in
                
            }.disposed(by: disposeBag)
    }
    private func reloadTable() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        }
    }
    private func configureTable(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "LMPEmailArticleCell", bundle: nil), forCellReuseIdentifier: "LMPEmailArticleCell")
    }
}
extension LMPEmailArticlesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LMPEmailArticleCell") as! LMPEmailArticleCell
        cell.lblTitle.text = self.listOfArticles[indexPath.row].title
        cell.lblAuthor.text = self.listOfArticles[indexPath.row].byline
        cell.lblPublishedDate.text = self.listOfArticles[indexPath.row].publishedDate
        return cell
    }
}
