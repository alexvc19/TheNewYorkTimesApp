//
//  MostPopularEmailedArticles.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import Foundation
struct MostPopularEmailedArticles: Codable {
    let status: String
    let numResults: Int
    let results: [Article]
    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
    static func decode(from data: Data) throws -> MostPopularEmailedArticles {
        return try JSONDecoder().decode(MostPopularEmailedArticles.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.numResults = try container.decode(Int.self, forKey: .numResults)
        self.results = try container.decode([Article].self, forKey: .results)
    }
}
struct Article: Codable {
    let id: Int
    let publishedDate: String
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let media: [ArticleMedia]
    enum CodingKeys: String, CodingKey {
        case id
        case publishedDate = "published_date"
        case byline
        case type
        case title
        case abstract
        case media
    }
    init(id: Int, publishedDate: String, byline: String, type: String, title: String, abstract: String, media: [ArticleMedia]) {
        self.id = id
        self.publishedDate = publishedDate
        self.byline = byline
        self.type = type
        self.title = title
        self.abstract = abstract
        self.media = media
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        self.byline = try container.decode(String.self, forKey: .byline)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.abstract = try container.decode(String.self, forKey: .abstract)
        self.media = try container.decode([ArticleMedia].self, forKey: .media)
    }
}
struct ArticleMedia: Codable {
    let mediaMetadata: [ArticleMediaMetadata]
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
    init(mediaMetadata: [ArticleMediaMetadata]) {
        self.mediaMetadata = mediaMetadata
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mediaMetadata = try container.decode([ArticleMediaMetadata].self, forKey: .mediaMetadata)
    }
}
struct ArticleMediaMetadata: Codable {
    let url: String
}
