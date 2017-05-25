//
//  GameplayScene.swift
//  Infinity Runner
//
//  Created by UDLAP on 4/24/17.
//  Copyright © 2017 UDLAP. All rights reserved.
//

import Foundation
import SpriteKit

class GameplayScene : SKScene, SKPhysicsContactDelegate
{
    
    //indicar en el custom clas de las 3 (gamplayScene.sks), BGClass y en su Module, Infinity Runner
    private var bg1: BGClass?
    private var bg2: BGClass?
    private var bg3: BGClass?
    
    private var ground1: GroundClass?
    private var ground2: GroundClass?
    private var ground3: GroundClass?
    
    private var floor1: GroundClass?
    private var floor2: GroundClass?
    private var floor3: GroundClass?
    
    private var player: Player?

    private var mainCamera: SKCameraNode?
    
    private var scoreLabel: SKLabelNode?
    private var score = 0

    private var itemController = ItemController()
    
    override func didMove(to view: SKView) {
        
        initializeGame();

    }
    
    override func update(_ currentTime: TimeInterval)// funcion que checa constantemente el juego
    {
        manageCamera()
        manageBGsAndGrounds()
        player?.move()
        moveRocket()
        playerFalled()
    }
    // checa si se tocó la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reverseGravity() //invierte la gravedad del jugador
    }
    
    // checa si hubo contacto entre dos objetos e identifica sus parametros
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        // si el objetoA es el Player ...
        if contact.bodyA.node?.name == "Player"
        {
            firstBody = contact.bodyA // lo asignamos a firstBody
            secondBody = contact.bodyB
        }
        // sino, es el objeto B
        else
        {
        
            firstBody = contact.bodyB // lo asignamos a firstBody
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Coin" // si colisiona con la moneda..
        {
            score += 1 // incrementa el score
            scoreLabel?.text = String(score) // actualiza el label del score
            secondBody.node?.removeFromParent() // quita la moneda
        }
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Rocket" // si colisiona con el Rocket
        {
            firstBody.node?.removeFromParent() // quita el Player
            secondBody.node?.removeFromParent() // quita el Rocket
            
            // reinicia el juego en 2 segundos
        Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.restartGame), userInfo: nil, repeats: false)
            

            
        }
            
    }
    
    private func initializeGame()
    {
        physicsWorld.contactDelegate = self
        
        mainCamera = childNode(withName: "MainCamera")as? SKCameraNode!
        
        // inicializadores
        bg1 = childNode(withName: "BG1")as? BGClass!
        bg2 = childNode(withName: "BG2")as? BGClass!
        bg3 = childNode(withName: "BG3")as? BGClass!
        
        ground1 = childNode(withName: "Ground1")as? GroundClass!
        ground2 = childNode(withName: "Ground2")as? GroundClass!
        ground3 = childNode(withName: "Ground3")as? GroundClass!
        
        
        ground1?.initializeGroundAndFloor()
        ground2?.initializeGroundAndFloor()
        ground3?.initializeGroundAndFloor()
        
        floor1 = childNode(withName: "Floor1")as? GroundClass!
        floor2 = childNode(withName: "Floor2")as? GroundClass!
        floor3 = childNode(withName: "Floor3")as? GroundClass!
        
        floor1?.initializeGroundAndFloor()
        floor2?.initializeGroundAndFloor()
        floor3?.initializeGroundAndFloor()
        
        player = childNode(withName: "Player")as? Player!
        player?.initializePlayer()
        
        // hace que el label se mueva a la misma velocidad que la camara
        scoreLabel = mainCamera!.childNode(withName: "ScoreLabel")as? SKLabelNode!
        scoreLabel?.text = "0"
        
        // le pone un timer al metodo SpawnItems y hace que se repita
        Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 1, secondNum: 3)), target: self, selector: #selector(GameplayScene.spawnItems), userInfo: nil, repeats: true)
        // le pone un timer al metodo removeItems
        Timer.scheduledTimer(timeInterval: TimeInterval(7), target: self, selector: #selector(GameplayScene.removeItems), userInfo: nil, repeats: true)
        
       // Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerFalled), userInfo: nil, repeats: true)
        
        
    }
    
    // hace que la camara se mueva a cierta velocidad en el eje x
    private func manageCamera()
    {
        self.mainCamera?.position.x += 10;
    }
    

    
    private func manageBGsAndGrounds()
    {
        //inicializadores
        bg1?.moveBG(camera: mainCamera!)
        bg2?.moveBG(camera: mainCamera!)
        bg3?.moveBG(camera: mainCamera!)
        
        ground1?.moveGoundOrFloors(camera: mainCamera!)
        ground2?.moveGoundOrFloors(camera: mainCamera!)
        ground3?.moveGoundOrFloors(camera: mainCamera!)
        
        floor1?.moveGoundOrFloors(camera: mainCamera!)
        floor2?.moveGoundOrFloors(camera: mainCamera!)
        floor3?.moveGoundOrFloors(camera: mainCamera!)
    }
    private func reverseGravity()// cambia la gravedad a negativo o positivo  y la animacion del jugador
    {
        physicsWorld.gravity.dy *= -1
        player?.reversePlayer()
    }
    
    func spawnItems() // llama a la funcion que spawnea los items
    {
        self.scene?.addChild(itemController.spawnItems(camera: mainCamera!))
    }
    
    func restartGame() // reinicia el juego (copy paste del GameViewController y algunas modificaciones)
    {
        if let scene = GameplayScene(fileNamed: "GameplayScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view!.presentScene(scene, transition: SKTransition.doorsOpenVertical(withDuration: TimeInterval(1)))
            
        }

    }
    private func moveRocket() // mueve los Rockets
    {
        enumerateChildNodes(withName: "Rocket", using: ({
            (node,error) in
            node.position.x -= 5
        }))
    }
    
    func removeItems() // cuando los objetos salen del mapa los destruye
    {
        for child in children
        {
            if child.name == "Coin" || child.name == "Rocket"
            {
                if child.position.x < self.mainCamera!.position.x - self.scene!.frame.width / 2
                {
                    child.removeFromParent()
                }
            }
        }
    }
    
    
    func playerFalled() // detecta si el jugador se cayó , y reinicia el juego si es el caso
    {
        for child in children
        {
            if child.name == "Player"
            {
                if child.position.y < self.mainCamera!.position.y - self.scene!.frame.height / 2
                {
                    restartGame()
                }
            }
        }
    }
 
    
}











