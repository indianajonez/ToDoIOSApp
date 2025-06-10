//
//  Style.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation
import UIKit

enum AppFont {
    static let taskTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let title = UIFont.systemFont(ofSize: 17, weight: .medium)
    static let body = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let date = UIFont.systemFont(ofSize: 12, weight: .regular)
}

enum AppColor {
    static let textActive = UIColor(hex: "#F4F4F4")
    static let textCompleted = UIColor(hex: "#F4F4F4", alpha: 0.5)
    static let checkboxYellow = UIColor(hex: "#FED702")
}
