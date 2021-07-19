//
//  HealthBar.swift
//  SwordScape

import Foundation
import SpriteKit

class HealthBar: SKSpriteNode {
	
	private var healthBar: SKSpriteNode!
	private var barLeft: SKSpriteNode!
	private var barRight: SKSpriteNode!
	let numberTileTexture = SKTexture(imageNamed: "scrabbleTile.png")
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(texture: SKTexture?, health: Int, size :CGSize, position: CGPoint) {
		
		super.init(texture: texture, color: UIColor.clear, size: size)

		
		healthBar = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		healthBar.size = size
		healthBar.position = position
		healthBar.zPosition = 0
		
		
		let barHeight = healthBar.size.height*9/10
		let barLeftWidth = healthBar.size.width*19/20
		barLeft = SKSpriteNode(texture: numberTileTexture)
		barLeft.size = CGSize(width: barLeftWidth, height:  barHeight)
		let xPos = -size.width*9.5/20
		barLeft.position = CGPoint(x: xPos, y: 0)
		barLeft.anchorPoint = CGPoint(x: 0, y: 0.5)
		barLeft.zPosition = 1
		healthBar.addChild(barLeft)
		
		barLeft.run(colorize(number: 8))
		
		barRight = SKSpriteNode(texture: numberTileTexture)
		barRight.size = CGSize(width: 0, height: barHeight)
		barRight.position = CGPoint(x: size.width/2, y: 0)
		barRight.anchorPoint = CGPoint(x: 1, y: 0.5)
		barRight.zPosition = 1
		healthBar.addChild(barRight)
		
		barRight.run(colorize(number: 7))
		
	}
	
	
	func colorize(number: Int)->SKAction{
		var colorize: SKAction!
		if number == 7 {
			colorize = SKAction.colorize(with: UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 8 {
			colorize = SKAction.colorize(with: UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		}
		return colorize
	}
}
