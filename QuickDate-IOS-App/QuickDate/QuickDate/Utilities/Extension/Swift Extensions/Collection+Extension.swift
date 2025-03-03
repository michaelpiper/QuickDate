//
//  Collection.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 23.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
