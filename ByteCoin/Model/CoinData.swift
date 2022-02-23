//
//  CoinData.swift
//  ByteCoin
//
//  Created by Paulina Vara on 18/08/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let rate: Double
    let asset_id_quote: String
}
