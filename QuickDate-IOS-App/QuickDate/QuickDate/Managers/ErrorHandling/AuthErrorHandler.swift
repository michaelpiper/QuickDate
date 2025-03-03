//
//  AuthErrorHandler.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// MARK: - Enum
/// Error to ease sign in and sign up logic.
/// Show user with alert controller
enum AuthError: Error {
    // FirstName
    case emptyFirstName
    case shortFirstName
    // LastName
    case emptyLastName
    case shortLastName
    // Mail
    case emptyEmail
    case invalidEmail
    // UserName
    case emptyUsername
    case shortUsername
    // Password
    case emptyPassword
    case passwordsNotMatch
    // Gender
    case genderNotSelected
    // Birthday
    case emptyBirthday
    case invalidAge
}

// MARK: - LocalizedError
// TODO: create localized string before release
extension AuthError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        // Name
        case .emptyFirstName:    return "Empty First Name!"
        case .shortFirstName:    return "Invalid First Name!"
        // Last Name
        case .emptyLastName:     return "Empty Last Name!"
        case .shortLastName:     return "Invalid Last Name!"
        // Mail
        case .emptyEmail:        return "Empty Email!"
        case .invalidEmail:      return "Invalid Email!"
        // User Name
        case .emptyUsername:     return "Empty Username!"
        case .shortUsername:     return "Short Username!"
        // Password
        case .emptyPassword:     return "Empty Password!"
        case .passwordsNotMatch: return "Passwords do not match!"
        // Gender
        case .genderNotSelected: return "Gender not selected!"
        // Birthday
        case .emptyBirthday:     return "Invalid Birthday!"
        case .invalidAge:        return "Under 18 years old."
        }
    }
    
    var failureReason: String? {
        switch self {
        // Name
        case .emptyFirstName:    return nil
        case .shortFirstName:    return "First name must have at least 2 characters."
        // Last Name
        case .emptyLastName:     return nil
        case .shortLastName:     return "Last name must have at least 2 characters."
        // Mail
        case .emptyEmail:        return nil
        case .invalidEmail:      return "Your entry does not match with email criteria.."
        // User Name
        case .emptyUsername:     return nil
        case .shortUsername:     return "Username must have at least 4 characters."
        // Password
        case .emptyPassword:     return nil
        case .passwordsNotMatch: return "Passwords do not match."
        // Gender
        case .genderNotSelected: return "Gender must have selected to find a friend."
        // Birthday
        case .emptyBirthday:     return "Birthday must be entered."
        case .invalidAge:        return "You must be at or above 18 years old."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        // Name
        case .emptyFirstName:    return nil
        case .shortFirstName:    return "You should check your name."
        // Last Name
        case .emptyLastName:     return nil
        case .shortLastName:     return "You should check your last name."
        // Mail
        case .emptyEmail:        return nil
        case .invalidEmail:      return "Sample Email: email@icloud.com"
        // User Name
        case .emptyUsername:     return nil
        case .shortUsername:     return "You should check your username."
        // Password
        case .emptyPassword:     return nil
        case .passwordsNotMatch: return "You should check passwords."
        // Gender
        case .genderNotSelected: return nil
        // Birthday
        case .emptyBirthday:     return nil
        case .invalidAge:        return nil
        }
    }
}
// MARK: - AlertPresentable
extension AuthError: CustomAlertPresentable {
    var alert: (title: String?, message: String?) {
        let title = errorDescription?.description ?? "Sorry!"
        switch (failureReason?.description, recoverySuggestion?.description) {
        case let (first?, last?):   return (title, (first + "\n\n" + last))
        case let (first?, nil):     return (title, first)
        case let (nil, last?):      return (title, last)
        default:                    return (title, nil)
        }
    }
}

// MARK: - CustomNSError
extension AuthError: CustomNSError {

    var errorUserInfo: [String: Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription ?? "",
            NSLocalizedFailureReasonErrorKey: failureReason ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? ""
        ]
    }
}

// MARK: - AuthenticationErrorHandler

