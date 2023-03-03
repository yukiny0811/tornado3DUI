//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import SwiftyCreatives

public class TornadoCameraConfig: CameraConfigBase {
    public static var fov: Float = 85
    public static var near: Float = 0.01
    public static var far: Float = 100
    public static var easyCameraType: SwiftyCreatives.EasyCameraType = .manual
    public static var isPerspective: Bool = true
}
