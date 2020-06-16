//
//  UIView+Extension.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
