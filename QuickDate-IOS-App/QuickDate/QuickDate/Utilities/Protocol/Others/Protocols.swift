

import Foundation
import UIKit

protocol didUpdateSettingsDelegate {
    func updateSettings(searchEngine:Int, randomUser:Int, matchProfile:Int, confirmFollower: Int, switch: CustomSwitch)
}
protocol didUpdateOnlineStatusDelegate {
    func updateOnlineStatus(status:Int, switch:CustomSwitch)
}

protocol didSelectCountryDelegate {
    func selectCountry(status:Bool,countryString:String)
}


protocol didSelectPaymentDelegate {
    func selectPayment(status:Bool,type:String,Index:Int,PaypalCredit:Int?)
}

protocol UserOptionPopupDelegate {
    func shareBtn(_ sender: UIButton)
    func reportBtn(_ sender: UIButton)
    func blockBtn(_ sender: UIButton)
}

protocol WithdrawalMethodPopupDelegate {
    func selectedMethod(_ selected: String)
}

protocol TwoFactorTypePopupDelegate {
    func selectedType(_ selected: String)
}

protocol ReceiveCallDelegate {
    func receiveCall(status:Bool,profileImage:String,CallId:Int,AccessToken:String,RoomId:String,username:String,isVoice:Bool)
}
protocol selectGenderDelegate {
    func selectGender(type:String, TypeID:[String:String]?,status:Bool?)
}

protocol callReceivedDelegate {
    func callReceived()
}
protocol getAddressDelegate {
    func getAddress(address: String)
}
