//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import CoreGraphics
import Foundation

public enum TornadoImageLoadingType {
    case cgImage(CGImage)
    case url(URL)
    case name(String)
}
