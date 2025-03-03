//
//  DispatchQueue+Extension.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 13.12.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
}
