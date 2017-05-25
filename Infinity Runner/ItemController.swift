//
//  ItemController.swift
//  Infinity Runner
//
//  Created by UDLAP on 4/25/17.
//  Copyright © 2017 UDLAP. All rights reserved.
//

import Foundation
import SpriteKit

class ItemController
{
    // medidas maximas y minimas en y para saber donde crear(spawnear) los objetos

    private var minY = CGFloat(-265)
    private var maxY = CGFloat(265)
    
    func spawnItems(camera: SKCameraNode) -> SKSpriteNode
    {
        let item: SKSpriteNode?
        if Int(randomBetweenNumbers(firstNum: 0, secondNum: 10)) >= 6 //indicamos cada cuanto spawnean
        {
            item = SKSpriteNode(imageNamed: "Rocket")
            item?.name = "Rocket"
            item?.setScale(0.07)
            item?.physicsBody = SKPhysicsBody(rectangleOf: item!.size)
        }
        else
        {
            item = SKSpriteNode(imageNamed: "Coin")
            item?.name = "Coin"
            item?.setScale(0.1)
            item?.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
        }
        
        item!.physicsBody?.affectedByGravity = false // les quitamos la gravedad
        item?.physicsBody?.categoryBitMask = ColliderType.ROCKET_AND_COLLECTABLES
        
        item?.zPosition = 4 //profundidad para el renderizado
        item?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        item?.position.x = camera.position.x+900 //van a aparecer 900 puntos antes de donde inicia la camara
        item?.position.y = randomBetweenNumbers(firstNum: minY, secondNum: maxY)// aparecen aleatoriamente entre lo que mide la camara (poco menos) para que no aparezcan fuera de ella
        
        return item!
    }
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum,secondNum)
        
    }
}
