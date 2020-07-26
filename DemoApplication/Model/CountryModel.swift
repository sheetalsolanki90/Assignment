//
//  CountryModel.swift
//  DemoApplication
//
//  Created by Sheetal on 18/07/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit

import Foundation

struct CountryProperties : Codable {
    let title : String?
    let description : String?
    let imageHref : String?
}
// MARK: Convenience initializers
extension CountryProperties {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CountryProperties.self, from: data) else { return nil }
        self = me
    }
}
