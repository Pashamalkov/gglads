//
//  ResponseCollectionSerializable.swift
//  gglads
//
//  Created by Паша on 06.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import Foundation
import Alamofire



public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}

extension DataRequest {
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                if let
                    response = response,
                    let responseObject = T(response: response, representation: value as AnyObject)
                {
                    return .success(responseObject)
                } else {
//                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = AFError.responseSerializationFailed(reason: .inputDataNil)//Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .failure(error)
                }
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
