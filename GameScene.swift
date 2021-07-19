//  GameScene.swift
//  SwordScape

import SpriteKit
import GameplayKit
import Darwin

class GameScene: SKScene {
	
	
	//gold count bar variables
	var goldCount:Int = 0 //gold coins
	var goldCountBar:SKSpriteNode? //bar to show gold coins
	var goldCountLabel:SKLabelNode?
	var rocksNode = SKNode()
	
	//woodCutting count bar variables
	var woodCount:Int = 0 //lumber
	var woodCuttingNode = SKNode()
	
	
	// important Nodes
	var tileNode: SKSpriteNode?
	var selfNode: SKSpriteNode!
	var background: SKSpriteNode!
	var pointer: SKSpriteNode!
	var elseNode: SKSpriteNode!
	var stationaryNode: SKSpriteNode!
	var movingNode: SKSpriteNode!
	var resource: Resource!
	var resourceType: String!
	
	var monsterNode = SKNode()
	var healthBarMovingNode = SKNode()
	var fishingNode = SKNode()
	var coinsNode = SKNode()
	var bankNode = SKNode()
	
	// values
	var screenWidth: CGFloat!, screenHeight: CGFloat!
	var scale1:CGFloat = 38/45, scale2:CGFloat = 43/45, scale3:CGFloat = 46/45, scale4:CGFloat = 83/45, scale5:CGFloat = 90/45, scale6:CGFloat = 111/45
	var iconScale1:CGFloat = 1, iconScale2:CGFloat = 4/3, iconScale: CGFloat = 1
	var scale: CGFloat!
	var columnNumber = 15, rowNumber = 15
	var aspectRatio: CGFloat = 9/16, reverseRatio: CGFloat = 16/9
	var bounceSpeed:CGFloat = 1000
	var linkAttackSpeed:TimeInterval = 0.7, bossAttackSpeed:TimeInterval = 2
	var distanceBetweenTiles: CGFloat!
	var linkToBossDist: CGFloat!
	
	// bools
	//var bossIsBoucing:Bool = false
	var linkAttackTurn = false, monsterAttackTurn = false
	//var linkAttacking = false, bossAttacking = false
	//var flagLink = false, flagBoss = false
	var stabOn = false, slashOn = true, blockOn = false
	var meleeOn = true, rangedOn = false, magicOn = false
	var doubleTouch = false
	var randomWalking = false
	var bankOpen = false

	// timers
	var timer:Timer!, timer2:Timer!, skillingTimer: Timer!
	
	//menu icons
	var inventory: SKSpriteNode!, skills: SKSpriteNode!, combat: SKSpriteNode!
	var invDictionary = [String: String]()
	
	//inventory bitmap
	var inventoryArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	var bankArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	
	// textures
	var backgroundTexture = SKTexture(imageNamed: "backgroundImage")
	
	
}
