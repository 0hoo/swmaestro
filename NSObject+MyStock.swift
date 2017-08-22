//
//  NSObject+MyStock.swift
//  MyStock
//
//  Created by Kim Younghoo on 8/20/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import Foundation

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
