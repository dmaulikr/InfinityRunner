//
//  BGClass.swift
//  Infinity Runner
//
//  Created by UDLAP on 4/24/17.
//  Copyright © 2017 UDLAP. All rights reserved.
//

import Foundation
import SpriteKit

class BGClass: SKSpriteNode
{
    func moveBG(camera: SKCameraNode)
    {
        if self.position.x + self.size.width < camera.position.x {
            self.position.x += self.size.width * 3 // hace que el BackGround se vuelva a crear cada que sale de la camara , se crea su largo , multiplicado por 3 (ya que tenemos 3 backgrounds en el GamePlayScene.sks)
        }
    }
}
