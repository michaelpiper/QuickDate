//
//  Logger.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 5.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import SwiftyBeaver

/// Handle logging functionality
public let Logger = SwiftLogger.shared

public class SwiftLogger {
    
    // MARK: - Properties
    public static let shared = SwiftLogger()
    // Private
    private let log = SwiftyBeaver.self

    // MARK: - Initialiser
    private init() {
        let consoleDestination = ConsoleDestination()
        consoleDestination.minLevel = .verbose
        log.addDestination(consoleDestination)
    }
    // MARK: - Public Functions
    /// log something generally unimportant (lowest priority)
    public func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        log.verbose(message(), file, function, line: line, context: context)
    }
    /// log something which help during debugging (low priority)
    public func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        log.debug(message(), file, function, line: line, context: context)
    }
    /// log something which you are really interested but which is not an issue or error (normal priority)
    public func info(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        log.info(message(), file, function, line: line, context: context)
    }
    /// log something which may cause big trouble soon (high priority)
    public func warning(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        log.warning(message(), file, function, line: line, context: context)
    }
    /// log something which will keep you awake at night (highest priority)
    public func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        log.error(message(), file, function, line: line, context: context)
    }
}