struct AuthErrorHandler {
    
    static let `default` = AuthErrorHandler()
    
    // MARK: - Functions to check
    
    /// Check name validity in terms of name which is written by user
    /// - Parameter name: is written by the user from textField
    /// - Returns: name: which is come from validity check
    /// - Throws:
    ///     - AuthError.emptyFirstName
    ///     - AuthError.shortFirstName
    func checkName(_ name: String?) throws -> String {
        guard let name = name, !name.isEmpty else { throw AuthError.emptyFirstName }
        guard name.count > 1 else { throw AuthError.shortFirstName }
        return name.lowercased()
    }
    
    /// Check last name validity in terms of last name which is written by user
    /// - Parameter lastName: is written by the user from textField
    /// - Returns: lastName: which is come from validity check
    /// - Throws:
    ///     - AuthError.emptyLastName
    ///     - AuthError.shortLastName
    func checkLastName(_ lastName: String?) throws -> String {
        guard let lastName = lastName, !lastName.isEmpty else { throw AuthError.emptyLastName }
        guard lastName.count > 1 else { throw AuthError.shortLastName }
        return lastName.lowercased()
    }
    
    /// Check email validity in terms of email style which is written by user
    /// - Parameter email: is written by the user from textField
    /// - Returns: Email: which is come from validity check
    /// - Throws:
    ///     - AuthError.emptyEmail
    ///     - AuthError.invalidEmail
    func checkEmail(_ email: String?) throws -> String {
        guard let email = email, !email.isEmpty else { throw AuthError.emptyEmail }
        guard checkEmailValidity(with: email) else { throw AuthError.invalidEmail }
        return email.lowercased()
    }
    
    /// Check userName validity in terms of last userName which is written by user
    /// - Parameter lastName: is written by the user from textField
    /// - Returns: userName: which is come from validity check
    /// - Throws:
    ///     - AuthError.emptyLastName
    ///     - AuthError.shortLastName
    func checkUserName(_ userName: String?) throws -> String {
        guard let userName = userName, !userName.isEmpty else { throw AuthError.emptyUsername }
        guard userName.count > 3 else { throw AuthError.shortUsername }
        return userName.lowercased()
    }
    
    /// Check password which is written by user
    /// - Parameter password: is written by the user from textField
    /// - Returns: password: which is come from validity check, must be longer than 5 characters
    /// - Throws:
    ///     - AuthError.emptyPassword
    ///     - AuthError.shortPassword
    func checkPassword(_ password: String?) throws -> String {
        guard let password = password, !password.isEmpty else { throw AuthError.emptyPassword }
        return password
    }
    
    /// Check passwords matching which is written by user
    /// - Parameters:
    ///   - first: first password
    ///   - second: second password
    /// - Returns: password after match
    func checkMatchingPassword(first: String?, second: String?) throws -> String {
        do {
            let first = try checkPassword(first)
            let second = try checkPassword(second)
            guard first == second else { throw AuthError.passwordsNotMatch }
            return first
        } catch {
            throw error
        }
    }
    
    /// Check gender which is entered or not
    /// - Parameter genderCode: gender is entered by the user according to admin settings
    /// - Returns: gender value which will be send to the server
    func checkGender(_ genderCode: String?) throws -> String {
        switch genderCode {
        case .none:           throw AuthError.genderNotSelected
        case .some(let code): return code
        }
    }
    
    /// Users have to enter their birthBay and
    /// they are must ve at or above 18 years old.
    /// - Parameter birthDay: date which is written by the user
    func checkBirthday(with birthDay: Date?) throws -> String {
        guard let birthDay = birthDay else { throw AuthError.emptyBirthday }
        let today = Date()
        let parentalDate = birthDay.adding(.year, value: 18)
        Logger.debug(parentalDate)
        if today < parentalDate {
            throw AuthError.invalidAge
        }
        return birthDay.getFormattedDate(format: "yyyy-MM-dd")
    }
    
    // MARK: - Private Functions
    
    private func checkEmailValidity(with email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
}
