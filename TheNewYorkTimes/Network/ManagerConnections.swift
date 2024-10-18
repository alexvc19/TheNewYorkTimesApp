//
//  ManagerConnections.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 17/10/24.
//

import Foundation
import RxSwift
class ManagerConnections {
    func getMPEmailArticles() -> Observable<[Article]> {
        return Observable.create { observer in
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: ConstantsURLS.mainURL + ConstantsURLS.mostEmailedArticles+ConstantsURLS.APIKey)!)
            //print(ConstantsURLS.mainURL + ConstantsURLS.mostEmailedArticles+ConstantsURLS.APIKey)
            request.httpMethod = "GET"
            request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                    return
                }
                if response.statusCode == 200 {
                    do {
                        let listOfArticles = try MostPopularEmailedArticles.decode(from: data)
                        observer.onNext(listOfArticles.results)
                    } catch let error {
                        observer.onError(error)
                        print("error: \(error.localizedDescription)")
                    }
                } else if response.statusCode == 401 {
                    ///error 401
                }
                observer.onCompleted()
            }.resume()
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}
