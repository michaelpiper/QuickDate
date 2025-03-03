

import Foundation
import Alamofire
import QuickDateSDK

class BankTransferManager {
    static let instance = BankTransferManager()
    func sendMedia(AccessToken: String, transferMode:String, price:Int, description:String, MediaData:Data?, completionBlock: @escaping (_ Success:UploadBankReceiptModel.UploadBankReceiptSuccessModel?,_ sessionError:UploadBankReceiptModel.UploadBankReceiptErrorModel?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token:AccessToken,
            API.PARAMS.price: price,
            API.PARAMS.description: description,
            API.PARAMS.transfer_mode: transferMode
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let avatarData = MediaData {
                multipartFormData.append(avatarData, withName: "receipt", fileName: "m.jpg", mimeType: "image/png")
            }
            
        }, to: API.COMMON_CONSTANT_METHODS.BANK_TRANSFER_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            print("Succesfully uploaded")
            Logger.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                Logger.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = UploadBankReceiptModel.UploadBankReceiptSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = UploadBankReceiptModel.UploadBankReceiptErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
