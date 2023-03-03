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
    func reset(resetFunc: () -> (Any, TornadoImageLoadingType)) async {
        let (idRaw, type) = resetFunc()
        id = idRaw
        switch type {
        case .cgImage(let cgImage):
            img.load(image: cgImage)
        case .url(let url):
            await img.load(url: url)
        case .name(let name):
            await img.load(name: name, bundle: .main)
        }
        img.adjustScale(with: .basedOnWidth).multiplyScale(3)
    }
    func update(deltaHeight: Float) {
        height += deltaHeight
    }
    func draw(p: SCPacket) {
        img.drawWithCache(packet: p)
    }
}
