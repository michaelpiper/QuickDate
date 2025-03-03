

import Foundation


extension UserDefaults{
    
    func setDeviceId(value: String, ForKey:String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    func getDeviceId(Key:String) ->  String{
        
        return ((object(forKey: Key) as? String) ?? "")!
        
    }
    func clearUserDefaults() {
        removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    func removeValuefromUserdefault(Key:String) {
        removeObject(forKey: Key)
    }
    
    func setPassword(value: String, ForKey:String) {
        set(value, forKey: ForKey)
        //synchronize()
    }
    
    func getPassword(Key:String) ->  String{
        return ((object(forKey: Key)  as?  String)!)
    }
    func setSettings(value:  Data, ForKey:String) {
        set(value, forKey: ForKey)
        //synchronize()
    }
    
    func getSettings(Key:String) ->  Data?{
        return (object(forKey: Key)  as?  Data) ?? Data()
    }
    func setStickers(value: Data, ForKey:String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    func getStickers(Key:String) ->  Data{
        return ((object(forKey: Key) as? Data) ?? Data())!
    }
    func setGifts(value: Data, ForKey:String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    func getGifts(Key:String) ->  Data{
        return ((object(forKey: Key) as? Data) ?? Data())!
    }
    func setFavoriteSongs(value: [Data], ForKey:String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    func getFavoriteSongs(Key:String) ->  [Data]{
        return ((object(forKey: Key) as? [Data]) ?? [])!
    }
    
    func setDarkMode(value: Bool, ForKey: String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    
    func getDarkMode(Key: String) -> Bool {
        return object(forKey: Key) as? Bool ?? false
    }
    
    func setSystemTheme(value: Bool, ForKey: String) {
        set(value, forKey: ForKey)
        synchronize()
    }
    
    func getSystemTheme(Key: String) -> Bool {
        return object(forKey: Key) as? Bool ?? false
    }    
}
