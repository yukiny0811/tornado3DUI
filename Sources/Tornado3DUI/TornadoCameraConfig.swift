//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import SwiftyCreatives

class TornadoCameraConfig: CameraConfigBase {
    static var fov: Float = 85
    static var near: Float = 0.01
    static var far: Float = 100
    static var easyCameraType: SwiftyCreatives.EasyCameraType = .manual
    static var isPerspective: Bool = true
}
