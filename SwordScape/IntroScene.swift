import SpriteKit
import GameplayKit
import Darwin
import Foundation
import AVFoundation

class IntroScene: SKScene
{
    /********INSTANCE VARS*********/
    //characters (links & npcs)
    private var link: Character!
    private var bipinNPC : Character!
    
    //sounds
    var player: AVAudioPlayer?
    var portalOpen:Bool!
    private var pointer: SKSpriteNode!  //click ptr var
    private var selfNode = SKNode() //base child node
    private var background: SKSpriteNode!
    
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    
    private var scale1:CGFloat = 38/45
    private var scale2:CGFloat = 43/45
    private var scale3:CGFloat = 46/45
    private var scale4:CGFloat = 83/45
    private var scale5:CGFloat = 90/45
    private var scale6:CGFloat = 111/45
    private var iconScale1:CGFloat = 1
    private var iconScale2:CGFloat = 4/3
    private var iconScale: CGFloat = 1
    private var scale: CGFloat!
    private var columnNumber = 7
    private var rowNumber = 7
    private var aspectRatio: CGFloat = 9/16
    private var reverseRatio: CGFloat = 16/9
    
    //tile variables
    var numberTile: SKSpriteNode!
    var clickableTileOutline: SKSpriteNode!
    let numberTileTexture = SKTexture(imageNamed: "scrabbleTile.png")
    private var distanceBetweenTiles: CGFloat!
    private var tileNode: SKSpriteNode?
    private var moveBlock: SKSpriteNode?
    
    //text box vars
    var textBox:SKSpriteNode!
    var text: SKLabelNode!
    var dialogueArrayCount = 0
    let dialogueArray = ["Good morning!", "Did you sleep well?", "You've been asleep for 10 years!","Want to go forward?", "Well, ok..." ]
    
    var avatarName:String?
    

    
    
    /********END INSTANCE VARS*********/
    
    
    
    //CONSTRUCTOR
    override func didMove(to view: SKView)
    {
        setUpScale()
        //add base child node
        selfNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        selfNode.zPosition = -3
        self.addChild(selfNode)
        
        //build tiles
        tileNode = SKSpriteNode()
        selfNode.addChild(tileNode!)
        
        background = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -2
        selfNode.addChild(background)
        
        createTiles()
        spawnBlock()
        
        //SPAWN link
        let size = CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
        link = Character(texture: SKTexture(imageNamed: "link.png"), size: size, attackSpd: 1)
        createCharacter(charName: "link", name: "linkSword", position: CGPoint(x:0,y:0),sprite: &link)
        
        //SPAWN bipin the NPC
        bipinNPC = Character(texture: SKTexture(imageNamed: "bipin1.png"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
        
        createCharacter(charName: "bipin", name: "bipinNPC",position: CGPoint(x:-distanceBetweenTiles*2,y:distanceBetweenTiles*4),sprite: &bipinNPC)
        let bipinTxtrArray = [SKTexture(imageNamed: "bipin2.png"), SKTexture(imageNamed: "bipin1.png")]
        
        //animate bipin NPC
        let animateBipin = SKAction.animate(with: bipinTxtrArray, timePerFrame: 0.06)
        
        bipinNPC.run(SKAction.repeatForever(animateBipin))
        
        
        //pointer block
        pointer = SKSpriteNode()
        pointer.size = CGSize(width: self.frame.width/10/iconScale, height: self.frame.width/10/iconScale)
        pointer.position = CGPoint(x: 0, y: 0)
        pointer.zPosition = 1
        selfNode.addChild(pointer)
        
        portalOpen = false
    }
    

    func spawnPortal()
    {
        moveBlock = SKSpriteNode(texture: SKTexture(imageNamed: "portal.png"))
        selfNode.addChild(moveBlock!)
        let blockXPos =  distanceBetweenTiles*0
        let blockYPos = distanceBetweenTiles*3
        let moveBlockPosition = CGPoint(x: blockXPos, y: blockYPos)
        
        moveBlock?.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
        
        moveBlock?.position = moveBlockPosition
        moveBlock?.zPosition = 1
        portalOpen = true
    }
    
    func playDoorOpenSound()
    {
        /*
        // Grab the path, make sure to add it to your project!
        let coinSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "enterPortal", ofType: "wav")!)
        var audioPlayer = AVAudioPlayer()
        
        // Initial setup
        do {audioPlayer = try! AVAudioPlayer(contentsOf: coinSound as URL)} catch {}
        audioPlayer.prepareToPlay()
        */
        
        let soundFile = "enterPortal"
        
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "wav") else {
            print("url Not Found")
            return
        }
        selfNode.run(SKAction.playSoundFileNamed(soundFile, waitForCompletion: true))
        

    }
    
    
    
    //TOUCHESENDED (use this one, triggered when you lift up finger)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //if there is a touch
        if let touch = touches.first
        {
            //location is where touch
            let touchLocation = touch.location(in: selfNode)
         
            //Clicked Bipin
            if textBox == nil && bipinNPC != nil && bipinNPC.contains(touchLocation)
            {
                let delayAction = SKAction.wait(forDuration: 1)
                animatePointer (location: touchLocation, type: "red")
                
                if dialogueArrayCount <= 4
                {createTextBox(dialogueArray[dialogueArrayCount])}
                
                if dialogueArrayCount == 4
                {
                    //spawn a block to be pushed
                    spawnBlock()
                }
                
                dialogueArrayCount += 1
                return
            }
                
                
            //Clicked textbox (clear it)
            else if textBox != nil && textBox.contains(touchLocation)
            {
                //fade out textbox
                animatePointer (location: touchLocation, type: "red")
                let fadeOut = SKAction.fadeOut(withDuration: 1)
                textBox.run(fadeOut)
                textBox = nil
                return
            }
                
            
            //Clicked moveBlock
            else if moveBlock != nil && (moveBlock?.contains(touchLocation))!
            {
                animatePointer (location: touchLocation, type: "red")
                //if link is adjacent to block on left side
                let linkBlockXPositionDiff = abs(link.position.x - moveBlock!.position.x)
       
                print(linkBlockXPositionDiff)
                
                if linkBlockXPositionDiff <= 100
                {
                    print("here2")
                    let blockXPos = distanceBetweenTiles*3
                    let blockYPos = distanceBetweenTiles*3
                    let newMoveBlockPosition = CGPoint(x: blockXPos, y: blockYPos)
                    moveBlock?.position = newMoveBlockPosition
                    
                    if !portalOpen {spawnPortal()}
                    
                    //playDoorOpenSound()
                    
                    return
                }
            }
            
                
            else
                {animatePointer (location: touchLocation, type: "grey")}
            
            moveAndOrientCharacter(location: touchLocation)
        }
        
        //click to move forward textbox
        //else if textBox.contains(touches.first?.location(in: selfNode))
        //{}
    }
    
    
    
