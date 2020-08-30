//
//  Network.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import Foundation

class Network {
    static let shared = Network()
    var tasks: [URL: URLSessionDataTask] = [:]
    private let base = "https://api.bestbuy.com/v1/products"
    private let apiKey = "7Ob7hGyGMBma1ilGiq7tc2XZ"

    private func urlForSearch(_ tokens: [String], atPage page: Int) -> URL? {
        let search = "(search=\(tokens.joined(separator: "&search=")))"
        let queryItems = ["show": "name,sku,salePrice,image,longDescription,url,customerReviewAverage,customerReviewCount",
                     "format": "json",
                     "apiKey": apiKey,
                     "page": "\(page)"]

        let query = queryItems.map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")

        let path = "\(base)\(search)?\(query)"
        return URL(string: path)
    }

    private func urlForSKU(_ sku: String) -> URL? {
        let urlString = "\(base)/\(sku).json?apiKey=\(apiKey)"
        return URL(string: urlString)
    }

    /// Mocking URLSession isn't that hard. Some tests would be nice.
    func search(_ string: String, atPage page: Int, completion: @escaping (Result<ProductPage, Error>) -> ()) {
        guard let url = self.urlForSearch(string.tokenize(), atPage: page) else { return }
        guard self.tasks[url] == nil else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Don't muck with our internal variables on multiple threads.
            DispatchQueue.main.sync {
                self.tasks[url] = nil
            }

            if let data = data {
                do {
                let productPage = try JSONDecoder().decode(ProductPage.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(productPage))
                    }
                }
                catch {
                    // The BestBuy API is rate limited, If it returns with a status code of 403 just try again in one second.
                    if let response = response as? HTTPURLResponse, response.statusCode == 403 {
                        let deadline = DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(1))
                        DispatchQueue.main.asyncAfter(deadline: deadline) {
                            self.search(string, atPage: page, completion: completion)
                        }
                        return
                    }
                    else {
                        print("decoding error: \(error)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.fluffybunnysoftware.bbate", code: 999, userInfo: [NSLocalizedDescriptionKey: "Search failed with unknown error"])
                    completion(.failure(error))
                }
            }
        }

        self.tasks[url] = task
        task.resume()
    }

    func cancelSearch(_ string: String, atPage page: Int) {
        guard let url = self.urlForSearch(string.tokenize(), atPage: page) else { return }

        if let task = self.tasks[url] {
            task.cancel()
            self.tasks[url] = nil
        }
    }

    func fetchDetails(_ sku: String, completion: @escaping (Result<Product, Error>) -> ()) {
        guard let url = urlForSKU(sku) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                let productPage = try JSONDecoder().decode(Product.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(productPage))
                    }
                }
                catch {
                    print("decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.fluffybunnysoftware.bbate", code: 999, userInfo: [NSLocalizedDescriptionKey: "Search failed with unknown error"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
