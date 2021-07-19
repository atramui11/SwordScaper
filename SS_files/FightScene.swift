//
//  GameScene.swift
//  SwordScape


import SpriteKit
import GameplayKit
import Darwin

class FightScene: GameScene {
	
	override func didMove(to view: SKView) {
		initFunctions()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: stationaryNode)
			selectAttackStyle(touch: touch, location: location)
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		updateBossPos(speed: 200)
		moveOutOfWay()
		handleCharacterDeath()
	}
}