    //create bipin text box
    func createTextBox(_ inputText:String)
    {
        

        let textBoxSize = CGSize(width: self.frame.width/1.5, height: self.frame.height/8)
        let textBoxPosition = CGPoint(x:-distanceBetweenTiles,y:distanceBetweenTiles*5)
        
    
        let textboxImg = "textBox.png"
        textBox = SKSpriteNode(texture: SKTexture(imageNamed: textboxImg))
        textBox.name = "textBox"
        textBox.size = textBoxSize
        textBox.position = textBoxPosition
        textBox.zPosition = 0
        textBox.alpha = 0.1
        selfNode.addChild(textBox)
        
        
        text = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
        text.text = inputText
        text.fontSize = 20*scale
        text.fontColor = SKColor.white
        text.verticalAlignmentMode = .center
        text.position = CGPoint(x: 0, y: 0)
        textBox.addChild(text)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        
        
        textBox.run(fadeIn)
    
    }
   
    //create pointer animation
    func animatePointer(location: CGPoint, type: String)
    {
        pointer.position = location
        var imgListArray :[SKTexture] = []
        pointer.alpha = 1
        
        for countValue in 2...8 {
            if type == "grey" {
                let strImageName : String = "xw\(countValue)"
                let texture  = SKTexture(imageNamed: strImageName)
                imgListArray.append(texture)
            } else {
                let strImageName : String = "x\(countValue)"
                let texture  = SKTexture(imageNamed: strImageName)
                imgListArray.append(texture)
            }
        }
        
        let animatePointer = SKAction.animate(with: imgListArray, timePerFrame: 0.03)
        pointer.run((animatePointer), completion: {
            self.pointer.alpha = 0
        })
    }
    
    func spawnBlock()
    {
        moveBlock = SKSpriteNode(texture: SKTexture(imageNamed: "brownBlock"))
        selfNode.addChild(moveBlock!)
        let blockXPos = distanceBetweenTiles*2
        let blockYPos = distanceBetweenTiles*3
        let moveBlockPosition = CGPoint(x: blockXPos, y: blockYPos)
        
        moveBlock?.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
        
        moveBlock?.position = moveBlockPosition
        moveBlock?.zPosition = 1
    }
    
    //touchesmoved (moved my finger)
    
    
    //update run every 1ms or sth
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
    
    
    //touchesbegan (triggered the second it touches) dont need rn
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {if let touch = touches.first {}}
    
