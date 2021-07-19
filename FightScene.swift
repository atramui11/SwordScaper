//
//  GameScene.swift
//  SwordScape
//

import SpriteKit
import GameplayKit
import Darwin


class FightScene: GameScene {
	
	override func didMove(to view: SKView) {
		initFunctions(tileName: "darkTile")
		//makeGoldCountBar()
		//spawn gold rocks in 10 random locations
		spawnObject("gold_rock", 5, rocksNode)
		spawnObject("tree", 5, woodCuttingNode)
		spawnObject("fishingSpot", 5, fishingNode)


	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			
			
			
			dropItem(touch: touch)
			withdrawFromBank(touch: touch)
			respondToTouch(touch: touch)
			pickupItem(touch: touch)
			
			
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		for monster in monsterNode.children as! [Character] {
			updateBossPos(monsterName: monster.name!, speed: 200)
		}
		moveOutOfWay()
		handleCharacterDeath()
	}
}
