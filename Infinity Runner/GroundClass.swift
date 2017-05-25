//
//  GroundClass.swift
//  Infinity Runner
//
//  Created by UDLAP on 4/25/17.
//  Copyright © 2017 UDLAP. All rights reserved.
//

import Foundation
import SpriteKit

class GroundClass: SKSpriteNode
{
    func initializeGroundAndFloor()
    {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height-200)) // hacemos su mascara de colision un poco mas pequeña
        physicsBody?.affectedByGravity = false // le quitamos la gravedad para que no caigan
        physicsBody?.isDynamic = false // no son dinamicos ( no pueden ser afectados por la masa o peso del player)
        physicsBody?.categoryBitMask = ColliderType.GROUND
    }
    
    // hace lo mismo que BGClass , pero para el piso y techo
    func moveGoundOrFloors(camera: SKCameraNode)
    {
        if self.position.x + self.size.width < camera.position.x {
            self.position.x += self.size.width * 3
        }
    }
}
