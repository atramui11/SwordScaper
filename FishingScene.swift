import SpriteKit
import Foundation

class FishingScene: GameScene
{
    override func didMove(to view: SKView)
    {
        initFunctions(tileName: "darkTile")
        makeGoldCountBar()
        //spawn 10 animated water patches which are clickable
        spawnObject("fishingSpot", 10, fishingNode)
    
        
    }
    
    
    //TOUCHESENDED (use this one, triggered when you lift up finger)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //i.e. if there is a touch
        if let touch = touches.first
        {
            //let stationaryTouchLocation = touch.location(in: stationaryNode)
            
            respondToTouch(touch: touch)
            //mineRock(touch: touch)
        }
        
        
    }
    
    
    
    
    //update run every 1ms or sth
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
}
