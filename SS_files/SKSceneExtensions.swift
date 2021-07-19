//
//  SKSceneExtensions.swift
//  SwordScape

import SpriteKit
import GameplayKit
import Darwin

extension GameScene {
	
	// determines scales and aspect ratios based on screen
	func setUpScaleAndNodes()
	{
		// get screen size
		
		let screenSize = UIScreen.main.bounds
		screenWidth = screenSize.width
		screenHeight = screenSize.height
		
		// define scales for aspect ratios
		
		if screenWidth <= 320
		{
			scale = scale1
		} else if screenWidth <= 375
		{
			scale = scale2
		} else if screenWidth <= 414
		{
			scale = scale3
		} else if screenWidth <= 768
		{
			scale = scale4
		} else if screenWidth <= 834
		{
			scale = scale5
		} else if screenWidth <= 1024
		{
			scale = scale6
		}
		if screenHeight <= 1000
		{
			iconScale = iconScale1
		} else
		{
			iconScale = iconScale2
		}
		let ratio:CGFloat = screenWidth/screenHeight
		if ratio >= 0.4618 && ratio <= 0.4621
		{
			aspectRatio = 9/19.5
			reverseRatio = 19.5/9
		}
		
		// determine distance between tiles
		
		distanceBetweenTiles = self.frame.height/7.5*aspectRatio
		
		var gameWidth = distanceBetweenTiles*CGFloat(columnNumber)
		gameWidth = gameWidth/4
		var gameHeight = distanceBetweenTiles*CGFloat(rowNumber)
		gameHeight = gameHeight/2

		selfNode = SKSpriteNode()
		selfNode.size = CGSize(width: gameWidth, height: gameHeight)
		selfNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
		selfNode.zPosition = -3
		self.addChild(selfNode)
		
		tileNode = SKSpriteNode()
		
		movingNode = SKSpriteNode()
		movingNode.size = CGSize(width: gameWidth, height: gameHeight)
		movingNode.position = CGPoint(x: 0, y: 0)
		movingNode.zPosition = -3
		selfNode.addChild(movingNode)
		
		movingNode.addChild(tileNode!)
		
		elseNode = SKSpriteNode()
		elseNode.size = CGSize(width: gameWidth, height: gameHeight)
		elseNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
		elseNode.zPosition = -3
		self.addChild(elseNode)
		
		stationaryNode = SKSpriteNode()
		stationaryNode.size = CGSize(width: gameWidth, height: gameHeight)
		stationaryNode.position = CGPoint(x: 0, y: 0)
		stationaryNode.zPosition = -3
		elseNode.addChild(stationaryNode)
		
	}
	
	
	@objc func initializeGame() {
		
		
		
		background = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		background.size = CGSize(width: self.frame.width, height: self.frame.height)
		background.position = CGPoint(x: 0, y: 0)
		background.zPosition = -2
		movingNode.addChild(background)
		
		let size = CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		
		link = Character(texture: SKTexture(imageNamed: "link.png"), size: size, attackSpd: 1)
		
		boss = Character(texture: SKTexture(imageNamed: "monster.png"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		
		
		healthBarLink = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		healthBarBoss = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		createCharacter(charName: "link", name: "linkSword", position: CGPoint(x:0,y:0),sprite: &link, health: 100, healthBar: &healthBarLink)
		let randomX = Int.random(in: 1...columnNumber)
		let randomY = Int.random(in: 1...rowNumber*2+1)
		let randomPoint = getCGPointAtPosition(x: randomX, y: randomY)
		createCharacter(charName: "boss", name: "bossSword",position: CGPoint(x:randomPoint.x,y:randomPoint.y),sprite: &boss, health: 100, healthBar: &healthBarBoss)
		
		//pointer block
		pointer = SKSpriteNode()
		pointer.size = CGSize(width: self.frame.width/10/iconScale, height: self.frame.width/10/iconScale)
		pointer.position = CGPoint(x: 0, y: 0)
		pointer.zPosition = 1
		stationaryNode.addChild(pointer)
		
		timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(randomWalk), userInfo: nil, repeats: true)
		let yPos2 = -self.frame.height/2 + self.frame.height/4*aspectRatio/2
		let yPos1 = yPos2 + self.frame.height/4*aspectRatio/2+self.frame.height/3*aspectRatio/2

		createPage(name: "attackPage", size: CGSize(width: self.frame.width*3/4/iconScale, height: self.frame.height/3*aspectRatio), position:  CGPoint(x: 0, y: yPos1), withLabels: true, alpha: 1)
		createPage(name: "combatStylePage", size: CGSize(width: self.frame.width*3/4/iconScale, height: self.frame.height/4*aspectRatio), position: CGPoint(x: 0, y: yPos2), withLabels: false, alpha: 1)
		createPage(name: "rangedPage", size: CGSize(width: self.frame.width/4/iconScale, height: self.frame.height/3*aspectRatio), position: CGPoint(x: 0, y: yPos1), withLabels: true, alpha: 1)
		createPage(name: "magicPage", size: CGSize(width: self.frame.width/4/iconScale, height: self.frame.height/3*aspectRatio), position: CGPoint(x: self.frame.width/4/iconScale, y: yPos1), withLabels: true, alpha: 1)
	}
	
	func createButton(page: inout SKSpriteNode, name: String, xPosition: CGFloat, xpLabelName: String, lvlLabelName: String, image: String, xp: Int, Lvl: Int) {
		let yPos3 = page.size.height/4
		
		let button = SKSpriteNode(texture: SKTexture(imageNamed: image))
		button.size = CGSize(width: self.frame.height/5.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		let yPos = -button.size.height*6/7
		let yPos2 = -button.size.height*3/2
		button.position = CGPoint(x: xPosition, y: yPos3)
		button.name = name
		button.zPosition = 1
		page.addChild(button)
		
		let xpLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		xpLabel.text = "XP: "+String(xp)
		xpLabel.fontSize = 25*scale
		xpLabel.name = xpLabelName
		xpLabel.fontColor = SKColor.white
		xpLabel.verticalAlignmentMode = .center
		xpLabel.position = CGPoint(x: 0, y: yPos)
		button.addChild(xpLabel)
		
		let lvlLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		lvlLabel.text = "LVL: "+String(Lvl)
		lvlLabel.fontSize = 25*scale
		lvlLabel.name = lvlLabelName
		lvlLabel.fontColor = SKColor.white
		lvlLabel.verticalAlignmentMode = .center
		lvlLabel.position = CGPoint(x: 0, y: yPos2)
		button.addChild(lvlLabel)
	}
	
	func createButtonWithoutLabels(page: inout SKSpriteNode, name: String, xPosition: CGFloat, image: String) {
		
		let button = SKSpriteNode(texture: SKTexture(imageNamed: image))
		button.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		
		button.position = CGPoint(x: xPosition, y: 0)
		button.name = name
		button.zPosition = 1
		page.addChild(button)
	}
	
	func createLabels(page: inout SKSpriteNode, xpLabelName: String, lvlLabelName: String, xp: Int, Lvl: Int) {
		
		let yPos = page.size.height/5
		let yPos2 = -page.size.height/5
		
		let xpLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		xpLabel.text = "XP: "+String(xp)
		xpLabel.fontSize = 25*scale
		xpLabel.name = xpLabelName
		xpLabel.fontColor = SKColor.white
		xpLabel.verticalAlignmentMode = .center
		xpLabel.position = CGPoint(x: 0, y: yPos)
		page.addChild(xpLabel)
		
		let lvlLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		lvlLabel.text = "LVL: "+String(Lvl)
		lvlLabel.fontSize = 25*scale
		lvlLabel.name = lvlLabelName
		lvlLabel.fontColor = SKColor.white
		lvlLabel.verticalAlignmentMode = .center
		lvlLabel.position = CGPoint(x: 0, y: yPos2)
		page.addChild(lvlLabel)
	}
	
	func createPage(name: String, size: CGSize, position: CGPoint, withLabels: Bool, alpha: CGFloat){
		var page = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		page.alpha = alpha
		page.size = size
		page.name = name
		page.position = position
		page.zPosition = 1
		stationaryNode.addChild(page)
		if name == "magicPage" || name == "rangedPage"
		{
			hidePage(page: &page)
		}
		if withLabels
		{
			if name == "attackPage"
			{
				createButton(page: &page, name: "attackButton", xPosition: -page.size.width/3, xpLabelName: "attackXPLabel", lvlLabelName: "attackLvlLabel", image: "stab", xp: link.attackXP, Lvl: link.getAttackLVL())
				createButton(page: &page, name: "strengthButton", xPosition: 0, xpLabelName: "strengthXPLabel", lvlLabelName: "strengthLvlLabel", image: "slashOn", xp: link.strengthXP, Lvl: link.getStrLvl())
				createButton(page: &page, name: "defenseButton", xPosition: page.size.width/3, xpLabelName: "defenseXPLabel", lvlLabelName: "defenseLvlLabel", image: "block", xp: link.defenseXP, Lvl: link.getDefLvl())
			}
			else if name == "rangedPage"
			{
				createLabels(page: &page, xpLabelName: "rangedXPLabel", lvlLabelName: "rangedLvlLabel", xp: link.rangedXP, Lvl: link.getRangedLvl())
			}
			else if name == "magicPage"
			{
				createLabels(page: &page, xpLabelName: "magicXPLabel", lvlLabelName: "magicLvlLabel", xp: link.magicXP, Lvl: link.getMagicLvl())
			}
		}
		else
		{
			createButtonWithoutLabels(page: &page, name: "meleeButton", xPosition: -page.size.width/3, image: "meleeOn")
			createButtonWithoutLabels(page: &page, name: "rangedButton", xPosition: 0, image: "archery")
			createButtonWithoutLabels(page: &page, name: "magicButton", xPosition: page.size.width/3, image: "magic")
		}
	}
	
	@objc func createBoss() {
		boss.isHidden = false
		let randomX = Int.random(in: columnNumber*3/8...columnNumber*5/8)
		let randomY = Int.random(in: rowNumber...rowNumber*3/2+1)
		let randomPoint = getCGPointAtPosition(x: randomX, y: randomY)
		boss.position = CGPoint(x:randomPoint.x,y:randomPoint.y)
		
		healthBarBoss.isHidden = false
		var y1 = boss.position.y
		y1 += boss.size.height*2/3
		self.healthBarBoss.position = CGPoint(x:boss.position.x, y: y1)
		let leftBar = healthBarBoss.childNode(withName: "barLeft") as! SKSpriteNode
		let barHeight = healthBarBoss.size.height*9/10
		let barLeftWidth = healthBarBoss.size.width*19/20
		leftBar.size = CGSize(width: barLeftWidth, height:  barHeight)
		let rightBar = healthBarBoss.childNode(withName: "barRight") as! SKSpriteNode
		rightBar.size = CGSize(width: 0, height:  barHeight)
		randomWalk()
	}
	
	@objc func createLink() {
		link.isHidden = false
		link.position = CGPoint(x:0,y:0)
		healthBarLink.isHidden = false
		let yPos = link.size.height*2/3
		self.healthBarLink.position = CGPoint(x:link.position.x, y: link.position.y+yPos)
		let leftBar = healthBarLink.childNode(withName: "barLeft") as! SKSpriteNode
		let barHeight = healthBarLink.size.height*9/10
		let barLeftWidth = healthBarLink.size.width*19/20
		leftBar.size = CGSize(width: barLeftWidth, height:  barHeight)
		let rightBar = healthBarLink.childNode(withName: "barRight") as! SKSpriteNode
		rightBar.size = CGSize(width: 0, height:  barHeight)
	}
	
	func createCharacter(charName: String, name: String, position: CGPoint, sprite: inout Character, health: Int, healthBar: inout SKSpriteNode) {
		//link code block
		sprite.name = charName
		sprite.position = position
		
		healthBar.size = CGSize(width: sprite.size.width, height: sprite.size.width/3)
		healthBar.position = CGPoint(x: sprite.position.x, y: sprite.position.y+sprite.size.height*2/3)
		healthBar.zPosition = 0
		if charName == "link" {
			stationaryNode.addChild(sprite)
			stationaryNode.addChild(healthBar)
		} else {
			movingNode.addChild(sprite)
			movingNode.addChild(healthBar)
		}
		
		
		let barHeight = healthBar.size.height*9/10
		let barLeftWidth = healthBar.size.width*19/20
		let barLeft = SKSpriteNode(texture: SKTexture(imageNamed: "scrabbleTile.png"))
		barLeft.name = "barLeft"
		barLeft.size = CGSize(width: barLeftWidth, height:  barHeight)
		let xPos = -sprite.size.width*9.5/20
		barLeft.position = CGPoint(x: xPos, y: 0)
		barLeft.anchorPoint = CGPoint(x: 0, y: 0.5)
		barLeft.zPosition = 0
		healthBar.addChild(barLeft)
		
		barLeft.run(colorize(number: 8))
		
		let xPos2 = sprite.size.width*9.5/20
		let barRight = SKSpriteNode(texture: SKTexture(imageNamed: "scrabbleTile.png"))
		barRight.name = "barRight"
		barRight.size = CGSize(width: 0, height: barHeight)
		barRight.position = CGPoint(x: xPos2, y: 0)
		barRight.anchorPoint = CGPoint(x: 1, y: 0.5)
		barRight.zPosition = 0
		healthBar.addChild(barRight)
		
		barRight.run(colorize(number: 7))
		
		
		let sword = SKSpriteNode(texture: SKTexture(imageNamed: "sword"))
		sword.name = name
		sword.size = CGSize(width: sprite.size.width/3, height: sprite.size.width)
		sword.position = CGPoint(x: sprite.size.width/2, y: 0)
		sword.anchorPoint = CGPoint(x: 0.5, y: 0)
		
		sword.zPosition = 0
		
		sprite.addChild(sword)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		sword.run(fadeOut)
		
		let yPos = -sprite.size.height*2/3
		let hitBox = SKSpriteNode(texture: SKTexture(imageNamed: "hit"))
		hitBox.name = "hitBox"
		hitBox.size = CGSize(width: sprite.size.width, height: sprite.size.width)
		hitBox.position = CGPoint(x: 0, y: yPos)
		hitBox.zPosition = 0
		healthBar.addChild(hitBox)
		hitBox.run(fadeOut)
		
		let hitLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		hitLabel.text = ""
		hitLabel.fontSize = 30*scale
		hitLabel.fontColor = SKColor.white
		hitLabel.verticalAlignmentMode = .center
		hitLabel.position = CGPoint(x: 0, y: 0)
		hitBox.addChild(hitLabel)
		
		if charName == "link"
		{
			let bow = SKSpriteNode(texture: SKTexture(imageNamed: "bow"))
			bow.name = "bow"
			bow.size = CGSize(width: sprite.size.width, height: sprite.size.width)
			bow.position = CGPoint(x: sprite.size.width/2, y: -sprite.size.height/8)
			bow.anchorPoint = CGPoint(x: 0.5, y: 0)
			bow.zPosition = 1
			sprite.addChild(bow)
			bow.run(fadeOut)

			let arrow = SKSpriteNode(texture: SKTexture(imageNamed: "arrow"))
			arrow.name = "arrow"
			arrow.size = CGSize(width: sprite.size.width, height: sprite.size.width)
			arrow.position = CGPoint(x: 0, y: 0)
			arrow.anchorPoint = CGPoint(x: 0.5, y: 0)
			arrow.zPosition = 1
			sprite.addChild(arrow)
			arrow.run(fadeOut)
			
			let staff = SKSpriteNode(texture: SKTexture(imageNamed: "staff"))
			staff.name = "staff"
			staff.size = CGSize(width: sprite.size.height*5/12, height: sprite.size.height)
			staff.position = CGPoint(x: sprite.size.width/2, y: 0)
			staff.anchorPoint = CGPoint(x: 0.5, y: 0)
			staff.zPosition = 1
			sprite.addChild(staff)
			
			let fireBall = SKSpriteNode(texture: SKTexture(imageNamed: "fireBall"))
			fireBall.name = "fireBall"
			fireBall.size = CGSize(width: sprite.size.width*2/3, height: sprite.size.width*2/3)
			fireBall.position = CGPoint(x: 0, y: 0)
			fireBall.anchorPoint = CGPoint(x: 0.5, y: 0)
			
			fireBall.zPosition = 1
			
			sprite.addChild(fireBall)
			staff.run(fadeOut)
			fireBall.run(fadeOut)
		}
		
	}
	
	
	// create game tiles for each row and column
	
	func createTiles()
	{
		let oddOrEvenNumX = CGFloat((columnNumber+1) % 2)
		let oddOrEvenNumY = CGFloat((rowNumber*2+1) % 2)
		let midWayNumX = Int((CGFloat(columnNumber)/2+0.1).rounded())
		let midWayNumY = Int((CGFloat(rowNumber)+0.1).rounded())
		print (midWayNumY)
		for xIndex in 1...columnNumber
		{
			for yIndex in 1...rowNumber*2+1
			{
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
	func makeTileNodes(NodeLocation: CGPoint, randomNumber: Int) {
		
		let numberTile = SKSpriteNode(texture: SKTexture(imageNamed: "darkTile"))
		numberTile.name = "numberTileTexture"
		numberTile.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		numberTile.position = NodeLocation
		numberTile.zPosition = 0
		tileNode!.addChild(numberTile)
		
	}
	
	
	
	func stabAction(sprite: inout Character) -> SKAction {
		
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let stab = SKAction.moveBy(x: 0, y: sprite.size.width/4, duration: 0.05)
		let wait = SKAction.wait(forDuration: 0.1)
		let fadeOut = SKAction.fadeOut(withDuration: 0.1)
		let moveBack = SKAction.moveBy(x: 0, y: -sprite.size.width/4, duration: 0)
		let stabSequence = SKAction.sequence([fadeIn,stab,wait,fadeOut,moveBack])
		return stabSequence
	}
	
	func slashAction(sprite: inout Character) -> SKAction {
		
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let swipe = SKAction.moveBy(x: -sprite.size.width/2, y: 0, duration: 0.2)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		let moveBack = SKAction.moveBy(x: sprite.size.width/2, y: 0, duration: 0)
		let rotateStart = SKAction.rotate(toAngle: -CGFloat.pi/6, duration: 0)
		let rotate = SKAction.rotate(toAngle: CGFloat.pi/6, duration: 0.2)
		let rotateBack = SKAction.rotate(toAngle: 0, duration: 0)
		let group = SKAction.group([swipe,rotate])
		let swipeSequence = SKAction.sequence([rotateStart,fadeIn,group,fadeOut,rotateBack,moveBack])
		return swipeSequence
	}
	
	func shootArrowAction(sprite: inout Character) -> SKAction {
		
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let shoot = SKAction.moveBy(x: 0, y: linkToBossDist, duration: 0.2)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		
		let moveBack = SKAction.moveBy(x: 0, y: -linkToBossDist, duration: 0)
		
		let shootSequence = SKAction.sequence([fadeIn,shoot,fadeOut,moveBack])
		return shootSequence
	}
	func fadeInOut(sprite: inout Character) -> SKAction {
		
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let wait = SKAction.wait(forDuration: 0.2)
		let fadeOut = SKAction.fadeOut(withDuration: 0.1)
		
		
		let fadeInOut = SKAction.sequence([fadeIn,wait,fadeOut])
		return fadeInOut
	}
	
	
	// add XP based on attack style and change xp and lvl labels as necessary
	
	func addXpAndChangeLabels(character: inout Character, hitAmount: Int) {
		let attackPage = stationaryNode.childNode(withName: "attackPage") as! SKSpriteNode
		let rangedPage = stationaryNode.childNode(withName: "rangedPage") as! SKSpriteNode
		let magicPage = stationaryNode.childNode(withName: "magicPage") as! SKSpriteNode

		if meleeOn
		{
			if stabOn
			{
				character.addAttackXP(amount: hitAmount*4)
				let attackButton = attackPage.childNode(withName: "attackButton") as! SKSpriteNode
				let attackXPLabel = attackButton.childNode(withName: "attackXPLabel") as! SKLabelNode
				let attackLvlLabel = attackButton.childNode(withName: "attackLvlLabel") as! SKLabelNode
				attackXPLabel.text = "XP: "+String(character.attackXP)
				attackLvlLabel.text = "LVL: "+String(character.getAttackLVL())
			}
			else if slashOn
			{
				character.addStrengthXP(amount: hitAmount*4)
				let strengthButton = attackPage.childNode(withName: "strengthButton") as! SKSpriteNode
				let strengthXPLabel = strengthButton.childNode(withName: "strengthXPLabel") as! SKLabelNode
				let strengthLvlLabel = strengthButton.childNode(withName: "strengthLvlLabel") as! SKLabelNode
				strengthXPLabel.text = "XP: "+String(character.strengthXP)
				strengthLvlLabel.text = "LVL: "+String(character.getStrLvl())
			}
			else if blockOn
			{
				character.addDefenseXP(amount: hitAmount*4)
				let defenseButton = attackPage.childNode(withName: "defenseButton") as! SKSpriteNode
				let defenseXPLabel = defenseButton.childNode(withName: "defenseXPLabel") as! SKLabelNode
				let defenseLvlLabel = defenseButton.childNode(withName: "defenseLvlLabel") as! SKLabelNode
				defenseXPLabel.text = "XP: "+String(character.defenseXP)
				defenseLvlLabel.text = "LVL: "+String(character.getDefLvl())
			}
		}
		else if rangedOn
		{
			character.addRangedXP(amount: hitAmount*4)
			let rangedXPLabel = rangedPage.childNode(withName: "rangedXPLabel") as! SKLabelNode
			let rangedLvlLabel = rangedPage.childNode(withName: "rangedLvlLabel") as! SKLabelNode
			rangedXPLabel.text = "XP: "+String(character.rangedXP)
			rangedLvlLabel.text = "LVL: "+String(character.getRangedLvl())
		}
		else if magicOn
		{
			character.addMagicXP(amount: hitAmount*4)
			let magicXPLabel = magicPage.childNode(withName: "magicXPLabel") as! SKLabelNode
			let magicLvlLabel = magicPage.childNode(withName: "magicLvlLabel") as! SKLabelNode
			magicXPLabel.text = "XP: "+String(character.magicXP)
			magicLvlLabel.text = "LVL: "+String(character.getMagicLvl())
		}
		character.addhpXP(amount: hitAmount)
	}
	
	// change health bar and health stat as needed
	func modifyHealthOnHit(character: inout Character, healthBar: inout SKSpriteNode, hitAmount: Int) {
		let charName = character.name
		let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
		box.removeAllActions()
		let barLeft = healthBar.childNode(withName: "barLeft") as! SKSpriteNode
		let barRight = healthBar.childNode(withName: "barRight") as! SKSpriteNode
		let charHP = CGFloat(character.getHP())
		let bossBoxLabel = box.children[0] as! SKLabelNode
		bossBoxLabel.text = String(hitAmount)
		if hitAmount > 0
		{
			box.texture = SKTexture(imageNamed: "hit")
		}
		else
		{
			box.texture = SKTexture(imageNamed: "miss")
		}
		let wait1 = SKAction.wait(forDuration: 0)
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let wait2 = SKAction.wait(forDuration: 0.5)
		let fadeOut = SKAction.fadeOut(withDuration: 0.1)
		let removeHealth = SKAction.run({
			let originalHealth = box.size.width*19/20
			let decreaseAmount = originalHealth/charHP*CGFloat(hitAmount)
			barLeft.size = CGSize(width: barLeft.size.width-decreaseAmount, height: barLeft.size.height)
			barRight.size = CGSize(width: barRight.size.width+decreaseAmount, height: barRight.size.height)
			if barLeft.size.width < 0.1 && charName == "link" {
				self.flagBoss = true
			} else if barLeft.size.width < 0.1 && charName == "boss" {
				self.flagLink = true
			}
		})
		let hitSequence = SKAction.sequence([wait1,fadeIn,removeHealth,wait2,fadeOut])
		box.run(hitSequence)
	}
	func modifyHealthOnMiss(healthBar: inout SKSpriteNode) {
		let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
		box.removeAllActions()
	}

	
	
	func determineHit(attackStyle: String, character: inout Character, healthBar: inout SKSpriteNode!) {
		var otherCharDefense:Int = 0
		if character.name == "link"
		{
			otherCharDefense = boss.getDefLvl()
		}
		else
		{
			otherCharDefense = link.getDefLvl()
		}
		let hitChance = character.hitChance(combatStyle: attackStyle, enemyDefenceLvl: otherCharDefense)
		let hitAmount = character.hitAmount(combatStyle: attackStyle)
		if hitChance > 0
		{
			if character.name == "link"
			{
				addXpAndChangeLabels(character: &character, hitAmount: hitAmount)
			}
			modifyHealthOnHit(character: &character, healthBar: &healthBar, hitAmount: hitAmount)
		}
		else
		{
			modifyHealthOnMiss(healthBar: &healthBar)
		}
	}
	
	// orient Link, determine attack type, animate attack
	
	func runCombatLink(){
		let bossPositionX = boss.position.x+movingNode.position.x
		let bossPositionY = boss.position.y+movingNode.position.y
		link.zRotation = atan2((link.position.y-bossPositionY),(link.position.x-bossPositionX)) + CGFloat.pi/2
		linkAttacking = true
		let sword = link.childNode(withName: "linkSword") as! SKSpriteNode
		var action = slashAction(sprite: &link)
		var attackStyle = "melee"
		if meleeOn
		{
			if blockOn || stabOn
			{
				action = stabAction(sprite: &link)
			}
			sword.run(action, completion:
				{
				let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
				sword.run((wait1), completion:
					{
					self.linkAttacking = false
					})
				self.determineHit(attackStyle: attackStyle, character: &self.link, healthBar: &self.healthBarBoss)
				
				})
		}
		else if rangedOn
		{
			action = shootArrowAction(sprite: &link)
			attackStyle = "ranged"
			let bow = link.childNode(withName: "bow") as! SKSpriteNode
			bow.run(fadeInOut(sprite: &link))
			let arrow = link.childNode(withName: "arrow") as! SKSpriteNode
			
			arrow.run(action, completion:
				{
				let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
				arrow.run((wait1), completion:
					{
					self.linkAttacking = false
					})
				self.determineHit(attackStyle: attackStyle, character: &self.link, healthBar: &self.healthBarBoss)
				
				})
		} else if magicOn
		{
			action = shootArrowAction(sprite: &link)
			attackStyle = "magic"
			let staff = link.childNode(withName: "staff") as! SKSpriteNode
			staff.run(fadeInOut(sprite: &link))
			let fireBall = link.childNode(withName: "fireBall") as! SKSpriteNode
			
			fireBall.run(action, completion:
				{
				let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
				fireBall.run((wait1), completion:
					{
					self.linkAttacking = false
				})
				self.determineHit(attackStyle: attackStyle, character: &self.link, healthBar: &self.healthBarBoss)
				
			})
		}
		
	}
	
	// orient boss, animate attack
	
	func runCombatBoss(){
		let bossPositionX = boss.position.x+movingNode.position.x
		let bossPositionY = boss.position.y+movingNode.position.y
		boss.zRotation = atan2((bossPositionY-link.position.y),(bossPositionX-link.position.x)) + CGFloat.pi/2
		bossAttacking = true
		let sword = boss.childNode(withName: "bossSword") as! SKSpriteNode
		sword.run((slashAction(sprite: &boss)), completion:
			{
			let wait1 = SKAction.wait(forDuration: self.bossAttackSpeed)
			sword.run((wait1), completion:
				{
				self.bossAttacking = false
			})
			self.determineHit(attackStyle: "melee", character: &self.boss, healthBar: &self.healthBarLink)
		})
	}

	
	
	func runCombat() {
		if linkAttacking == false
		{
			runCombatLink()
		}
		if bossAttacking == false
		{
			runCombatBoss()
		}
		
	}
	
	func createRandomTileTexture()->SKTexture {
		var imgListArray :[SKTexture] = []
		for countValue in 1...6
		{
			let strImageName : String = "g\(countValue)"
			let texture  = SKTexture(imageNamed: strImageName)
			imgListArray.append(texture)
		}
		return imgListArray[Int.random(in: 0 ... imgListArray.count-1)]
		
	}
	
	// function to color tiles etc
	
	func colorize(number: Int)->SKAction{
		var colorize: SKAction!
		if number == 0 {
			colorize = SKAction.colorize(with: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 1 {
			colorize = SKAction.colorize(with: UIColor.init(red: 254/255, green: 215/255, blue: 10/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 2 {
			colorize = SKAction.colorize(with: UIColor.init(red: 255/255, green: 153/255, blue: 31/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 3 {
			colorize = SKAction.colorize(with: UIColor.init(red: 70/255, green: 182/255, blue: 33/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 4 {
			colorize = SKAction.colorize(with: UIColor.init(red: 80/255, green: 130/255, blue: 250/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 5 {
			colorize = SKAction.colorize(with: UIColor.init(red: 237/255, green: 46/255, blue: 62/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 6 {
			colorize = SKAction.colorize(with: UIColor.init(red: 204/255, green: 255/255, blue: 204/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 7 {
			colorize = SKAction.colorize(with: UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		} else if number == 8 {
			colorize = SKAction.colorize(with: UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		}
		return colorize
	}
	
	//create pointer animation
	
	func animatePointer(location: CGPoint, type: String) {
		pointer.position = location
		var imgListArray :[SKTexture] = []
		pointer.alpha = 1
		
		for countValue in 2...8
		{
			if type == "grey"
			{
				let strImageName : String = "xw\(countValue)"
				let texture  = SKTexture(imageNamed: strImageName)
				imgListArray.append(texture)
			}
			else
			{
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
	
	// random boss movement
	
	@objc func randomWalk() {
		
		var nextMoveArray:[CGPoint] = []
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			let adjustedDist = distanceBetweenTiles*5/4
			let bossPositionX = boss.position.x
			let bossPositionY = boss.position.y
			if child.position != boss.position && (child.position.x >= bossPositionX-adjustedDist && child.position.x <= bossPositionX+adjustedDist) && (child.position.y >= bossPositionY-adjustedDist && child.position.y <= bossPositionY+adjustedDist) && (child.position.x == bossPositionX || child.position.y == bossPositionY)
			{
				nextMoveArray.append(child.position)
			}
		}
		if nextMoveArray.count == 0
		{
			for child in (tileNode?.children)! as! [SKSpriteNode]
			{
				let adjustedDist = distanceBetweenTiles*5/4
				let bossPositionX = boss.position.x
				let bossPositionY = boss.position.y
				if child.position != boss.position && (child.position.x >= bossPositionX-adjustedDist && child.position.x <= bossPositionX+adjustedDist) && (child.position.y >= bossPositionY-adjustedDist && child.position.y <= bossPositionY+adjustedDist)
				{
					nextMoveArray.append(child.position)
				}
			}
		}
		let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
		let time:TimeInterval = 0.8
		let moveAction = SKAction.move(to: randMove, duration: time)
		boss.run(moveAction)
		boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
		var yMove = randMove.y
		yMove += boss.size.height*2/3
		let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
		healthBarBoss.run(healthMoveAction)
	}
	
	
	
	// move and face character upon click
	
	func moveAndOrientCharacter(location: CGPoint, attackMode: String) {
		movingNode.removeAllActions()
		var durFuncDistX = link.position.x - location.x
		var durFuncDistY = link.position.y - location.y
		
		var pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		
		let velocity = 200
		let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(velocity))
		
		var movePosition = location
		var startX = link.position.x
		var startY = link.position.y
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			
			let linkLocation = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
			if child.contains(linkLocation)
			{
				print ("here")
				startX = child.position.x + movingNode.position.x
				startY = child.position.y + movingNode.position.y

			}
		}
		
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			if child.contains(location)
			{
				print ("here")
				movePosition = child.position
				durFuncDistX = startX + movePosition.x
				durFuncDistY = startY + movePosition.y
			}
		}
		pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		print (pythagDistance)
		var yMove = durFuncDistY
		var xMove = durFuncDistX
		//let moveScale = distanceBetweenTiles*3/pythagDistance
		if attackMode == "ranged" || attackMode == "magic"
		{
			if pythagDistance > distanceBetweenTiles*3
			{
				let angle = atan2(durFuncDistY, durFuncDistX)
				let yComp = distanceBetweenTiles*2*sin(angle)
				let xComp = distanceBetweenTiles*2*cos(angle)

				//yMove = yMove
				xMove = xMove-xComp
				yMove = yMove-yComp
			}
		}
		//print (xMove)
		//print (yMove)
		//let moveAction = SKAction.move(by: CGVector(dx: -xMove, dy: -yMove), duration: time)
		//let moveAction = SKAction.move(to: CGPoint(x: xMove, y: yMove), duration: time)
		let healthMoveAction = SKAction.move(by: CGVector(dx: -xMove, dy: -yMove), duration: time)
		movingNode.run(healthMoveAction)
		//link.run(moveAction)
		link.zRotation = atan2((-durFuncDistY),(-durFuncDistX)) + CGFloat.pi/2
	}
	// determine what side the boss is in relation to link
	
	func getQuadrant(movePosition: CGPoint)->CGPoint {
		let bossPositionX = boss.position.x+movingNode.position.x
		let bossPositionY = boss.position.y+movingNode.position.y
		let relativePositionX = bossPositionX - link.position.x
		let relativePositionY = bossPositionY - link.position.y
		var point:CGPoint!
		if relativePositionX >= 0 && relativePositionY > 0 {
			if relativePositionX >= relativePositionY {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else if relativePositionX < relativePositionY {
				point = CGPoint(x: movePosition.x, y: movePosition.y+distanceBetweenTiles)
			}
		} else if relativePositionX >= 0 && relativePositionY <= 0  {
			if relativePositionX >= relativePositionY {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else if relativePositionX < relativePositionY {
				point = CGPoint(x: movePosition.x, y: movePosition.y-distanceBetweenTiles)
			}
		} else if relativePositionX < 0 && relativePositionY <= 0  {
			if relativePositionX >= relativePositionY {
				point = CGPoint(x: movePosition.x , y: movePosition.y-distanceBetweenTiles)
			} else if relativePositionX < relativePositionY {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			}
		} else {
			if relativePositionX >= relativePositionY {
				point = CGPoint(x: movePosition.x , y: movePosition.y+distanceBetweenTiles)
			} else if relativePositionX < relativePositionY {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			}
		}
		return point
	}
	
	// move the boss out of the way if link overlaps
	
	func moveOutOfWay() {
		if boss != nil && link != nil
		{
			let bossPositionX = boss.position.x+movingNode.position.x
			let bossPositionY = boss.position.y+movingNode.position.y
			let xDiff = abs(link.position.x - bossPositionX)
			let yDiff = abs(link.position.y - bossPositionY)
			let dist = distanceBetweenTiles*5/10
			if xDiff < dist && yDiff < dist
			{
				if !bossIsBoucing
				{
					boss.removeAllActions()
					healthBarBoss.removeAllActions()
					bossIsBoucing = true
					var nextMoveArray:[CGPoint] = []
					for child in (tileNode?.children)! as! [SKSpriteNode]
					{
						let adjustedDist = distanceBetweenTiles*5/4
						
						let pythagDist = pow((pow(child.position.x - boss.position.x,2) + pow(child.position.y - boss.position.y,2)), 0.5)
						let pyDist = distanceBetweenTiles*10/9
						if !child.contains(boss.position) && (child.position.x >= boss.position.x-adjustedDist && child.position.x <= boss.position.x+adjustedDist) && (child.position.y >= boss.position.y-adjustedDist && child.position.y <= boss.position.y+adjustedDist) && (!child.contains(boss.position)) && pythagDist < pyDist
						{
							nextMoveArray.append(child.position)
						}
					}
					if nextMoveArray.count > 0
					{
						let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
						boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
						
						let time:TimeInterval = 0.2
						let moveAction = SKAction.move(to: randMove, duration: time)
						let wait = SKAction.wait(forDuration: 1)
						let sequence = SKAction.sequence([moveAction,wait])
						boss.run((sequence), completion: {
							self.bossIsBoucing = false
						})
						var yMove = randMove.y
						yMove+=boss.size.height*2/3
						let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
						let sequence2 = SKAction.sequence([healthMoveAction,wait])
						healthBarBoss.run(sequence2)
					}
				}
			}
		}
	}
	
	// update the boss position when following link
	
	func updateBossPos(speed:CGFloat) {
		if !bossIsBoucing && boss != nil && link != nil
		{
			
			let bossPositionX = boss.position.x+movingNode.position.x
			let bossPositionY = boss.position.y+movingNode.position.y
			let durFuncDistX = link.position.x - bossPositionX
			let durFuncDistY = link.position.y - bossPositionY
			let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
			//print (pythagDistance)
			//print (link.position.x)
			//print (selfNode.position.x)

			linkToBossDist = pythagDistance*6/10
			let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(100))
			if pythagDistance <= distanceBetweenTiles*1.1
			{
				runCombat()
			}
			else if pythagDistance < distanceBetweenTiles*3
			{
				if rangedOn && linkAttacking == false
				{
					runCombatLink()
				}
				if magicOn && linkAttacking == false
				{
					runCombatLink()
				}
				if timer != nil
				{
					timer!.invalidate()
					timer = nil
				}
				
				var movePosition = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
				
//				for child in (tileNode?.children)! as! [SKSpriteNode]
//				{
//					if child.contains(link.position)
//					{
//						movePosition = child.position
//					}
//				}
				movePosition = CGPoint(x: getQuadrant(movePosition: movePosition).x, y: getQuadrant(movePosition: movePosition).y)
				let moveAction = SKAction.move(to: movePosition, duration: time)
				boss.zRotation = atan2(movePosition.y,movePosition.x) + CGFloat.pi/2
				boss.run(moveAction)
				
				let bossHeightAdjust = boss.size.height*2/3
				let yMove = movePosition.y+bossHeightAdjust
				let healthMoveAction = SKAction.move(to: CGPoint(x: movePosition.x, y: yMove), duration: time)
				healthBarBoss.run(healthMoveAction)
			} else {
				if timer == nil
				{
					timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(randomWalk), userInfo: nil, repeats: true)
				}
			}
		}
	}
	
	func hidePage(page: inout SKSpriteNode) {
		if page.isHidden == false
		{
			page.isHidden = true
			let movePage = SKAction.move(by: CGVector(dx: -5000, dy: -5000), duration: 0)
			page.run(movePage)
		}
	}
	
	func getCGPointAtPosition(x: Int, y: Int) -> CGPoint {
	
		
		var tempXCoord: CGFloat!
		var tempYCoord: CGFloat!
		var coord: CGPoint!
		let oddOrEvenNumX = CGFloat((columnNumber+1) % 2)
		let oddOrEvenNumY = CGFloat((rowNumber+1) % 2)
		let midWayNumX = Int((CGFloat(columnNumber)/2+0.1).rounded())
		let midWayNumY = Int((CGFloat(rowNumber)+0.1).rounded())
		
		for xIndex in 1...columnNumber {
			for yIndex in 1...rowNumber*2+1 {
				let xPosition = distanceBetweenTiles*CGFloat(xIndex-midWayNumX)
				let yPosition = distanceBetweenTiles*CGFloat(yIndex-midWayNumY)
				let xOffSet = distanceBetweenTiles*0.5*oddOrEvenNumX
				let yOffSet = distanceBetweenTiles*0.5*oddOrEvenNumY
				if x == xIndex {
					tempXCoord = -xOffSet+xPosition
					if y == yIndex {
						let y1 = -yOffSet+yPosition
						tempYCoord = y1-distanceBetweenTiles/2
						coord = CGPoint(x: tempXCoord, y: tempYCoord)
						break
					}
				}
			}
			if coord != nil {
				break
			}
		}
		return coord
	}
	
	func getTile(x: Int, y:Int) -> SKSpriteNode {
		var myNode:SKSpriteNode!
		for child in (tileNode?.children)! as! [SKSpriteNode] {
			if child.contains(getCGPointAtPosition(x: x,y: y)) {
				myNode = child
			}
		}
		return myNode
	}
	
	func reappearPage(page: inout SKSpriteNode) {
		if page.isHidden == true
		{
			page.isHidden = false
			let movePage = SKAction.move(by: CGVector(dx: 5000, dy: 5000), duration: 0)
			page.run(movePage)
		}
	}
	
	func selectAttackStyle(touch: UITouch, location: CGPoint) {
		var attackPage = stationaryNode.childNode(withName: "attackPage") as! SKSpriteNode
		let combatPage = stationaryNode.childNode(withName: "combatStylePage") as! SKSpriteNode
		var rangedPage = stationaryNode.childNode(withName: "rangedPage") as! SKSpriteNode
		var magicPage = stationaryNode.childNode(withName: "magicPage") as! SKSpriteNode
		let attackPageLocation = touch.location(in: attackPage)
		let combatPageLocation = touch.location(in: combatPage)
		if attackPage.contains(location)
		{
			let stabButton = attackPage.childNode(withName: "attackButton") as! SKSpriteNode
			let slashButton = attackPage.childNode(withName: "strengthButton") as! SKSpriteNode
			let defenseButton = attackPage.childNode(withName: "defenseButton") as! SKSpriteNode
			
			if stabButton.contains(attackPageLocation) && !stabOn
			{
				stabOn = true
				slashOn = false
				blockOn = false
				stabButton.texture = SKTexture(imageNamed: "stabOn")
				slashButton.texture = SKTexture(imageNamed: "slash")
				defenseButton.texture = SKTexture(imageNamed: "block")
				
			} else if slashButton.contains(attackPageLocation) && !slashOn
			{
				stabOn = false
				slashOn = true
				blockOn = false
				stabButton.texture = SKTexture(imageNamed: "stab")
				slashButton.texture = SKTexture(imageNamed: "slashOn")
				defenseButton.texture = SKTexture(imageNamed: "block")
			} else if defenseButton.contains(attackPageLocation) && !blockOn
			{
				stabOn = false
				slashOn = false
				blockOn = true
				stabButton.texture = SKTexture(imageNamed: "stab")
				slashButton.texture = SKTexture(imageNamed: "slash")
				defenseButton.texture = SKTexture(imageNamed: "blockOn")
				
			}
		}
		else if combatPage.contains(location)
		{
			let meleeButton = combatPage.childNode(withName: "meleeButton") as! SKSpriteNode
			let rangedButton = combatPage.childNode(withName: "rangedButton") as! SKSpriteNode
			let magicButton = combatPage.childNode(withName: "magicButton") as! SKSpriteNode
			if meleeButton.contains(combatPageLocation) && !meleeOn
			{
				reappearPage(page: &attackPage)
				hidePage(page: &rangedPage)
				hidePage(page: &magicPage)
				meleeOn = true
				rangedOn = false
				magicOn = false
				meleeButton.texture = SKTexture(imageNamed: "meleeOn")
				rangedButton.texture = SKTexture(imageNamed: "archery")
				magicButton.texture = SKTexture(imageNamed: "magic")
				
			} else if rangedButton.contains(combatPageLocation) && !rangedOn
			{
				hidePage(page: &attackPage)
				reappearPage(page: &rangedPage)
				hidePage(page: &magicPage)
				meleeOn = false
				rangedOn = true
				magicOn = false
				meleeButton.texture = SKTexture(imageNamed: "melee")
				rangedButton.texture = SKTexture(imageNamed: "archeryOn")
				magicButton.texture = SKTexture(imageNamed: "magic")
			} else if magicButton.contains(combatPageLocation) && !magicOn
			{
				hidePage(page: &attackPage)
				hidePage(page: &rangedPage)
				reappearPage(page: &magicPage)
				meleeOn = false
				rangedOn = false
				magicOn = true
				meleeButton.texture = SKTexture(imageNamed: "melee")
				rangedButton.texture = SKTexture(imageNamed: "archery")
				magicButton.texture = SKTexture(imageNamed: "magicOn")
				
			}
		} else {
			let movingLocation = touch.location(in: movingNode)
			if boss != nil && boss.contains(movingLocation)
			{
				animatePointer (location: location, type: "red")
			} else
			{
				animatePointer (location: location, type: "grey")
				
			}
			let bossPositionX = boss.position.x+movingNode.position.x
			let bossPositionY = boss.position.y+movingNode.position.y
			let durFuncDistX = link.position.x - bossPositionX
			let durFuncDistY = link.position.y - bossPositionY
			let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
			link.removeAllActions()
			healthBarLink.removeAllActions()
			if boss.contains(location)
			{
				if pythagDistance <= distanceBetweenTiles*1.1
				{
				} else if pythagDistance < distanceBetweenTiles*3
				{
					if !rangedOn && !magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "melee")
					}
				} else
				{
					if !rangedOn && !magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "melee")
					} else if rangedOn
					{
						moveAndOrientCharacter(location: location, attackMode: "ranged")
					} else if magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "magic")
					}
				}
			} else
			{
				for tile in (tileNode?.children)! as! [SKSpriteNode] {
					if tile.contains(movingLocation) {
						moveAndOrientCharacter(location: location, attackMode: "none")
					}
				}
			}
		}
	}
	
	func handleCharacterDeath() {
		if flagBoss
		{
			self.flagBoss = false
			self.boss.isHidden = true
			self.boss.removeAllActions()
			self.healthBarBoss.removeAllActions()
			self.link.removeAllActions()
			self.boss.position = CGPoint(x: 1000, y: 1000)
			self.healthBarBoss.isHidden = true
			timer = nil
			timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(createBoss), userInfo: nil, repeats: false)
			
		} else if flagLink
		{
			self.flagLink = false
			self.link.isHidden = true
			self.link.removeAllActions()
			self.healthBarLink.removeAllActions()
			self.boss.removeAllActions()
			self.link.position = CGPoint(x: 1000, y: 1000)
			self.healthBarLink.isHidden = true
			timer = nil
			timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(createLink), userInfo: nil, repeats: false)
		}
	}
	
	// run initialization functions on didMove()
	
	func initFunctions() {
		setUpScaleAndNodes()
		createTiles()
		initializeGame()
	}
	
	//create bipin text box
	func createTextBox(_ inputText:String, _ textBoxName: String, _ textBoxPosition: CGPoint)
	{
		let textBoxSize = CGSize(width: self.frame.width/1.5, height: self.frame.height/8)
		
		let textboxImg = "textBox.png"
		let textBox = SKSpriteNode(texture: SKTexture(imageNamed: textboxImg))
		textBox.name = textBoxName
		textBox.size = textBoxSize
		textBox.position = textBoxPosition
		textBox.zPosition = 0
		textBox.alpha = 0.1
		movingNode.addChild(textBox)
		
		
		let text = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		text.text = inputText
		text.fontSize = 20*scale
		text.fontColor = SKColor.white
		text.verticalAlignmentMode = .center
		text.position = CGPoint(x: 0, y: 0)
		textBox.addChild(text)
		
		let fadeIn = SKAction.fadeIn(withDuration: 1)
		
		
		textBox.run(fadeIn)
		
	}
	
	//function to make an npc
	func createNpc(charName: String, name: String, position: CGPoint, sprite: inout Character)
	{
		//link code block
		sprite.name = charName
		sprite.position = position
		movingNode.addChild(sprite)
	}
	
	func playSound(name:String, filetype:String)
	{
		
		guard Bundle.main.url(forResource: name, withExtension: filetype) != nil
			
			else
		{
			print("url Not Found")
			return
		}
		
		selfNode.run(SKAction.playSoundFileNamed(name, waitForCompletion: true))
	}
}