    /******************BASIC FUNCTIONALITY FOR SCENE********************/
        // determines scales and aspect ratios based on screen
    func setUpScale()
    {
        // get screen size
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // define scales for aspect ratios
        
        if screenWidth <= 320 {scale = scale1}
        else if screenWidth <= 375 {scale = scale2}
        else if screenWidth <= 414 {scale = scale3}
        else if screenWidth <= 768 {scale = scale4}
        else if screenWidth <= 834 {scale = scale5}
        else if screenWidth <= 1024 {scale = scale6
        }
        if screenHeight <= 1000 {
            iconScale = iconScale1
        } else {
            iconScale = iconScale2
        }
        let ratio:CGFloat = screenWidth/screenHeight
        if ratio >= 0.4618 && ratio <= 0.4621 {
            aspectRatio = 9/19.5
            reverseRatio = 19.5/9
        }
        
        // determine distance between tiles
        
        distanceBetweenTiles = self.frame.height/7.45*aspectRatio
    }
    
    // move and face character upon click
    
    func moveAndOrientCharacter(location: CGPoint) {
        var durFuncDistX = link.position.x - location.x
        var durFuncDistY = link.position.y - location.y
        
        let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
        let velocity = 200
        let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(velocity))
        
        var movePosition = location
        
        for child in (tileNode?.children)! as! [SKSpriteNode] {
            if child.contains(location) {
                movePosition = child.position
                durFuncDistX = link.position.x - movePosition.x
                durFuncDistY = link.position.y - movePosition.y
            }
        }
        let moveAction = SKAction.move(to: movePosition, duration: time)
        let yMove = movePosition.y+link.size.height*2/3

        link.run(moveAction)
        link.zRotation = atan2((durFuncDistY),(durFuncDistX)) + CGFloat.pi/2
    }
    
    func createTiles()
    {
        let oddOrEvenNumX = CGFloat((columnNumber+1) % 2)
        let oddOrEvenNumY = CGFloat((rowNumber*2+1) % 2)
        let midWayNumX = Int((CGFloat(columnNumber)/2+0.1).rounded())
        let midWayNumY = Int((CGFloat(rowNumber)+0.1).rounded())
        print (midWayNumY)
        for xIndex in 1...columnNumber {
            for yIndex in 1...rowNumber*2+1 {
                let xPosition = distanceBetweenTiles*CGFloat(xIndex-midWayNumX)
                let yPosition = distanceBetweenTiles*CGFloat(yIndex-midWayNumY)
                let xOffSet = distanceBetweenTiles*0.5*oddOrEvenNumX
                let yOffSet = distanceBetweenTiles*0.5*oddOrEvenNumY
                let calc1 = -yOffSet+yPosition
                let calculation =  calc1-distanceBetweenTiles/2
                makeTileNodes(NodeLocation: CGPoint(x: -xOffSet+xPosition, y: calculation), randomNumber: 0)
            }
        }
    }
    
    // function called to create each tile
    func makeTileNodes(NodeLocation: CGPoint, randomNumber: Int)
    {
        numberTile = SKSpriteNode(texture: SKTexture(imageNamed: "darkTile.png"))
        numberTile.name = "numberTileTexture"
        numberTile.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
        numberTile.position = NodeLocation
        numberTile.zPosition = 0
        tileNode!.addChild(numberTile)
        
        //numberTile.run(colorize(number: randomNumber))
        
        let clickableTileTexture = SKTexture(imageNamed: "scrabbleTile.png")
        clickableTileOutline = SKSpriteNode(texture: clickableTileTexture)
        clickableTileOutline.size = CGSize(width: numberTile.size.width, height: numberTile.size.height)
        clickableTileOutline.position = CGPoint(x: 0, y: 0)
        clickableTileOutline.name = "ClickableTileOutline"
        clickableTileOutline.alpha = 0
        numberTile.addChild(clickableTileOutline)
        
    }
    
    
    //tile texture over random images
    func createRandomTileTexture()->SKTexture
    {
        var imgListArray :[SKTexture] = []
        for countValue in 1...6 {
            let strImageName : String = "g\(countValue)"
            let texture  = SKTexture(imageNamed: strImageName)
            imgListArray.append(texture)
        }
        return imgListArray[Int.random(in: 0 ... imgListArray.count-1)]
        
    }
    
    //function to make a character
    func createCharacter(charName: String, name: String, position: CGPoint, sprite: inout Character)
    {
        //link code block
        sprite.name = charName
        sprite.position = position
        selfNode.addChild(sprite)
    }
    
}
