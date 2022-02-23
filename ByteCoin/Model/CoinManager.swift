//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagement {
    func didUpdateCurrency (_ coinManager: CoinManager, rate: Double, currency: String)
    func didFailWithError (_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "757C89B4-24A7-4015-A1A9-67D331A1AAF5"
    var chosenCurrency: String? = nil
    var delegate: CoinManagement? = nil
    var url: String? {
        if chosenCurrency != nil {
            return "\(baseURL)/\(chosenCurrency!)?apikey=\(apiKey)"
        } else {
            return nil
        }
    }
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func performQuery () {
        if let safeURL = url {
            // 1. Create URL
            if let formatURL = URL(string: safeURL){
                // 2. Create URLSession
                let session = URLSession (configuration: .default)
                // 3. Give the session a task
                let task = session.dataTask(with: formatURL) { data, response, error in
                    if let safeError = error {
                        print(safeError)
                    }
                    
                    if let safeData = data {
                        //let dataString = String(data: safeData, encoding: .utf8)
                        //print(dataString ?? "")
                        parseJSON(coinData: safeData)
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
    }
    
    func parseJSON (coinData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            //print (decodedData.rate);
            //print (decodedData.asset_id_quote);
            delegate?.didUpdateCurrency(self, rate: decodedData.rate, currency: decodedData.asset_id_quote)
        }catch {
            delegate?.didFailWithError(self, error: error)
        }
    }
}
