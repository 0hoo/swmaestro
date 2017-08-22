//
//  StockSearchService.swift
//  MyStock
//
//  Created by Kim Younghoo on 8/23/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

protocol StockSearchProtocol {
    func search(stockCode: String, onStock: @escaping (Stock) ->())
}

class StockSearchService: StockSearchProtocol {
    
    func search(stockCode: String, onStock: @escaping (Stock) ->()) {
        let siteUrl = "http://finance.daum.net/item/main.daum?code=" + stockCode
        Alamofire.request(siteUrl).responseString { response in
            guard let html = response.result.value else { return }
            guard let doc = HTML(html: html, encoding: .utf8) else { return }
            guard let nameElement = doc.at_css("#topWrap > div.topInfo > h2"), let name = nameElement.content else { return }
            guard let priceElement = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(1) > em"), let priceString = priceElement.content else { return }
            guard let currentPrice = Double(priceString.replacingOccurrences(of: ",", with: "")) else { return }
            
            let priceKeep = priceElement.className?.hasSuffix("keep") == true
            let priceUp = priceElement.className?.hasSuffix("up") == true
            let priceDiffString = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(2) > span")?.content ?? ""
            let priceDiff = Double(priceDiffString.replacingOccurrences(of: ",", with: "")) ?? 0
            var rateDiffString = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(3) > span")?.content ?? ""
            if rateDiffString.hasSuffix("％") || rateDiffString.hasSuffix("%") {
                rateDiffString = rateDiffString.substring(to: rateDiffString.index(rateDiffString.startIndex, offsetBy: rateDiffString.characters.count - 1))
            }
            if rateDiffString.hasPrefix("+") || rateDiffString.hasPrefix("-") {
                rateDiffString = rateDiffString.substring(from: rateDiffString.index(rateDiffString.startIndex, offsetBy: 1))
            }
            let rateDiff = Double(rateDiffString.replacingOccurrences(of: ",", with: "")) ?? 0
            let stock = Stock(stockId: nil, code: stockCode, name: name, currentPrice: currentPrice, priceDiff: priceDiff, rateDiff: rateDiff, isPriceUp: priceUp, isPriceKeep: priceKeep)
            onStock(stock)
        }
    }
}
