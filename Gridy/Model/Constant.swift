//
//  Constant.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 11/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

struct Constant {
    struct Font {
        struct Name {
            static let primary = "Helvetica Neue"
            static let secondary = "TimeBurner"
        }
        struct Size {
            static let closeButton: CGFloat = 40
            static let primaryButton: CGFloat = 30
            static let primaryLabel: CGFloat = 18
            static let secondaryButton: CGFloat = 13
        }
    }
    
    struct Layout {
        struct cornerRadius {
            static let buttonRadius: CGFloat = 10
        }
    }
    
    struct Color {
        static let primaryColor = "GrassGreen"
        static let primaryLight = "SmoothBeige"
        static let primaryDark = "DarkGray"
        static let secondaryLight = "SnowWhite"
        static let secondaryDark = "TwilightBlue"
    }
    
    struct Image {
        static let nameSmall = "Gridy-name-small-grey"
        static let camera = "Gridy-camera"
        static let library = "Gridy-library"
    }
}
