//
//  TheNewYorkTimesTests.swift
//  TheNewYorkTimesTests
//
//  Created by Alejandro Velasco on 17/10/24.
//

import XCTest
import CoreData
@testable import TheNewYorkTimes

final class TheNewYorkTimesTests: XCTestCase {
    var managerConnections: ManagerConnections!
    var coreData: CoreDataManager!

    override func setUpWithError() throws {
        managerConnections = ManagerConnections()
        coreData = CoreDataManager.shared
    }

    override func tearDownWithError() throws {
        managerConnections = nil
    }
    ///Conexion con la API
    func testGetDataFromAPI() throws {
        let expectation = self.expectation(description: "get articles from API")
        let disposable = managerConnections.getMPEmailArticles()
            .subscribe(onNext: { articles in
                XCTAssertFalse(articles.isEmpty, "Expected to receive articles from API but got none.")
                if let firstArticle = articles.first {
                    XCTAssertNotNil(firstArticle.title, "Doesnt have title")
                    XCTAssertNotNil(firstArticle.byline, "Doesnt have byline")
                    XCTAssertNotNil(firstArticle.media, "Doesnt have media data")
                    if let firstMedia = firstArticle.media.first,
                       let firstMediaMetadata = firstMedia.mediaMetadata.first {
                        XCTAssertNotNil(firstMediaMetadata.url, "Doesnt have URL photo")
                    } else {
                        XCTFail("Doesnt have media and media metadata")
                    }
                }
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error: \(error.localizedDescription)")
            })
        waitForExpectations(timeout: 5, handler: nil)
        disposable.dispose()
    }
    ///Recuperacion y guardado de datos
    func testCoreData() throws {
        let articleID = 123
        let title = "New iphone 16"
        let byline = "By alex"
        let publishedDate = "2024-10-18"
        let abstract = "Its the same think that last year"
        let type = "Article"
        let mediaMetadataURL = "https://media.gq.com.mx/photos/66df44567d3ceddfd877165b/2:3/w_1332,h_1998,c_limit/Apple_iPhone_16_gama_colores%20(1).jpg"
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ListArticles", into: coreData.context) as! ListArticles
            entity.id = Int64(articleID)
            entity.title = title
            entity.byline = byline
            entity.publishedDate = publishedDate
            entity.abstract = abstract
            entity.type = type
        let mediaEntity = NSEntityDescription.insertNewObject(forEntityName: "Media", into: coreData.context) as! Media
        mediaEntity.article = entity
        let mediaMetadataEntity = NSEntityDescription.insertNewObject(forEntityName: "MediaMetadata", into: coreData.context) as! MediaMetadata
        mediaMetadataEntity.url = mediaMetadataURL
        mediaMetadataEntity.media = mediaEntity
        try coreData.context.save()
        let fetchRequest: NSFetchRequest<ListArticles> = ListArticles.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", articleID)
        let fetchedArticles = try coreData.context.fetch(fetchRequest)
        XCTAssertFalse(fetchedArticles.isEmpty, "Not found article")
        if let fetchedArticle = fetchedArticles.first {
            XCTAssertEqual(fetchedArticle.id, Int64(articleID), "Doesnt match id")
            XCTAssertEqual(fetchedArticle.title, title, "Doesnt match title")
            XCTAssertEqual(fetchedArticle.byline, byline, "Doesnt match byline")
            XCTAssertEqual(fetchedArticle.publishedDate, publishedDate, "Doesnt match publishedDate mismatch.")
            XCTAssertEqual(fetchedArticle.abstract, abstract, "Doesnt match abstract")
            XCTAssertEqual(fetchedArticle.type, type, "Doesnt match type")
            XCTAssertNotNil(fetchedArticle.media,"Doesnt match media")
            if let fetchedMedia = fetchedArticle.media?.allObjects.first as? Media {
                XCTAssertNotNil(fetchedMedia.mediaMetadata, "Doesnt match mediaMetadata with media")
                if let fetchedMediaMetadata = fetchedMedia.mediaMetadata?.allObjects.first as? MediaMetadata {
                    XCTAssertEqual(fetchedMediaMetadata.url, mediaMetadataURL, "Doesnt match URL")
                } else {
                    XCTFail("Dont found mediaMetadata")
                }
            } else {
                XCTFail("Dont found media")
            }
        } else {
            XCTFail("Fail")
        }
    }
}
