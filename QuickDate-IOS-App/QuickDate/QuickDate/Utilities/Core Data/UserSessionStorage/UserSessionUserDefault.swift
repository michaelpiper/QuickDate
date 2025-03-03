

import Foundation

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
}

// FIXME: Delete this values before release
extension UserDefaults {
    // MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    // MARK: Save User Data
    func setUserSession(value: [String:Any], ForKey:String) {
        set(value, forKey: ForKey)
        //synchronize()
    }
    func getUserSessions(Key:String) -> [String:Any]{
        return (object(forKey: Key) as? [String:Any]) ?? [:]
    }
}
