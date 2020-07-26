//
//  MyCellViewModel.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/24/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MyCellViewModelType {
    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var imageUrl : Driver<String> { get }
}
class MyCellViewModel: MyCellViewModelType {
    var title: Driver<String>
    var description: Driver<String>
    var imageUrl: Driver<String>
    init(model: CountryProperties) {
        self.title = Driver.just(model.title ?? "")
        self.description = Driver.just(model.description ?? "")
        self.imageUrl = Driver.just(model.imageHref ?? "")
    }

}



