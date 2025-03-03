//
//  PhoneNumberVerificationVC.swift
//  QuickDate
//
//  Created by iMac on 09/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import Alamofire

protocol PhoneNumberVerificationDelegate {
    func continueBtnAction(_ sender: UIButton)
}

class PhoneNumberVerificationVC: BaseViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    var delegate: PhoneNumberVerificationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoImage.addShadow()
        self.btnContinue.addShadow(offset: .init(width: 0, height: 2), radius: 4, opacity: 0.5)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if phoneTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.makeToast("Please enter phone number!....")
            return
        }
        sendSMS()
    }
    
    @IBAction func noOtherTimeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
}

//MARK: - API Services -
extension PhoneNumberVerificationVC {
    private func updateProfile() {
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let phone = self.phoneTF.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.phone_number: phone
                //                API.PARAMS: phone
                //                API.PARAMS.phone_number: phone
            ] as [String : Any]
            
            print(params)
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    func sendSMS() {
        print("Starting...")
        self.showProgressDialog(with: "Loading...")
        let twilioSID = AppInstance.shared.adminAllSettings?.data?.smsTwilioUsername ?? ""//"ACf67f6a6b76e22ace72699dbdc36e1783"
        let twilioSecret = AppInstance.shared.adminAllSettings?.data?.smsTwilioPassword ?? ""//"0734c0c6ab41aa3b7a630e264d55b0bb"
        //Note replace + = %2B , for To and From phone number
        let fromNumber = AppInstance.shared.adminAllSettings?.data?.smsTPhoneNumber ?? ""//"+18572148349"// actual number is +9999999
        let toNumber = "+91"+"\(phoneTF.text ?? "")"// actual number is +9999999
        let message = "Your verification code is \(AppInstance.shared.userProfileSettings?.smscode ?? "")."
        
        if let url = URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages") {
            // Build the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: .utf8)
            
            // Build the completion block and send the request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                print("Finished")
                Async.main {
                    if let data = data, let responseDetails = String(data: data, encoding: .utf8) {
                        // Success
                        print("Response: \(responseDetails)")
                        let xmlStr = responseDetails
                        let parser = ParseXMLData(xml: xmlStr)
                        let jsonStr = parser.parseXML().data(using: .utf8)
                        let result = try! JSONDecoder().decode(TwilioResponseModel.self, from: jsonStr!)
                        if result.twilioResponse?.restException?.status == "200" {
                            self.dismissProgressDialog {
                                self.dismiss(animated: true) {
                                    self.delegate?.continueBtnAction(self.btnContinue)
                                }
                            }
                        }else {
                            self.dismissProgressDialog {
                                self.view.makeToast(result.twilioResponse?.restException?.message)
                            }
                        }
                    } else {
                        // Failure
                        print("Error: \(error)")
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                        }
                    }
                }
            }).resume()
        }
    }
}

func jsonStringToDictionary(jsonString: String) -> [String: Any]? {
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error converting JSON string to dictionary: \(error)")
        }
    }
    return nil
}

class ParseXMLData: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    var elementArr = [String]()
    var arrayElementArr = [String]()
    var str = "{"
    
    init(xml: String) {
        parser = XMLParser(data: xml.replaceAnd().replaceAposWithApos().data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> String {
        parser.parse()
        
        // Do all below steps serially otherwise it may lead to wrong result
        for i in self.elementArr{
            if str.contains("\(i)@},\"\(i)\":"){
                if !self.arrayElementArr.contains(i){
                    self.arrayElementArr.append(i)
                }
            }
            str = str.replacingOccurrences(of: "\(i)@},\"\(i)\":", with: "},") //"\(element)@},\"\(element)\":"
        }
        
        for i in self.arrayElementArr{
            str = str.replacingOccurrences(of: "\"\(i)\":", with: "\"\(i)\":[") //"\"\(arrayElement)\":}"
        }
        
        for i in self.arrayElementArr{
            str = str.replacingOccurrences(of: "\(i)@}", with: "\(i)@}]") //"\(arrayElement)@}"
        }
        
        for i in self.elementArr{
            str = str.replacingOccurrences(of: "\(i)@", with: "") //"\(element)@"
        }
        
        // For most complex xml (You can ommit this step for simple xml data)
        self.str = self.str.removeNewLine()
        self.str = self.str.replacingOccurrences(of: ":[\\s]?\"[\\s]+?\"#", with: ":{", options: .regularExpression, range: nil)
        
        return self.str.replacingOccurrences(of: "\\", with: "").appending("}")
    }
    
    // MARK: XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        //print("\n Start elementName: ",elementName)
        
        if !self.elementArr.contains(elementName){
            self.elementArr.append(elementName)
        }
        
        if self.str.last == "\""{
            self.str = "\(self.str),"
        }
        
        if self.str.last == "}"{
            self.str = "\(self.str),"
        }
        
        self.str = "\(self.str)\"\(elementName)\":{"
        
        var attributeCount = attributeDict.count
        for (k,v) in attributeDict{
            //print("key: ",k,"value: ",v)
            attributeCount = attributeCount - 1
            let comma = attributeCount > 0 ? "," : ""
            self.str = "\(self.str)\"_\(k)\":\"\(v)\"\(comma)" // add _ for key to differentiate with attribute key type
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.str.last == "{"{
            self.str.removeLast()
            self.str = "\(self.str)\"\(string)\"#" // insert pattern # to detect found characters added
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print("\n End elementName \n",elementName)
        if self.str.last == "#"{ // Detect pattern #
            self.str.removeLast()
        }else{
            self.str = "\(self.str)\(elementName)@}"
        }
    }
}

extension String{
    // remove amp; from string
    func removeAMPSemicolon() -> String{
        return replacingOccurrences(of: "amp;", with: "")
    }
    
    // replace "&" with "And" from string
    func replaceAnd() -> String{
        return replacingOccurrences(of: "&", with: "And")
    }
    
    // replace "\n" with "" from string
    func removeNewLine() -> String{
        return replacingOccurrences(of: "\n", with: "")
    }
    
    func replaceAposWithApos() -> String{
        return replacingOccurrences(of: "Andapos;", with: "'")
    }
}


struct TwilioResponseModel : Codable {
    let twilioResponse : TwilioResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case twilioResponse = "TwilioResponse"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        twilioResponse = try values.decodeIfPresent(TwilioResponse.self, forKey: .twilioResponse)
    }
}

struct TwilioResponse : Codable {
    let restException : RestException?
    
    enum CodingKeys: String, CodingKey {
        case restException = "RestException"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        restException = try values.decodeIfPresent(RestException.self, forKey: .restException)
    }
}

struct RestException : Codable {
    let code : String?
    let message : String?
    let moreInfo : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "Code"
        case message = "Message"
        case moreInfo = "MoreInfo"
        case status = "Status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        moreInfo = try values.decodeIfPresent(String.self, forKey: .moreInfo)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}
