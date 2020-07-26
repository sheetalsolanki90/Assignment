//
//  CountryViewModel.swift
//  DemoApplication
//
//  Created by Sheetal on 20/07/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
import RxSwift
class CountryViewModel: NSObject {
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    public let countryRowList : PublishSubject<[CountryProperties]> = PublishSubject()
    public var countryTitle : PublishSubject<String> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    private let disposable = DisposeBag()
    public func requestData(){
        self.loading.onNext(true)
        APIManager.requestData(url: "s/2iodh4vg0eortkl/facts.json", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                self.countryTitle.onNext(returnJson["title"].stringValue)
                let countryRows = returnJson["rows"].arrayValue.compactMap {return CountryProperties(data: try! $0.rawData())}
                self.countryRowList.onNext(countryRows)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })

    }

}
