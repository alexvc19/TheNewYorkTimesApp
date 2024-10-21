//
//  MPArticleDetailVC.swift
//  TheNewYorkTimes
//
//  Created by CRISTIAN ALEJANDRO VELASCO CERNAS on 18/10/24.
//

import UIKit

class MPArticleDetailVC: UIViewController {
    @IBOutlet private weak var lblType: UILabel!
    @IBOutlet private weak var lblAuthor: UILabel!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblPublishDate: UILabel!
    @IBOutlet private weak var imageArticle: UIImageView!
    @IBOutlet private weak var lblAbstract: UILabel!
    private var viewModel = MPArticleDetailViewModel()
    private var router = MPArticleDetailRouter()
    var article: Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        setUpData()
    }
    func setUpData() {
        if let article = article {
            lblType.text = article.type
            lblAuthor.text = article.byline
            lblTitle.text = article.title
            lblPublishDate.text = article.publishedDate
            lblAbstract.text = article.abstract
            if let firstMedia = article.media.first,
               let firstMediaMetadata = firstMedia.mediaMetadata.last {
                let imageUrl = firstMediaMetadata.url
                imageArticle.imageURL(urlString: imageUrl, placeHolder: UIImage(systemName: "pencil.slash")!)
            } else {
                imageArticle.image = UIImage(systemName: "photo")
            }
        } else {
            lblType.text = "No disponible"
            lblAuthor.text = "Autor no disponible"
            lblTitle.text = "Título no disponible"
            lblPublishDate.text = "Fecha no disponible"
            lblAbstract.text = "Descripción no disponible"
            imageArticle.image = UIImage(systemName: "photo")
        }
    }

}
