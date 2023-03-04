//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import SwiftyCreatives
import CoreGraphics
import Combine
import SwiftUI

public class TornadoSketch: Sketch, ObservableObject {
    
    public var onCardReset: (() async -> (Any, TornadoImageLoadingType))
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published public var selectedId: Any?
    @Published public var someCardSelected: Bool = false
    
    private var isTap = true
    
    public var oneCycleHeight: Float
    public var oneCycleCardCount: Int
    public var cycleCount: Int
    public var cycleRadius: Float
    public var touchYMultiplier: Float = 0.01
    public var touchXMultiplier: Float = 0.01
    public var cameraDistance: Float = 20
    public var rotationSpeedMultiplier: Float = 1
    var cardHeight: Float {
        oneCycleHeight / Float(oneCycleCardCount)
    }
    var totalCardCount: Int {
        cycleCount * oneCycleCardCount
    }
    var cards: [TornadoCard] = []
    public init(
        oneCycleHeight: Float = 32,
        oneCycleCardCount: Int = 8,
        cycleCount: Int = 3,
        cycleRadius: Float = 7,
        touchYMultiplier: Float = 0.01,
        touchXMultiplier: Float = 0.01,
        cameraDistance: Float = 20,
        rotationSpeedMultiplier: Float = 1,
        cardResetProcess: @escaping () async -> (Any, TornadoImageLoadingType)
    ) {
        self.oneCycleHeight = oneCycleHeight
        self.oneCycleCardCount = oneCycleCardCount
        self.cycleCount = cycleCount
        self.cycleRadius = cycleRadius
        self.touchYMultiplier = touchYMultiplier
        self.touchXMultiplier = touchXMultiplier
        self.cameraDistance = cameraDistance
        self.rotationSpeedMultiplier = rotationSpeedMultiplier
        onCardReset = cardResetProcess
        super.init()
        for i in 0..<oneCycleCardCount * cycleCount {
            let height = Float(i)
            let card = TornadoCard()
            card.height = height
            cards.append(card)
        }
    }
    public func resetAll() {
        let task = Task.detached {
            for c in self.cards {
                await c.reset(resetFunc: self.onCardReset)
            }
        }
        cancellables.insert(.init { task.cancel() })
    }
    public override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, 0, -cameraDistance)
    }
    public override func update(camera: some MainCameraBase) {
        if someCardSelected { return }
        for c in cards {
            c.height -= deltaTime * rotationSpeedMultiplier
        }
    }
    public override func draw(encoder: SCEncoder) {
        translate(0, -Float(cycleCount) * oneCycleHeight / 2, 0)
        for c in cards {
            pushMatrix()
            let cosValue = (c.height * cardHeight / oneCycleHeight).truncatingRemainder(dividingBy: oneCycleHeight) * Float.pi * 2
            rotateY(cosValue)
            rotateY(Float.pi)
            translate(0, c.height * cardHeight, cycleRadius)
            c.draw(p: packet)
            popMatrix()
        }
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {
        if someCardSelected { return }
        isTap = false
        let touch = touches.first!
        let delta = touch.location(in: view) - touch.previousLocation(in: view)
        for c in cards {
            var deltaValue = -Float(delta.y) * touchYMultiplier
            deltaValue += Float(delta.x) * touchXMultiplier
            c.update(deltaHeight: deltaValue)
            if c.height < -1 {
                c.height += Float(totalCardCount)
                let task = Task.detached {
                    await c.reset(resetFunc: self.onCardReset)
                }
                cancellables.insert(.init { task.cancel() })
            }
            if c.height > Float(totalCardCount+1) {
                c.height -= Float(totalCardCount)
                let task = Task.detached {
                    await c.reset(resetFunc: self.onCardReset)
                }
                cancellables.insert(.init { task.cancel() })
            }
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {
        if someCardSelected { return }
        let touch = touches.first!
        let pos = touch.location(in: view)
        let ray = camera.screenToWorldDirection(
            screenPos: f2(Float(pos.x), Float(pos.y)),
            viewSize: f2(Float(view.frame.width), Float(view.frame.height))
        )
        if isTap {
            for c in cards {
                if let _ = c.img.hitTestGetPos(origin: ray.origin, direction: ray.direction, testDistance: cameraDistance) {
                    selectedId = c.id
                    someCardSelected = true
                }
            }
        }
        isTap = true
    }
}
