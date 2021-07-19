
//  Created by Nikhil Trehan on 8/31/19.
//

import Foundation
import SpriteKit
import GameplayKit
import Darwin


class MinigameScene: GameScene
{
    
    //not sure why this doesn't work ?
    /*
     func spawnCoins()
     {
     var tileCount = 0
     
     for child in (tileNode?.children)! as! [SKSpriteNode]
     {
     tileCount += 1
     
     let coin = SKSpriteNode(texture: SKTexture(imageNamed: "goldCoin"))
     
     child.addChild(coin)
     
     // look at child.position.x and child.position.y
     }
     }
     */
    
    var coinsCollected = false
    
    override func didMove(to view: SKView)
    {
        initFunctions(tileName: "lightTile")
        makeGoldCountBar()
        
        //spawn coins on every tile
        spawnObject("goldCoin", 1, coinsNode)
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first
        {
            dropItem(touch: touch)
            respondToTouch(touch: touch)
            pickupItem(touch: touch)
        }
    }
    
    func checkCoinsCollected()
    {
        if coinsNode.children.count == 0 && !coinsCollected
        {
            coinsCollected = true
            
            let finishedCoinsLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
            stationaryNode.addChild(finishedCoinsLabel)
            finishedCoinsLabel.zPosition = 2
            finishedCoinsLabel.text = "ALL COINS COLLECTED!"
            finishedCoinsLabel.fontSize = 40*scale
            finishedCoinsLabel.fontColor = SKColor.magenta
            finishedCoinsLabel.verticalAlignmentMode = .center
            //goldCountLabel!.horizontalAlignmentMode = .right
            finishedCoinsLabel.position = CGPoint(x: 0, y: 0)
            
            
            let checkInvLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
            stationaryNode.addChild(checkInvLabel)
            checkInvLabel.zPosition = 2
            checkInvLabel.text = "Check inventory..."
            checkInvLabel.fontSize = 40*scale
            checkInvLabel.fontColor = SKColor.magenta
            checkInvLabel.verticalAlignmentMode = .center
            //goldCountLabel!.horizontalAlignmentMode = .right
            checkInvLabel.position = CGPoint(x: 0, y: 0)
            
            
            let fadeIn2 = SKAction.fadeIn(withDuration: 1.5)
            let fadeOut2 = SKAction.fadeOut(withDuration: 1.5)
            let waitAction = SKAction.wait(forDuration: 50)
            
            //need to wait for this action to finish before running next one
            finishedCoinsLabel.run(SKAction.sequence([fadeIn2, fadeOut2,waitAction]))
            
            checkInvLabel.run(SKAction.sequence([fadeIn2, fadeOut2]))
            
            
            //spawn a sword in inv
            //why isn't this adding to inventory ?
            //addToInventory(input: "blueSword")
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for monster in monsterNode.children as! [Character] {
            updateBossPos(monsterName: monster.name!, speed: 200)
        }
        moveOutOfWay()
        handleCharacterDeath()
        checkCoinsCollected()
    }
    
}

