//
//  GameScene.swift
//  SwordScape

import SpriteKit
import GameplayKit
import Darwin

class GameScene: SKScene {

    //boss and link
	var pointer: SKSpriteNode!
	
	var link: Character!
    var boss: Character!
	
	var tileNode: SKSpriteNode?

	var selfNode = SKNode()
	var screenWidth: CGFloat!
	var screenHeight: CGFloat!
	var background: SKSpriteNode!
	
	var numberTile: SKSpriteNode!
	var clickableTileOutline: SKSpriteNode!
	let numberTileTexture = SKTexture(imageNamed: "scrabbleTile.png")
	var distanceBetweenTiles: CGFloat!
	var healthBarLink: SKSpriteNode!
	var healthBarBoss: SKSpriteNode!
	var sword: SKSpriteNode!

	var barLeft: SKSpriteNode!
	var barRight: SKSpriteNode!
	
	var scale1:CGFloat = 38/45
	var scale2:CGFloat = 43/45
	var scale3:CGFloat = 46/45
    var scale4:CGFloat = 83/45
    var scale5:CGFloat = 90/45
	var scale6:CGFloat = 111/45
	var iconScale1:CGFloat = 1
	var iconScale2:CGFloat = 4/3
	var iconScale: CGFloat = 1
	var scale: CGFloat!
	var columnNumber = 7
	var rowNumber = 7
	var aspectRatio: CGFloat = 9/16
	var reverseRatio: CGFloat = 16/9
	var timer:Timer!
	var bossIsBoucing:Bool = false
	
	var bounceSpeed:CGFloat = 1000
	
	var linkAttackTurn = false
	var monsterAttackTurn = false
	var linkAttacking = false
	var bossAttacking = false
	var linkAttackSpeed:TimeInterval = 1
	var bossAttackSpeed:TimeInterval = 2
	
	var hitBox: SKSpriteNode!
	var hitLabel: SKLabelNode!
	var flagLink = false
	var flagBoss = false
	
	override func didMove(to view: SKView) {
		
		setUpScaleAndNodes()
		createTiles()
		initializeGame()

    }
	
	
	
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			//let location = touch.location(in: selfNode)
			//pointer.position = location
		}
    }
	
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
	
	
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: selfNode)
			if boss != nil && boss.contains(location) {
				animatePointer (location: location, type: "red")
			} else {
				animatePointer (location: location, type: "grey")

			}
			moveAndOrientCharacter(location: location)
		}
    }
	
	
    override func update(_ currentTime: TimeInterval) {
		updateBossPos(speed: 200)
		moveOutOfWay()
		if flagBoss {
			self.flagBoss = false
			self.boss.removeAllActions()
			self.link.removeAllActions()
			self.boss.removeFromParent()
			self.boss = nil

			self.healthBarBoss.removeFromParent()

		} else if flagLink {
			self.flagLink = false
			self.link.removeAllActions()
			self.boss.removeAllActions()
			self.link.removeFromParent()
			self.link = nil
			self.healthBarLink.removeFromParent()
		}
	}
}
