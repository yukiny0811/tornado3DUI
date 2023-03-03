//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import SwiftyCreatives
import CoreGraphics

class TornadoCard {
    var height: Float = 0
    let img = HitTestableImg()
    var id: Any?
    func reset(resetFunc: () -> (Any, CGImage)) async {
        let (idRaw, im) = resetFunc()
        id = idRaw
        img.load(image: im)
            .adjustScale(with: .basedOnWidth)
            .multiplyScale(3)
    }
    func update(deltaHeight: Float) {
        height += deltaHeight
    }
    func draw(p: SCPacket) {
        img.drawWithCache(packet: p)
    }
}
