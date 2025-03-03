
import Foundation
import UIKit
import QuickDateSDK
import AVKit
import Contacts
import Async

class AppInstance {
    
    // MARK: - Properties
    static let shared = AppInstance()
    
    // MARK: User Settings
    var userId: Int?
    var accessToken: String?
    
//    var adminSettings: GetSettingsModel.DataClass?
    var adminAllSettings: GetSettingsModel.GetSettingsSuccessModel?
    var adminSettings: AdminAppSettings?
    var userProfileSettings: UserProfileSettings?
    var contacts = [FetchedContact]()
    var trendingFilters: TrendingFilter = TrendingFilter()
    
    var addCount: Int = 0
    var location: String?
    var gender: String?
    var ageMin: Int?
    var ageMax: Int?
    var body: Int?
    var fromHeight: Int?
    var toHeight: Int?
    var language: Int?
    var religion: Int?
    var ethnicity: Int?
    var relationship: Int?
    var smoke: Int?
    var drink: Int?
    var interest: String?
    var education: Int?
    var pets: Int?
    var distance: Int?
    var isOnline: Bool?
    
    // MARK: - Initialiser
    
    private init() {}
    
    func isConnectedToNetwork(in view: UIView?) -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            view?.makeToast(InterNetError); return false
        }
        return true
    }
    
    func fetchContacts() {
        print("Attempting to fetch contacts")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                print("access granted")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                Async.main {
                    do {
                        try store.enumerateContacts(with: request) { (contact, stopPointer) in
                            print(contact.givenName)
                            Async.main {
                                self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                            }
                        }
                    } catch let error {
                        print("Failed to enumerate contact", error)
                    }
                }
            } else {
                print("access denied")
            }
        }
    }
}
