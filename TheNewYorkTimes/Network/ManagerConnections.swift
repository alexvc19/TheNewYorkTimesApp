//
//  ManagerConnections.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import Foundation
import RxSwift
import CoreData
class ManagerConnections {
    func getMPEmailArticles() -> Observable<[Article]> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<ListArticles> = ListArticles.fetchRequest()
            do {
                let savedArticles = try CoreDataManager.shared.context.fetch(fetchRequest)
                    if !savedArticles.isEmpty {
                        let articles = savedArticles.map { savedArticle in
                            var mediaList: [ArticleMedia] = []
                            if let mediaEntities = savedArticle.media as? Set<Media> {
                                for mediaEntity in mediaEntities {
                                    var mediaMetadataList: [ArticleMediaMetadata] = []
                                    if let metadataEntities = mediaEntity.mediaMetadata as? Set<MediaMetadata> {
                                        for metadataEntity in metadataEntities {
                                            let mediaMetadata = ArticleMediaMetadata(url: metadataEntity.url ?? "")
                                            mediaMetadataList.append(mediaMetadata)
                                        }
                                    }
                                    let articleMedia = ArticleMedia(mediaMetadata: mediaMetadataList)
                                    mediaList.append(articleMedia)
                                }
                            }
                            return Article(
                                id: Int(savedArticle.id),
                                publishedDate: savedArticle.publishedDate ?? "",
                                byline: savedArticle.byline ?? "",
                                type: savedArticle.type ?? "",
                                title: savedArticle.title ?? "",
                                abstract: savedArticle.abstract ?? "",
                                media: mediaList
                            )
                        }
                        observer.onNext(articles)
                        observer.onCompleted()
                        return Disposables.create()
                    }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: ConstantsURLS.mainURL + ConstantsURLS.mostEmailedArticles + ConstantsURLS.APIKey)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    observer.onError(NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response."]))
                    return
                }
                switch response.statusCode {
                case 200:
                    do {
                        let listOfArticles = try MostPopularEmailedArticles.decode(from: data)
                        for article in listOfArticles.results {
                            let listArticle = ListArticles(context: CoreDataManager.shared.context)
                            listArticle.id = Int64(article.id)
                            listArticle.publishedDate = article.publishedDate
                            listArticle.byline = article.byline
                            listArticle.type = article.type
                            listArticle.title = article.title
                            listArticle.abstract = article.abstract
                            for media in article.media {
                                let mediaEntity = Media(context: CoreDataManager.shared.context)
                                mediaEntity.article = listArticle
                                for metadata in media.mediaMetadata {
                                    let mediaMetadataEntity = MediaMetadata(context: CoreDataManager.shared.context)
                                    mediaMetadataEntity.media = mediaEntity
                                    mediaMetadataEntity.url = metadata.url
                                }
                                listArticle.addToMedia(mediaEntity)
                            }
                        }
                    
                        try CoreDataManager.shared.context.save()
                        observer.onNext(listOfArticles.results)
                        observer.onCompleted()
                    } catch let decodingError {
                        observer.onError(decodingError)
                    }
                case 401:
                    let errorMessage = "Unauthorized."
                    observer.onError(NSError(domain: "Unauthorized", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                default:
                    let errorMessage = "Something's wrong: \(response.statusCode)"
                    observer.onError(NSError(domain: "HTTPError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                }
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}
