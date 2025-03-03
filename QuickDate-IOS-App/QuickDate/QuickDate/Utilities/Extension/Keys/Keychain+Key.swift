//
//  Keychain+Key.swift
//  Libraries And Extensions
//
//  Created by Nazmi Yavuz on 15.11.2021.
//  Copyright © 2021 Nazmi Yavuz. All rights reserved.
//

import Foundation

extension KeychainKey {
    
    static let myString = ChainKey<String>("myString")
    
    static let myInt = ChainKey<Int>("myInt")
    
    static let myDouble = ChainKey<Double>("myDouble")
    static let myFloat = ChainKey<Float>("myFloat")

    static let myBool = ChainKey<Bool>("myBool")
    
}
