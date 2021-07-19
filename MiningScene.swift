import SpriteKit
import Foundation

class MiningScene: GameScene
{
	override func didMove(to view: SKView)
	{
		initFunctions(tileName: "darktile")
		makeGoldCountBar()
		//spawn gold rocks in 10 random locations
		spawnObject("gold_rock", 10, rocksNode)
	}
	
	
	//TOUCHESENDED (use this one, triggered when you lift up finger)
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		//i.e. if there is a touch
		if let touch = touches.first
		{
			
			respondToTouch(touch: touch)
			//mineRock(touch: touch)
		}
		
		
	}
	
	
	
	
	//update run every 1ms or sth
	override func update(_ currentTime: TimeInterval)
	{
		
	}
	
}
