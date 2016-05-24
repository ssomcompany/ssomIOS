//
//  SSNetworkAPIClient.swift
//  Ssom
//
//  Created by DongSoo Lee on 2015. 11. 15..
//  Copyright © 2015년 SsomCompany. All rights reserved.
//

import Foundation
import Alamofire

enum SSGender : String {
    case SSGenderMale = "Male"
    case SSGenderFemale = "Female"
}

public class SSNetworkAPIClient {
    class func getPosts(completion: (viewModels: [SSViewModel]?, error: NSError?) -> Void) {
        Alamofire.request(.GET, SSNetworkContext.serverUrlPrefixt+"posts")
        .responseJSON { response in

            if response.result.isSuccess {
                print("Response JSON : \(response.result.value)")

                let rawDatas: Array = response.result.value as! [[String: AnyObject!]]
                var datas: Array = [SSViewModel]()

                for rawData in rawDatas {
                    let viewModel: SSViewModel = SSViewModel.init(modelDict: rawData)

                    datas.append(viewModel)
                }

                completion(viewModels: datas, error: nil)
            } else {
                print("Response Error : \(response.result.error)")

                completion(viewModels: nil, error: response.result.error)
            }
        }
    }

    class func postPost(token: String, model: SSWriteViewModel, completion: (error: NSError?) -> Void) {
        let params: [String: AnyObject] = ["userId": "\(model.userId)",
                                           "content": model.content,
                                           "ssom": model.ssomType.rawValue,
                                           "latitude": "\(model.myLatitude)",
                                           "longitude": "\(model.myLongitude)",
                                           "imageUrl": (model.profilePhotoUrl?.absoluteString)!,
                                           "minAge": model.ageType.rawValue,
                                           "userCount": model.peopleCountType.rawValue]

        Alamofire.request(.POST,
            SSNetworkContext.serverUrlPrefixt+"posts",
            parameters: params,
            encoding: .JSON,
            headers: ["Authorization": "Basic " + token])
            .responseJSON { (response) in

                if response.result.isSuccess {
                    print("postPost result : \(response.result.value)")

                    completion(error: nil)
                } else {
                    completion(error: response.result.error)
                }
            }
    }

    class func getFile(token: String, fileId: String, completion: (error: NSError?) -> Void) {
        let imagePath = fileId

        Alamofire.request(.GET,
                          SSNetworkContext.serverUrlPrefixt+"file/images/\(imagePath)",
                          encoding: .JSON,
                          headers: ["Authorization": "Basic " + token])
        .responseData { (response) in

            if response.result.isSuccess {
                print("getFile result : \(response.result.value)")

                completion(error: nil)
            } else {
                completion(error: response.result.error)
            }
        }

    }

    class func postFile(token: String, fileExt: String, fileName: String, fileData: NSData, completion: (photoURLPath: String?, error: NSError?) -> Void) {
        Alamofire.upload(.POST,
                         SSNetworkContext.serverUrlPrefixt+"file/upload",
                         headers: ["Authorization": "Basic " + token],
                         multipartFormData: { (multipartFormData) in
                            multipartFormData.appendBodyPart(data: fileData, name: "file", fileName: fileName, mimeType: "image/\(fileExt)")
                        },
                         encodingMemoryThreshold: 0,
                         encodingCompletion: { (encodingResult) in
                            switch encodingResult {
                            case .Success(let req, _, _):
                                req.responseJSON(completionHandler: { (response) in

                                    if response.result.isSuccess {
                                        print("postFile result : \(response.result.value)")

                                        let rawData = response.result.value as! NSDictionary
                                        let fileId: String = rawData["fileId"] as! String

                                        completion(photoURLPath: SSNetworkContext.serverUrlPrefixt+"file/images/\(fileId)", error: nil)
                                    } else {
                                        completion(photoURLPath: nil, error: response.result.error)
                                    }
                                })
                            case .Failure(let error):
                                print(error)

//                                completion(error: error)
                            }
        })
    }

    class func postLogin(userId email:String, password:String, completion: (error:NSError?) -> Void ) {
        let plainString = "\(email):\(password)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions([])

        // Basic Auth
        Alamofire.request(.POST,
            SSNetworkContext.serverUrlPrefixt+"login",
            encoding: .JSON,
            headers: ["Authorization": "Basic " + base64String!])
            .responseJSON { response in

                if response.result.isSuccess {
                    print("Response JSON : \(response.result.value)")

                    if let value: [String: AnyObject] = response.result.value as? [String: AnyObject] {
                        let token = value["token"]
                        if token != nil {
                            SSNetworkContext.sharedInstance.saveSharedAttribute(token!, forKey: "token")

                            completion(error: nil)
                        } else {

                            let errorResult = value["error"]
                            if errorResult != nil {
                                let error: NSError = NSError(domain: "com.ssom.error.AuthFailed.Unknown", code: 999, userInfo: nil)

                                completion(error: error)
                            } else {
                                let error: NSError = errorResult as! NSError
                                
                                completion(error: error)
                            }

                        }
                    } else {
                        let error: NSError = NSError(domain: "com.ssom.error.AuthFailed", code: 999, userInfo: nil)

                        completion(error: error)
                    }
                } else {
                    print("Response Error : \(response.result.error)")

                    completion(error: response.result.error!)
                }
        }

    }

    class func postUser(email:String, password:String, nickName:String? = "None", gender:SSGender? = .SSGenderFemale, completion: () -> Void ) {
        Alamofire.request(.POST,
            SSNetworkContext.serverUrlPrefixt + "users",
            parameters: ["email":email, "password":password, "nickName":nickName!, "gender":gender!.rawValue],
            encoding: .JSON)
            .responseJSON { (response) in

                if response.result.isSuccess {
                    print("Response JSON : \(response.result.value)")

                    completion()
                } else {
                    print("Response Error : \(response.result.error)")
                }
        }
    }
}