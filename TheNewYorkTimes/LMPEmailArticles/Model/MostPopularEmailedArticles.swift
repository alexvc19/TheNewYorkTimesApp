//
//  MostPopularEmailedArticles.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import Foundation
struct MostPopularEmailedArticles: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Article]
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
    static func decode(from data: Data) throws -> MostPopularEmailedArticles {
        return try JSONDecoder().decode(MostPopularEmailedArticles.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.copyright = try container.decode(String.self, forKey: .copyright)
        self.numResults = try container.decode(Int.self, forKey: .numResults)
        self.results = try container.decode([Article].self, forKey: .results)
    }
}
struct Article: Codable {
    let id: Int
    let assetID: Int
    let source: String
    let publishedDate: String
    let updated: String
    let section: String
    let subsection: String?
    let nytdsection: String
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let media: [Media]
    enum CodingKeys: String, CodingKey {
        case id
        case assetID = "asset_id"
        case source
        case publishedDate = "published_date"
        case updated
        case section, subsection
        case nytdsection
        case byline
        case type
        case title
        case abstract
        case media
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.assetID = try container.decode(Int.self, forKey: .assetID)
        self.source = try container.decode(String.self, forKey: .source)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        self.updated = try container.decode(String.self, forKey: .updated)
        self.section = try container.decode(String.self, forKey: .section)
        self.subsection = try container.decodeIfPresent(String.self, forKey: .subsection)
        self.nytdsection = try container.decode(String.self, forKey: .nytdsection)
        self.byline = try container.decode(String.self, forKey: .byline)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.abstract = try container.decode(String.self, forKey: .abstract)
        self.media = try container.decode([Media].self, forKey: .media)
    }
}
struct Media: Codable {
    let type: String
    let subtype: String
    let caption: String
    let copyright: String
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadata]
    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.subtype = try container.decode(String.self, forKey: .subtype)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.copyright = try container.decode(String.self, forKey: .copyright)
        self.approvedForSyndication = try container.decode(Int.self, forKey: .approvedForSyndication)
        self.mediaMetadata = try container.decode([MediaMetadata].self, forKey: .mediaMetadata)
    }
}
struct MediaMetadata: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
