//
//  Player.swift
//  Infinity Runner
//
//  Created by UDLAP on 4/25/17.
//  Copyright © 2017 UDLAP. All rights reserved.
//

import Foundation
import SpriteKit

//Crear los objectos colisionables
struct ColliderType {
    static let PLAYER: UInt32 = 0
    static let GROUND: UInt32 = 1
    static let ROCKET_AND_COLLECTABLES: UInt32 = 2

}

class Player : SKSpriteNode
{
    
    private var textureAtlas = SKTextureAtlas()
    private var playerAnimation = [SKTexture]()
    private var animatePlayerAction = SKAction()
    
    func initializePlayer()
    {
        name = "Player"
        
        for i in 1...3 // ciclo para ir cambiando la animacion del jugador
        {
            let name = "Player\(i)"
            playerAnimation.append(SKTexture(imageNamed: name))
            
        }
        animatePlayerAction = SKAction.animate(with: playerAnimation, timePerFrame: 0.08, resize: true, restore: false) // con que se anima, cada cuanto , del mismo tamaño
        
        self.run(SKAction.repeatForever(animatePlayerAction)) // se debe indicar que se repita siempre
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height)) // su mascara de colision es un rectangulo
        physicsBody?.affectedByGravity = true // si tiene gravedad
        physicsBody?.allowsRotation = false // no puede rotarse al colisionar con otro objeto
        physicsBody?.restitution = 0.1 // rebota muy poco al hacer contacto con otro objeto
        
        physicsBody?.categoryBitMask = ColliderType.PLAYER
        physicsBody?.collisionBitMask = ColliderType.GROUND
        physicsBody?.contactTestBitMask = ColliderType.ROCKET_AND_COLLECTABLES
    }
    func move()
    {
        self.position.x += 10 // velocidad sobre el eje x
        
    }
    func reversePlayer()
    {
        self.yScale *= -1  // voltear la animacion sobre el eje y
        
    }
}





















