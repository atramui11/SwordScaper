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
		
		distanceBetweenTiles = self.frame.height/7*aspectRatio
		
	
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
	
	//this is to map the ingame item name String to the .png name String
	func addToInvDictionary(_ key:String, _ value:String)
	{invDictionary.updateValue(value, forKey: key)}
	
	@objc func initializeGame() {
		
		//mapping of named items in game to png file name
		addToInvDictionary(SKTexture(imageNamed: "tree").description, "cutLogs")
		addToInvDictionary(SKTexture(imageNamed: "gold_rock").description, "gold_rock")
		addToInvDictionary(SKTexture(imageNamed: "fishingSpot").description, "fish")
		addToInvDictionary(SKTexture(imageNamed: "blueSword").description, "blueSword")
		addToInvDictionary(SKTexture(imageNamed: "sword").description, "sword")

		
		background = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		background.size = CGSize(width: self.frame.width, height: self.frame.height)
		background.position = CGPoint(x: 0, y: 0)
		background.zPosition = -2
		movingNode.addChild(background)
		
		let size = CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		
		movingNode.addChild(monsterNode)
		movingNode.addChild(healthBarMovingNode)
		
		
		var link = Character(texture: SKTexture(imageNamed: "avatar"), size: size, attackSpd: 1)
		
		var boss = Character(texture: SKTexture(imageNamed: "monster.png"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		
		
		//healthBarLink = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		//healthBarBoss = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		createCharacter(charName: "link", name: "linkSword", position: CGPoint(x:0,y:0),sprite: &link, health: 100, healthBarName: "healthBarLink")
		
		
		var randomX = Int.random(in: 1...columnNumber)
		var randomY = Int.random(in: 1...rowNumber*2+1)
		var randomPoint = getCGPointAtPosition(x: randomX, y: randomY)
		link.addAttackXP(amount: 10000)
		link.addStrengthXP(amount: 10000)
		link.autoRetaliate = false
		createMonster(name: "boss", weaponName: "sword", position: CGPoint(x:randomPoint.x,y:randomPoint.y), sprite: &boss, health: 100, healthBarName: "boss")
		randomX = Int.random(in: 1...columnNumber)
		randomY = Int.random(in: 1...rowNumber*2+1)
		randomPoint = getCGPointAtPosition(x: randomX, y: randomY)
		var boss2 = Character(texture: SKTexture(imageNamed: "monster.png"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		createMonster(name: "boss2", weaponName: "sword", position: CGPoint(x:randomPoint.x,y:randomPoint.y), sprite: &boss2, health: 100, healthBarName: "boss2")
		randomX = Int.random(in: 1...columnNumber)
		randomY = Int.random(in: 1...rowNumber*2+1)
		//randomPoint = getCGPointAtPosition(x: randomX, y: randomY)

		//var boss3 = Character(texture: SKTexture(imageNamed: "witch1"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		//createMonster(name: "witch", weaponName: "sword", position: CGPoint(x:randomPoint.x,y:randomPoint.y), sprite: &boss3, health: 100, healthBarName: "witch")
		randomX = Int.random(in: 1...columnNumber)
		randomY = Int.random(in: 1...rowNumber*2+1)
		//randomPoint = getCGPointAtPosition(x: randomX, y: randomY)

		//var boss4 = Character(texture: SKTexture(imageNamed: "thwomp1"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		//createMonster(name: "thwomp", weaponName: "sword", position: CGPoint(x:randomPoint.x,y:randomPoint.y), sprite: &boss4, health: 100, healthBarName: "thwomp")
		
		//pointer block
		pointer = SKSpriteNode()
		pointer.size = CGSize(width: self.frame.width/10/iconScale, height: self.frame.width/10/iconScale)
		pointer.position = CGPoint(x: 0, y: 0)
		pointer.zPosition = 1
		stationaryNode.addChild(pointer)
		
		
		let yPos2 = -self.frame.height/2.2 + self.frame.height/6*aspectRatio/2
		let yPos1 = yPos2 + self.frame.height/6*aspectRatio/2+self.frame.height/6*aspectRatio/2
		
		createPage(name: "attackPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/6*aspectRatio), position:  CGPoint(x: -self.frame.width/8, y: yPos1), withLabels: true, alpha: 1)
		createPage(name: "combatStylePage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/6*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yPos2), withLabels: false, alpha: 1)
		
		
		
		let xMenu = self.frame.width/2-self.frame.width/8/iconScale
		let yMenu = -self.frame.height/2+self.frame.height/3*aspectRatio
		createMenuBackground(name: "menuBackgroundPage", size: CGSize(width: self.frame.width/4.5/iconScale, height: self.frame.height/1.8*aspectRatio), position: CGPoint(x: xMenu, y: yMenu))
		createMenu(name: "menuPage", size: CGSize(width: self.frame.width/4/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: xMenu, y: yMenu))
		createPage(name: "skillsPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu), withLabels: false, alpha: 1)
		createPage(name: "inventoryPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu), withLabels: false, alpha: 1)
		
		createPage(name: "bankPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu+self.frame.height/2), withLabels: false, alpha: 1)
			createPage(name: "furnacePage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu+self.frame.height/2), withLabels: false, alpha: 1)
		createPage(name: "anvilPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu+self.frame.height/2), withLabels: false, alpha: 1)
		createPage(name: "fletchPage", size: CGSize(width: self.frame.width*3/5/iconScale, height: self.frame.height/2*aspectRatio), position: CGPoint(x: -self.frame.width/8, y: yMenu+self.frame.height/2), withLabels: false, alpha: 1)

		movingNode.addChild(bankNode)
		movingNode.addChild(furnaceNode)
		movingNode.addChild(rocksNode)
        movingNode.addChild(woodCuttingNode)
        movingNode.addChild(fishingNode)
        //movingNode.addChild(monsterNode)
        movingNode.addChild(anvilNode)

        /*
		let bank = SKSpriteNode(imageNamed: "bankChest")
		bank.size =  CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		bank.name = "bank1"
		bank.position = getCGPointAtPosition(x: columnNumber/2, y: rowNumber)
		bank.zPosition = 1
		bankNode.addChild(bank)
		
		//furnace code
		let furnace = SKSpriteNode(imageNamed: "furnace")
		furnace.size =  CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		furnace.name = "bank1"
		furnace.position = getCGPointAtPosition(x: columnNumber/4, y: rowNumber)
		furnace.zPosition = 1
		furnaceNode.addChild(furnace)
		
		//anvil code
		let anvil = SKSpriteNode(imageNamed: "anvil")
		anvil.size =  CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		anvil.name = "anvil1"
		anvil.position = getCGPointAtPosition(x: columnNumber/4, y: rowNumber+1)
		anvil.zPosition = 1
		anvilNode.addChild(anvil)
        */
		
		
	}
	
	func populateObstacleArray() {
		// populate obstace array
		var objectArray:[SKSpriteNode]! = []
		obstacleArray = []
		for rock in rocksNode.children as! [SKSpriteNode] {
			objectArray.append(rock)
		}
		for fishingSpot in fishingNode.children as! [SKSpriteNode] {
			objectArray.append(fishingSpot)
		}
		for tree in woodCuttingNode.children as! [SKSpriteNode] {
			objectArray.append(tree)
		}
		for bank in bankNode.children as! [SKSpriteNode] {
			objectArray.append(bank)
		}
		for furnace in furnaceNode.children as! [SKSpriteNode] {
			objectArray.append(furnace)
		}
		for anvil in anvilNode.children as! [SKSpriteNode] {
			objectArray.append(anvil)
		}
		for tile in tileNode?.children as! [SKSpriteNode] {
			for obstacle in objectArray {
				if tile.contains(obstacle.position) {
					obstacleArray.append(tile)
				}
			}
		}
	}
	
	func stopMonster() {
		for monster in monsterNode.children as! [Character] {

			let monsterLocation = CGPoint(x: monster.position.x, y: monster.position.y)
			for tile in obstacleArray
			{
				if tile.contains(monsterLocation) && !monster.isBouncing
				{
					monster.isBouncing = true
					var minTile: SKSpriteNode!
					let adjTiles = getAdjacentTiles(tile: tile)
					//print (tile)
					//print (adjTiles)
					var pythagDistance:CGFloat = distanceBetweenTiles*2
					for tile in adjTiles {
						let dist = pow((pow(monsterLocation.x-tile.position.x,2) + pow(monsterLocation.y-tile.position.y,2)), 0.5)
						
						if dist < pythagDistance && !obstacleArray.contains(tile)
						{
							minTile = tile
							pythagDistance = dist
						}
					}
					let movePosition = CGPoint(x: minTile.position.x, y: minTile.position.y)
					
					bounceMonster(location: movePosition, monsterName: monster.name!)
				}
			}
		}
	}
	
	func stopLink() {
		let linkLocation = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
		for tile in obstacleArray
		{
			if tile.contains(linkLocation) && clickInitiated
			{
				clickInitiated = false
				var minTile: SKSpriteNode!
				let adjTiles = getAdjacentTiles(tile: tile)
				//print (tile)
				//print (adjTiles)
				var pythagDistance:CGFloat = distanceBetweenTiles*2
				for tile in adjTiles {
					let dist = pow((pow(linkLocation.x-tile.position.x,2) + pow(linkLocation.y-tile.position.y,2)), 0.5)
					
					if dist < pythagDistance && !obstacleArray.contains(tile)
					{
						minTile = tile
						pythagDistance = dist
					}
				}
				let movePosition = CGPoint(x: minTile.position.x+movingNode.position.x, y: minTile.position.y+movingNode.position.y)
				bounceLink(location: movePosition, attackMode: "none")
			}
		}
	}
	
	
	func createMenuBackground(name: String, size: CGSize, position: CGPoint) {
		let page = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		page.size = size
		page.name = name
		page.position = position
		page.alpha = 0.7
		page.zPosition = 1
		stationaryNode.addChild(page)
	}
	
	func createMenu(name: String, size: CGSize, position: CGPoint) {
		var page = SKSpriteNode()
		page.size = size
		page.name = name
		page.position = position
		page.zPosition = 1
		stationaryNode.addChild(page)
		
		createButtonWithoutLabelsY(page: &page, name: "combatButton", yPosition: -page.size.height/3, image: "combat")
		createButtonWithoutLabelsY(page: &page, name: "skillsButton", yPosition: 0, image: "skills")
		createButtonWithoutLabelsY(page: &page, name: "inventoryButton", yPosition: page.size.height/3, image: "inventory")
		
		
	}
	
	func createMonster(name: String, weaponName: String, position: CGPoint, sprite: inout Character, health: Int, healthBarName: String)
	{
		sprite.name = name
		sprite.position = position
		
		sprite.name = name
		sprite.position = position
		
		let healthBar = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage"))
		healthBar.size = CGSize(width: sprite.size.width, height: sprite.size.width/3)
		healthBar.position = CGPoint(x: sprite.position.x, y: sprite.position.y+sprite.size.height)
		healthBar.zPosition = 0
		healthBar.name = healthBarName
		
		monsterNode.addChild(sprite)
		
		healthBarMovingNode.addChild(healthBar)
		
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
		
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		healthBar.run(fadeOut)

		
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
		
		
		let sword = SKSpriteNode(texture: SKTexture(imageNamed: "sword"))
		sword.name = weaponName
		sword.size = CGSize(width: sprite.size.width/3, height: sprite.size.width)
		sword.position = CGPoint(x: sprite.size.width/3, y: 0)
		sword.anchorPoint = CGPoint(x: 0.5, y: 0)
		
		
		sword.zPosition = 0
		
		sprite.addChild(sword)
		//sword.run(fadeOut)
		
		
		
		var imgListArray :[SKTexture] = []
		sprite.alpha = 1
		
		//temporarily cant get the other images
		if name == "ganon" || name == "twinrova" || name == "dragon" {return}
		
		if name == "thwomp" || name == "witch" {
			for countValue in 1...3
			{
				let strImageName : String = name + String(countValue)
				let texture  = SKTexture(imageNamed: strImageName)
				
				imgListArray.append(texture)
				
			}
			
			let animateMonster = SKAction.animate(with: imgListArray, timePerFrame: 0.5)
			
			sprite.run(SKAction.repeatForever(animateMonster))
		}
		
		
		let temp = sprite
		
		temp.isRandomWalking = true
		let moveAction = SKAction.run {
			let randMove = self.randomMove(monsterName: temp.name!)
			let time:TimeInterval = 0.8
			temp.zRotation = atan2((-randMove.y+temp.position.y),(-randMove.x+temp.position.x)) + CGFloat.pi/2
			temp.run(SKAction.move(to: randMove, duration: time))
			var yMove = randMove.y
			yMove += temp.size.height*2/3
			healthBar.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
			
		}
		let wait = SKAction.wait(forDuration: 3.0)
		let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait,moveAction]))
		temp.run(randomMoveSequence, withKey: "randomMoveSequence")
		
		//sprite.run(randomMoveSequence)
		//healthBar.run(randomHealthMoveSequence)
		
	}
	
	
	
	func createButton(page: inout SKSpriteNode, name: String, xPosition: CGFloat, xpLabelName: String, lvlLabelName: String, image: String, xp: Int, Lvl: Int) {
		//let yPos3 = 0
		
		let button = SKSpriteNode(texture: SKTexture(imageNamed: image))
		button.size = CGSize(width: self.frame.height/5.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		//		let yPos = -button.size.height*6/7
		//		let yPos2 = -button.size.height*3/2
		button.position = CGPoint(x: xPosition, y: 0)
		button.name = name
		button.zPosition = 1
		page.addChild(button)
		
	}
	
	func createButtonWithoutLabels(page: inout SKSpriteNode, name: String, xPosition: CGFloat, image: String) {
		
		let button = SKSpriteNode(texture: SKTexture(imageNamed: image))
		button.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		
		button.position = CGPoint(x: xPosition, y: 0)
		button.name = name
		button.zPosition = 1
		page.addChild(button)
	}
	
	func createButtonWithoutLabelsY(page: inout SKSpriteNode, name: String, yPosition: CGFloat, image: String) {
		
		let outline = SKSpriteNode(texture: SKTexture(imageNamed: "scrabbleTile.png"))
		outline.size = CGSize(width: self.frame.height/7*aspectRatio, height: self.frame.height/7*aspectRatio)
		outline.position = CGPoint(x: 0, y: yPosition)
		outline.alpha = 0.8
		outline.name = name
		outline.zPosition = 1
		page.addChild(outline)
		
		
		let button = SKSpriteNode(texture: SKTexture(imageNamed: image))
		button.size = CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio)
		
		button.position = CGPoint(x: 0, y: 0)
		//button.name = name
		button.zPosition = 1
		outline.addChild(button)
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
	
	func getSkillsPanel(skillName: String)->SKSpriteNode
	{
		let skillsPage = stationaryNode.childNode(withName: "skillsPage") as! SKSpriteNode
		var panel:SKSpriteNode!
		
		if skillName == "attack"
		{
			panel = skillsPage.childNode(withName: "43") as? SKSpriteNode
		}
			
		else if skillName == "strength"
		{
			panel = skillsPage.childNode(withName: "42") as? SKSpriteNode
		}
			
		else if skillName == "defense"
		{
			panel = skillsPage.childNode(withName: "41") as? SKSpriteNode
		}
			
		else if skillName == "hp"
		{
			panel = skillsPage.childNode(withName: "33") as? SKSpriteNode
		}
			
		else if skillName == "ranged"
		{
			panel = skillsPage.childNode(withName: "32") as? SKSpriteNode
		}
			
		else if skillName == "magic"
		{
			panel = skillsPage.childNode(withName: "31") as? SKSpriteNode
		}
			
		else if skillName == "slayer"
		{
			panel = skillsPage.childNode(withName: "23") as? SKSpriteNode
		}
			
		else if skillName == "mining"
		{
			panel = skillsPage.childNode(withName: "22") as? SKSpriteNode
		}
			
		else if skillName == "woodcutting"
		{
			panel = skillsPage.childNode(withName: "21") as? SKSpriteNode
		}
			
		else if skillName == "smithing"
		{
			panel = skillsPage.childNode(withName: "13") as? SKSpriteNode
		}
			
		else if skillName == "fishing"
		{
			panel = skillsPage.childNode(withName: "12") as? SKSpriteNode
		}
			
		else if skillName == "fletching"
		{
			panel = skillsPage.childNode(withName: "11") as? SKSpriteNode
		}
		return panel
		
	}
	
	func createStorage(page: inout SKSpriteNode) {
		//make 4x3 grid
		let yArray = [-3,-1,1,3]
		let xArray = [-3,-1,1,3]
		
		for i in 0...yArray.count-1
		{
			let y = page.size.height * CGFloat(yArray[i])/8
			
			for j in 0...xArray.count-1
			{
				//panel in grid
				var panelTextureString = ""
				let pageName = page.name
				if (i == 0 && j == xArray.count-1 && pageName == "furnacePage") {panelTextureString = "button"}
				else {panelTextureString = "backgroundImage"}
				let panelTexture = SKTexture(imageNamed: panelTextureString)

				let inventoryPanel = SKSpriteNode(texture: panelTexture)
				let x = page.size.width * CGFloat(xArray[j])/8
				inventoryPanel.position = CGPoint(x: x, y: y)
				inventoryPanel.size = CGSize(width: page.size.width/4*9.5/10, height: page.frame.height/4*9.2/10)
				inventoryPanel.name = "\(i+1)\(j+1)"
				page.addChild(inventoryPanel)
				
				
				
				//level and percent labels
				let countLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
				countLabel.text = ""
				countLabel.name = "countLabel"
				countLabel.position = CGPoint(x: inventoryPanel.size.width/20, y: inventoryPanel.size.height/8)
				countLabel.horizontalAlignmentMode = .left
				countLabel.fontSize = scale*10
				countLabel.fontColor = .black
				
				inventoryPanel.addChild(countLabel)
				
			}
			
			
		}
	}
	
	func createPage(name: String, size: CGSize, position: CGPoint, withLabels: Bool, alpha: CGFloat){
		var page = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		page.alpha = alpha
		page.size = size
		page.name = name
		page.position = position
		// page.anchorPoint = CGPoint(x: 0.5, y: 0)
		page.zPosition = 1
		hidePage(page: &page)
		stationaryNode.addChild(page)
		
		if withLabels
		{
			if name == "attackPage"
			{
				 let link = stationaryNode.childNode(withName: "link") as! Character
				createButton(page: &page, name: "attackButton", xPosition: -page.size.width/3, xpLabelName: "attackXPLabel", lvlLabelName: "attackLvlLabel", image: "stab", xp: link.attackXP, Lvl: link.getAttackLVL())
				createButton(page: &page, name: "strengthButton", xPosition: 0, xpLabelName: "strengthXPLabel", lvlLabelName: "strengthLvlLabel", image: "slashOn", xp: link.strengthXP, Lvl: link.getStrLvl())
				createButton(page: &page, name: "defenseButton", xPosition: page.size.width/3, xpLabelName: "defenseXPLabel", lvlLabelName: "defenseLvlLabel", image: "block", xp: link.defenseXP, Lvl: link.getDefLvl())
			}
			
		}
			
		else if name == "inventoryPage"
		{
			createStorage(page: &page)
		}
		else if name == "bankPage" {
			createStorage(page: &page)
		}
		else if name == "furnacePage" {
			createStorage(page: &page)
			
			//page.addChild(button) //this prevents items from showing up in furnace
		}
		else if name == "anvilPage" {
			createAnvilMenu(page: &page)
		}
		else if name == "fletchPage" {
			createFletchMenu(page: &page)
		}
		else if name == "skillsPage"
		{
			//make 4x3 grid
			let yArray = [-3,-1,1,3]
			let xArray = [-1,0,1]
			let textureNameArray = ["fletching","fishing","smithing","woodcutting","mining","slayer","magic","ranged", "hp","defense","strength","attack"]
			var count = 0
			
			for i in 0...yArray.count-1
			{
				
				let y = page.size.height * CGFloat(yArray[i])/8
				
				for j in 0...xArray.count-1
				{
					//panel in grid
					let skillsPanel = SKSpriteNode(texture: SKTexture(imageNamed: "scrabbleTile"))
					let x = page.size.width * CGFloat(xArray[j])/3
					skillsPanel.position = CGPoint(x: x, y: y)
					skillsPanel.size = CGSize(width: page.size.width/3*9.5/10, height: page.frame.height/4*9.2/10)
					skillsPanel.name = "\(i+1)\(j+1)"
					page.addChild(skillsPanel)
					
					//pickaxe, skull, swords etc
					let skillsIcon = SKSpriteNode(texture: SKTexture(imageNamed: textureNameArray[count]))
					skillsIcon.position = CGPoint(x:-skillsPanel.size.width/5, y:0)
					skillsIcon.size = CGSize(width: skillsPanel.size.width*3/8, height: skillsPanel.size.height * 2/3)
					
					skillsPanel.addChild(skillsIcon)
					
					//level and percent labels
					let levelLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
					levelLabel.text = "LVL: 1"
					levelLabel.name = "levelLabel"
					levelLabel.position = CGPoint(x: skillsPanel.size.width/20, y: skillsPanel.size.height/8)
					levelLabel.horizontalAlignmentMode = .left
					levelLabel.fontSize = scale*10
					levelLabel.fontColor = .black
					
					let percentLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
					percentLabel.text = "112"
					percentLabel.name = "percentLabel"
					percentLabel.position = CGPoint(x: skillsPanel.size.width/20, y: -skillsPanel.size.height/3.5)
					percentLabel.horizontalAlignmentMode = .left
					percentLabel.fontSize = scale*10
					percentLabel.fontColor = .black
					
					skillsPanel.addChild(levelLabel)
					skillsPanel.addChild(percentLabel)
					
					count += 1 //next skill icon
				}
				
				
			}
			
		}
			
		else if name == "combatStylePage"
		{
			
			createButtonWithoutLabels(page: &page, name: "meleeButton", xPosition: -page.size.width/3, image: "meleeOn")
			createButtonWithoutLabels(page: &page, name: "rangedButton", xPosition: 0, image: "archery")
			createButtonWithoutLabels(page: &page, name: "magicButton", xPosition: page.size.width/3, image: "magicOff")
		}
		
	}
	
	
	
	@objc func reviveMonster(timer: Timer) {
		let monsterName = timer.userInfo as! String
		let boss = monsterNode.childNode(withName: monsterName) as! Character
		
		boss.deadFlag = false
		let healthBarBoss = healthBarMovingNode.childNode(withName: monsterName) as! SKSpriteNode

		boss.isHidden = false
		let randomX = Int.random(in: columnNumber*3/8...columnNumber*5/8)
		let randomY = Int.random(in: rowNumber...rowNumber*3/2+1)
		let randomPoint = getCGPointAtPosition(x: randomX, y: randomY)
		boss.position = CGPoint(x:randomPoint.x,y:randomPoint.y)
		
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		healthBarBoss.run(fadeOut)
		
		var y1 = boss.position.y
		y1 += boss.size.height*2/3
		healthBarBoss.position = CGPoint(x:boss.position.x, y: y1)
		let leftBar = healthBarBoss.childNode(withName: "barLeft") as! SKSpriteNode
		let barHeight = healthBarBoss.size.height*9/10
		let barLeftWidth = healthBarBoss.size.width*19/20
		leftBar.size = CGSize(width: barLeftWidth, height:  barHeight)
		let rightBar = healthBarBoss.childNode(withName: "barRight") as! SKSpriteNode
		rightBar.size = CGSize(width: 0, height:  barHeight)
		
		// randomWalk
		boss.removeAllActions()
		healthBarBoss.removeAllActions()
		boss.isRandomWalking = true
		let moveAction = SKAction.run {
			let randMove = self.randomMove(monsterName: monsterName)
			let time:TimeInterval = 0.8
			boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
			boss.run(SKAction.move(to: randMove, duration: time))
			var yMove = randMove.y
			yMove += boss.size.height*2/3
			healthBarBoss.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
			
		}
		let wait = SKAction.wait(forDuration: 3.0)
		let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait,moveAction]))
		boss.run(randomMoveSequence, withKey: "randomMoveSequence")
	}
	
	@objc func reviveLink() {
		let link = stationaryNode.childNode(withName: "link") as! Character
		link.deadFlag = false
		let healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as! SKSpriteNode
		link.isHidden = false
		link.position = CGPoint(x:0,y:0)
		healthBarLink.isHidden = false
		let yPos = link.size.height*2/3
		healthBarLink.position = CGPoint(x:link.position.x, y: link.position.y+yPos)
		let leftBar = healthBarLink.childNode(withName: "barLeft") as! SKSpriteNode
		let barHeight = healthBarLink.size.height*9/10
		let barLeftWidth = healthBarLink.size.width*19/20
		leftBar.size = CGSize(width: barLeftWidth, height:  barHeight)
		let rightBar = healthBarLink.childNode(withName: "barRight") as! SKSpriteNode
		rightBar.size = CGSize(width: 0, height:  barHeight)
	}
	
	func createCharacter(charName: String, name: String, position: CGPoint, sprite: inout Character, health: Int, healthBarName: String) {
		//link code block
		sprite.name = charName
		sprite.position = position
		
		let healthBar = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		healthBar.name = healthBarName
		healthBar.size = CGSize(width: sprite.size.width, height: sprite.size.width/3)
		healthBar.position = CGPoint(x: sprite.position.x, y: sprite.position.y+sprite.size.height*3/4)
		healthBar.zPosition = 0
		stationaryNode.addChild(sprite)
		stationaryNode.addChild(healthBar)
		
		
		
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
		sword.position = CGPoint(x: sprite.size.width/3, y: -sprite.size.height/10)
		sword.anchorPoint = CGPoint(x: 0.5, y: 0)
		sword.run(colorizeTier(tier: 1))

		sword.zPosition = 0
		
		sprite.addChild(sword)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		//sword.run(fadeOut)
		healthBar.run(fadeOut)

		
		let yPos = -sprite.size.height*3/4
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
		
		/*
		let bow = SKSpriteNode(texture: SKTexture(imageNamed: "bow"))
		bow.name = "bow"
		bow.size = CGSize(width: sprite.size.width, height: sprite.size.width)
		bow.position = CGPoint(x: sprite.size.width/2, y: -sprite.size.height/8)
		bow.anchorPoint = CGPoint(x: 0.5, y: 0)
		bow.zPosition = 1
		sprite.addChild(bow)
		bow.run(fadeOut)
		*/
		let arrow = SKSpriteNode(texture: SKTexture(imageNamed: "arrow"))
		arrow.name = "arrow"
		arrow.size = CGSize(width: sprite.size.width, height: sprite.size.width)
		arrow.position = CGPoint(x: 0, y: 0)
		arrow.anchorPoint = CGPoint(x: 0.5, y: 0)
		arrow.zPosition = 1
		sprite.addChild(arrow)
		arrow.run(fadeOut)
		/*
		let staff = SKSpriteNode(texture: SKTexture(imageNamed: "staff"))
		staff.name = "staff"
		staff.size = CGSize(width: sprite.size.height*5/12, height: sprite.size.height)
		staff.position = CGPoint(x: sprite.size.width/2, y: 0)
		staff.anchorPoint = CGPoint(x: 0.5, y: 0)
		staff.zPosition = 1
		sprite.addChild(staff)
		*/
		let fireBall = SKSpriteNode(texture: SKTexture(imageNamed: "fireBall"))
		fireBall.name = "fireBall"
		fireBall.size = CGSize(width: sprite.size.width*2/3, height: sprite.size.width*2/3)
		fireBall.position = CGPoint(x: 0, y: 0)
		fireBall.anchorPoint = CGPoint(x: 0.5, y: 0)
		
		fireBall.zPosition = 1
		
		sprite.addChild(fireBall)
		//staff.run(fadeOut)
		fireBall.run(fadeOut)
		
		
	}
	
	
	// create game tiles for each row and column
	
	func createTiles(tileName: String)
	{
		let oddOrEvenNumX = CGFloat((columnNumber+1) % 2)
		let oddOrEvenNumY = CGFloat((rowNumber*2+1) % 2)
		let midWayNumX = Int((CGFloat(columnNumber)/2+0.1).rounded())
		let midWayNumY = Int((CGFloat(rowNumber)+0.1).rounded())
		//print (midWayNumY)
		for xIndex in 0...columnNumber+1
		{
			for yIndex in 0...rowNumber*2+2
			{
				let xPosition = distanceBetweenTiles*CGFloat(xIndex-midWayNumX)
				let yPosition = distanceBetweenTiles*CGFloat(yIndex-midWayNumY)
				let xOffSet = distanceBetweenTiles*0.5*oddOrEvenNumX
				let yOffSet = distanceBetweenTiles*0.5*oddOrEvenNumY
				let calc1 = -yOffSet+yPosition
				let calculation =  calc1-distanceBetweenTiles/2
				makeTileNodes(NodeLocation: CGPoint(x: -xOffSet+xPosition, y: calculation), randomNumber: 0, tile: tileName)
			}
		}
	}
	
	
	// function called to create each tile
	func makeTileNodes(NodeLocation: CGPoint, randomNumber: Int, tile: String) {
		
		let tileSize = self.frame.height/7*aspectRatio
		let numberTile = SKSpriteNode(texture: SKTexture(imageNamed: tile))
		numberTile.name = "numberTileTexture"
		numberTile.size = CGSize(width: tileSize, height: tileSize)
		numberTile.position = NodeLocation
		numberTile.zPosition = 0
		tileNode!.addChild(numberTile)
		
	}
	
	
	
	func stabAction(sprite: inout Character) -> SKAction {
		
		//let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let stab = SKAction.moveBy(x: 0, y: sprite.size.width/4, duration: 0.05)
		let wait = SKAction.wait(forDuration: 0.1)
		//let fadeOut = SKAction.fadeOut(withDuration: 0.1)
		let moveBack = SKAction.moveBy(x: 0, y: -sprite.size.width/4, duration: 0)
		let stabSequence = SKAction.sequence([stab,wait,moveBack])
		return stabSequence
	}
	
	func slashAction(sprite: inout Character) -> SKAction {
		
		//let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let swipe = SKAction.moveBy(x: -sprite.size.width/2, y: 0, duration: 0.2)
		//let fadeOut = SKAction.fadeOut(withDuration: 0)
		let moveBack = SKAction.moveBy(x: sprite.size.width/2, y: 0, duration: 0)
		let rotateStart = SKAction.rotate(toAngle: -CGFloat.pi/6, duration: 0)
		let rotate = SKAction.rotate(toAngle: CGFloat.pi/6, duration: 0.2)
		let rotateBack = SKAction.rotate(toAngle: 0, duration: 0)
		let group = SKAction.group([swipe,rotate])
		let swipeSequence = SKAction.sequence([rotateStart,group,rotateBack,moveBack])
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
		//		let attackPage = stationaryNode.childNode(withName: "attackPage") as! SKSpriteNode
		//		let rangedPage = stationaryNode.childNode(withName: "rangedPage") as! SKSpriteNode
		//		let magicPage = stationaryNode.childNode(withName: "magicPage") as! SKSpriteNode
		
		if meleeOn
		{
			if stabOn
			{
				character.addAttackXP(amount: hitAmount*4)
				let levelLabel = getSkillsPanel(skillName: "attack").childNode(withName: "levelLabel") as! SKLabelNode
				levelLabel.text = "LVL: "+String(character.getAttackLVL())
				let percentLabel = getSkillsPanel(skillName: "attack").childNode(withName: "percentLabel") as! SKLabelNode
				percentLabel.text = String(character.getxpToNextLevel(xp: character.attackXP, lvl: character.getAttackLVL()))
			}
			else if slashOn
			{
				character.addStrengthXP(amount: hitAmount*4)
				let levelLabel = getSkillsPanel(skillName: "strength").childNode(withName: "levelLabel") as! SKLabelNode
				
				levelLabel.text = "LVL: "+String(character.getStrLvl())
				let percentLabel = getSkillsPanel(skillName: "strength").childNode(withName: "percentLabel") as! SKLabelNode
				percentLabel.text = String(character.getxpToNextLevel(xp: character.strengthXP, lvl: character.getStrLvl()))
				
			}
			else if blockOn
			{
				character.addDefenseXP(amount: hitAmount*4)
				let levelLabel = getSkillsPanel(skillName: "defense").childNode(withName: "levelLabel") as! SKLabelNode
				levelLabel.text = "LVL: "+String(character.getDefLvl())
				let percentLabel = getSkillsPanel(skillName: "defense").childNode(withName: "percentLabel") as! SKLabelNode
				percentLabel.text = String(character.getxpToNextLevel(xp: character.defenseXP, lvl: character.getDefLvl()))
			}
		}
		else if rangedOn
		{
			character.addRangedXP(amount: hitAmount*4)
			let levelLabel = getSkillsPanel(skillName: "ranged").childNode(withName: "levelLabel") as! SKLabelNode
			levelLabel.text = "LVL: "+String(character.getRangedLvl())
			let percentLabel = getSkillsPanel(skillName: "ranged").childNode(withName: "percentLabel") as! SKLabelNode
			percentLabel.text = String(character.getxpToNextLevel(xp: character.rangedXP, lvl: character.getRangedLvl()))
			
		}
		else if magicOn
		{
			character.addMagicXP(amount: hitAmount*4)
			let levelLabel = getSkillsPanel(skillName: "magic").childNode(withName: "levelLabel") as! SKLabelNode
			levelLabel.text = "LVL: "+String(character.getMagicLvl())
			let percentLabel = getSkillsPanel(skillName: "magic").childNode(withName: "percentLabel") as! SKLabelNode
			percentLabel.text = String(character.getxpToNextLevel(xp: character.magicXP, lvl: character.getMagicLvl()))
		}
		character.addhpXP(amount: hitAmount)
		let levelLabel = getSkillsPanel(skillName: "hp").childNode(withName: "levelLabel") as! SKLabelNode
		levelLabel.text = "LVL: "+String(character.getHpLvl())
		let percentLabel = getSkillsPanel(skillName: "hp").childNode(withName: "percentLabel") as! SKLabelNode
		percentLabel.text = String(character.getxpToNextLevel(xp: character.hpXP, lvl: character.getHpLvl()))
	}
	
	// change health bar and health stat as needed
	func modifyHealthOnHit(character: inout Character, healthBar: inout SKSpriteNode, hitAmount: Int) {
		let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
		box.removeAllActions()
		let barLeft = healthBar.childNode(withName: "barLeft") as! SKSpriteNode
		let barRight = healthBar.childNode(withName: "barRight") as! SKSpriteNode
		let charHP = CGFloat(character.getHP())
		let BoxLabel = box.children[0] as! SKLabelNode
		BoxLabel.text = String(hitAmount)
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
		let escapeCharacter = character
		let removeHealth = SKAction.run({
			let originalHealth = box.size.width*19/20
			var decreaseAmount = originalHealth/charHP*CGFloat(hitAmount)
			if barLeft.size.width-decreaseAmount < 0 {
				decreaseAmount = barLeft.size.width
			}
			if barRight.size.width+decreaseAmount > originalHealth {
				decreaseAmount = originalHealth-barRight.size.width
			}
			barLeft.size = CGSize(width: barLeft.size.width-decreaseAmount, height: barLeft.size.height)
			barRight.size = CGSize(width: barRight.size.width+decreaseAmount, height: barRight.size.height)
			if barLeft.size.width < 0.1 {
				escapeCharacter.deadFlag = true
			}
		})
		let hitSequence = SKAction.sequence([wait1,fadeIn,removeHealth,wait2,fadeOut])
		box.run(hitSequence)
	}
	func modifyHealthOnMiss(healthBar: inout SKSpriteNode) {
		let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
		box.removeAllActions()
	}
	
	
	
	func determineHit(attackStyle: String, character: inout Character, healthBar: inout SKSpriteNode!, monsterName: String) {
		var link = stationaryNode.childNode(withName: "link") as! Character
		var monster = monsterNode.childNode(withName: monsterName) as! Character

		var otherCharDefense:Int = 0
		if character.name == "link"
		{
			otherCharDefense = monster.getDefLvl()
		}
		else
		{
			otherCharDefense = link.getEffectiveLvl(combatParam: "defense")
		}
		let hitChance = character.hitChance(combatStyle: attackStyle, enemyDefenceLvl: otherCharDefense)
		let hitAmount = character.hitAmount(combatStyle: attackStyle)
		if hitChance > 10
		{
			if character.name == "link"
			{
				addXpAndChangeLabels(character: &character, hitAmount: hitAmount)
				modifyHealthOnHit(character: &monster, healthBar: &healthBar, hitAmount: hitAmount)
			} else {
				modifyHealthOnHit(character: &link, healthBar: &healthBar, hitAmount: hitAmount)
			}
		}
		else
		{
			modifyHealthOnMiss(healthBar: &healthBar)
		}
	}
	
	// orient Link, determine attack type, animate attack
	
	func runCombatLink(monsterName: String){
		
		var link = stationaryNode.childNode(withName: "link") as! Character
		let boss = monsterNode.childNode(withName: monsterName) as! Character
		var healthBarBoss = healthBarMovingNode.childNode(withName: monsterName) as? SKSpriteNode
		let healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as! SKSpriteNode

		
		healthBarLink.run(SKAction.fadeIn(withDuration: 0))
		
		let bossPositionX = boss.position.x+movingNode.position.x
		let bossPositionY = boss.position.y+movingNode.position.y
		link.zRotation = atan2((link.position.y-bossPositionY),(link.position.x-bossPositionX)) + CGFloat.pi/2
		link.attacking = true
		var action = slashAction(sprite: &link)
		var attackStyle = "melee"
		if meleeOn
		{
			let sword = link.childNode(withName: "linkSword") as! SKSpriteNode
			if blockOn || stabOn
			{
				action = stabAction(sprite: &link)
			}
			sword.run(action, completion:
				{
					let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
					sword.run((wait1), completion:
						{
							link.attacking = false
					})
					self.determineHit(attackStyle: attackStyle, character: &link, healthBar: &healthBarBoss, monsterName: monsterName)
					healthBarLink.removeAction(forKey: "healthBar")
					let fadeOut = SKAction.fadeOut(withDuration: 0)
					let wait = SKAction.wait(forDuration: 3)
					let endCombat = SKAction.run({
						link.inCombat = false
					})
					let sequence = SKAction.sequence([wait,fadeOut,endCombat])
					
					healthBarLink.run(sequence, withKey: "healthBar")
					
			})
		}
		else if rangedOn
		{
			action = shootArrowAction(sprite: &link)
			attackStyle = "ranged"
			//let bow = link.childNode(withName: "bow") as! SKSpriteNode
			//bow.run(fadeInOut(sprite: &link))
			let arrow = link.childNode(withName: "arrow") as! SKSpriteNode
			
			arrow.run(action, completion:
				{
					let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
					arrow.run((wait1), completion:
						{
							link.attacking = false
					})
					self.determineHit(attackStyle: attackStyle, character: &link, healthBar: &healthBarBoss, monsterName: monsterName)
					healthBarLink.removeAction(forKey: "healthBar")
					let fadeOut = SKAction.fadeOut(withDuration: 0)
					let wait = SKAction.wait(forDuration: 3)
					let endCombat = SKAction.run({
						link.inCombat = false
					})
					let sequence = SKAction.sequence([wait,fadeOut,endCombat])
					healthBarLink.run(sequence, withKey: "healthBar")
			})
		} else if magicOn
		{
			action = shootArrowAction(sprite: &link)
			attackStyle = "magic"
			//let staff = link.childNode(withName: "staff") as! SKSpriteNode
			//staff.run(fadeInOut(sprite: &link))
			let fireBall = link.childNode(withName: "fireBall") as! SKSpriteNode
			
			fireBall.run(action, completion:
				{
					let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
					fireBall.run((wait1), completion:
						{
							link.attacking = false
					})
					self.determineHit(attackStyle: attackStyle, character: &link, healthBar: &healthBarBoss, monsterName: monsterName)
					healthBarLink.removeAction(forKey: "healthBar")
					let fadeOut = SKAction.fadeOut(withDuration: 0)
					let wait = SKAction.wait(forDuration: 3)
					let endCombat = SKAction.run({
						link.inCombat = false
					})
					let sequence = SKAction.sequence([wait,fadeOut,endCombat])
					healthBarLink.run(sequence, withKey: "healthBar")
			})
		}
		
	}
	
	// orient boss, animate attack
	
	func runCombatBoss(monsterName: String){
		var boss = monsterNode.childNode(withName: monsterName) as! Character
		let link = stationaryNode.childNode(withName: "link") as! Character
		var healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as? SKSpriteNode
		let healthBarBoss = healthBarMovingNode.childNode(withName: monsterName) as? SKSpriteNode
		healthBarBoss!.run(SKAction.fadeIn(withDuration: 0))


		let bossPositionX = boss.position.x+movingNode.position.x
		let bossPositionY = boss.position.y+movingNode.position.y
		boss.zRotation = atan2((bossPositionY-link.position.y),(bossPositionX-link.position.x)) + CGFloat.pi/2
		boss.attacking = true
		let sword = boss.childNode(withName: "sword") as! SKSpriteNode
		sword.run((slashAction(sprite: &boss)), completion:
			{
				let wait1 = SKAction.wait(forDuration: self.bossAttackSpeed)
				sword.run((wait1), completion:
					{
						boss.attacking = false
				})
				self.determineHit(attackStyle: "melee", character: &boss, healthBar: &healthBarLink, monsterName: monsterName)
				healthBarBoss!.removeAction(forKey: "healthBar")
				let fadeOut = SKAction.fadeOut(withDuration: 0)
				let wait = SKAction.wait(forDuration: 3)
				let sequence = SKAction.sequence([wait,fadeOut])
				healthBarBoss!.run(sequence, withKey: "healthBar")
		})
	}
	
	
	
	func runCombat(monsterName: String) {
		let boss = monsterNode.childNode(withName: monsterName) as! Character
		let link = stationaryNode.childNode(withName: "link") as! Character
		link.inCombat = true
		if !link.attacking
		{
			if self.skillingTimer != nil { self.skillingTimer.invalidate()}
			
			removeSkillTool(name: "pickaxe")
			removeSkillTool(name: "axe")
			removeSkillTool(name: "harpoon")
			runCombatLink(monsterName: monsterName)
		}
		if !boss.attacking
		{
			if self.skillingTimer != nil { self.skillingTimer.invalidate()}
			
			removeSkillTool(name: "pickaxe")
			removeSkillTool(name: "axe")
			runCombatBoss(monsterName: monsterName)
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
	
	
	func randomMove(monsterName: String)-> CGPoint {
		
		let boss = monsterNode.childNode(withName: monsterName) as! Character
		var nextMoveArray:[CGPoint] = []
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			let adjustedDist = distanceBetweenTiles*5/4
			let bossPositionX = boss.position.x
			let bossPositionY = boss.position.y
			if child.position != boss.position && (child.position.x >= bossPositionX-adjustedDist && child.position.x <= bossPositionX+adjustedDist) && (child.position.y >= bossPositionY-adjustedDist && child.position.y <= bossPositionY+adjustedDist) && (child.position.x == bossPositionX || child.position.y == bossPositionY) && (!obstacleArray.contains(child))
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
		return nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
	}
	
//	// random boss movement
//
//	@objc func randomWalk(timer: Timer) {
//		let monsterName = timer.userInfo as! String
//		let boss = monsterNode.childNode(withName: monsterName) as! Character
//		let healthBarBoss = healthBarMovingNode.childNode(withName: monsterName) as? SKSpriteNode
//
//		var nextMoveArray:[CGPoint] = []
//		for child in (tileNode?.children)! as! [SKSpriteNode]
//		{
//			let adjustedDist = distanceBetweenTiles*5/4
//			let bossPositionX = boss.position.x
//			let bossPositionY = boss.position.y
//			if child.position != boss.position && (child.position.x >= bossPositionX-adjustedDist && child.position.x <= bossPositionX+adjustedDist) && (child.position.y >= bossPositionY-adjustedDist && child.position.y <= bossPositionY+adjustedDist) && (child.position.x == bossPositionX || child.position.y == bossPositionY)
//			{
//				nextMoveArray.append(child.position)
//			}
//		}
//		if nextMoveArray.count == 0
//		{
//			for child in (tileNode?.children)! as! [SKSpriteNode]
//			{
//				let adjustedDist = distanceBetweenTiles*5/4
//				let bossPositionX = boss.position.x
//				let bossPositionY = boss.position.y
//				if child.position != boss.position && (child.position.x >= bossPositionX-adjustedDist && child.position.x <= bossPositionX+adjustedDist) && (child.position.y >= bossPositionY-adjustedDist && child.position.y <= bossPositionY+adjustedDist)
//				{
//					nextMoveArray.append(child.position)
//				}
//			}
//		}
//		let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
//		let time:TimeInterval = 0.8
//		let moveAction = SKAction.move(to: randMove, duration: time)
//		boss.run(moveAction)
//		boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
//		var yMove = randMove.y
//		yMove += boss.size.height*2/3
//		let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
//		healthBarBoss!.run(healthMoveAction)
//	}
	
	
	func getTierFromColor(color: UIColor)->Int {
		let rgbArray:[[CGFloat]] = [[200, 180, 164],[137, 142, 162],[153, 153, 153], [105, 155, 203], [113, 141, 222], [149, 223, 124], [200, 120, 80], [151, 113, 201], [217, 59, 64], [200, 184, 59]]
		
		for tier in 1...rgbArray.count {
			let tierColor = UIColor.init(red: rgbArray[tier-1][0]/255, green: rgbArray[tier-1][1]/255, blue: rgbArray[tier-1][2]/255, alpha: 1)
			if color.description == tierColor.description
			{
				return tier
			}
		}
		return 0
	}
	
	func colorizeTier(tier: Int)->SKAction
	{
		var colorize: SKAction!
		
		let rgbArray:[[CGFloat]] = [[200, 180, 164],[137, 142, 162],[153, 153, 153], [105, 155, 203], [113, 141, 222], [149, 223, 124], [200, 120, 80], [151, 113, 201], [217, 59, 64], [200, 184, 59]]
		
		colorize = SKAction.colorize(with: UIColor.init(red: rgbArray[tier-1][0]/255, green: rgbArray[tier-1][1]/255, blue: rgbArray[tier-1][2]/255, alpha: 1), colorBlendFactor: 1, duration: 0)
		
		return colorize
	}
	
	
	
	func getAdjacentTiles(tile: SKSpriteNode) -> [SKSpriteNode] {
		var adjTileArray:[SKSpriteNode] = []
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			let adjustedDist = distanceBetweenTiles*5/4
			let tilePositionX = tile.position.x
			let tilePositionY = tile.position.y
			if child.position != tile.position && (child.position.x >= tilePositionX-adjustedDist && child.position.x <= tilePositionX+adjustedDist) && (child.position.y >= tilePositionY-adjustedDist && child.position.y <= tilePositionY+adjustedDist) && (child.position.x == tilePositionX || child.position.y == tilePositionY)
			{
				adjTileArray.append(child)
			}
		}
		return adjTileArray
	}
	
	
	
	func removeSkillTool(name:String)
	{
		let link = stationaryNode.childNode(withName: "link") as! Character
		if let pickaxeChild = link.childNode(withName: name) as? SKSpriteNode
		{
			if ((pickaxeChild.hasActions()))
			{
				pickaxeChild.removeAllActions()
				pickaxeChild.removeFromParent()
			}
		}
	}
	
	func moveAndOrientCharacter(location: CGPoint, attackMode: String) {
		if self.skillingTimer != nil { self.skillingTimer.invalidate()}
		
		removeSkillTool(name: "pickaxe")
		removeSkillTool(name: "harpoon")
		removeSkillTool(name: "axe")
		var link = stationaryNode.childNode(withName: "link") as! Character
		//distance between link and click
		var durFuncDistX = link.position.x - location.x
		var durFuncDistY = link.position.y - location.y
		
		var pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		
		let velocity = 200
		let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(velocity))
		// get travel time
		var startX = link.position.x
		var startY = link.position.y
		let startPoint = CGPoint(x: startX, y: startY)
		
		
		// get links starting position as a center of tile
		
		var child1:SKSpriteNode!
		var child2:SKSpriteNode!
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			
			let linkLocation = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
			if child.contains(linkLocation)
			{
				startX = child.position.x + movingNode.position.x
				startY = child.position.y + movingNode.position.y
				child1 = child
			}
		}
		
		
		
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			if child.contains(location)
			{
				//movePosition = child.position
				durFuncDistX = startX + child.position.x
				durFuncDistY = startY + child.position.y
				let newLocation = CGPoint(x: location.x - movingNode.position.x, y: location.y - movingNode.position.y)
				
				for tile in (tileNode?.children)! as! [SKSpriteNode]
				{
					if tile.contains(newLocation)
					{
						child2 = tile
						
					}
				}

			}
		}
		pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)

		
		
		var yMove = durFuncDistY
		var xMove = durFuncDistX
		let movePoint = CGPoint(x: durFuncDistX, y: durFuncDistY)
		
		
		// if ranged or magic combat is active and you're far away from enemy
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
				for child in (tileNode?.children)! as! [SKSpriteNode]
				{
					
					let linkLocation = CGPoint(x: xMove, y: yMove)
					if child.contains(linkLocation)
					{
						xMove = child.position.x
						yMove = child.position.y
						
					}
				}
			}
		}
			// do melee or move next to resource
		else if attackMode != "none"
		{
			if pythagDistance < distanceBetweenTiles*1.1 {
				xMove = 0
				yMove = 0
			} else {
				let finalMove = getQuadrantInStationaryNode(movePosition: movePoint, startingPosition: startPoint)
				xMove = finalMove.x
				yMove = finalMove.y
			}
		}
		let touchDistance =  pow((pow(location.x,2) + pow(location.y,2)), 0.5)
		print (touchDistance)
		print (pythagDistance)
		let distDiff = abs(touchDistance-pythagDistance)
		let healthMoveAction = SKAction.move(by: CGVector(dx: -xMove, dy: -yMove), duration: time)
		// perform skilling
		if child1 != nil && child2 != nil && child1.description != child2.description && distDiff < distanceBetweenTiles/2 {
			movingNode.removeAllActions()
			movingNode.run((healthMoveAction), completion: {
				if attackMode == "bank"
				{
					var bankPage = self.stationaryNode.childNode(withName: "bankPage") as! SKSpriteNode
					self.bankOpen = true
					self.reappearPage(page: &bankPage)
				}
				else if attackMode == "furnace"
				{
					var furnacePage = self.stationaryNode.childNode(withName: "furnacePage") as! SKSpriteNode
					self.furnaceOpen = true
					self.reappearPage(page: &furnacePage)
				}
				else if attackMode == "anvil"
				{
					var anvilPage = self.stationaryNode.childNode(withName: "anvilPage") as! SKSpriteNode
					self.anvilOpen = true
					self.reappearPage(page: &anvilPage)
				}
				else if attackMode == "skill" {
					var weapon:SKSpriteNode!
					if let sword = link.childNode(withName: "linkSword") as? SKSpriteNode {
						weapon = sword
					} else if let bow = link.childNode(withName: "bow") as? SKSpriteNode {
						bow.isHidden = true
					} else if let staff = link.childNode(withName: "staff") as? SKSpriteNode {
						weapon = staff
					}
					weapon.isHidden = true
					if self.resourceType == "rock" && self.resource.getRequiredLvl() <= link.getMiningLvl()
					{
						if self.skillingTimer != nil { self.skillingTimer.invalidate()}
						
						if let pickaxeChild = link.childNode(withName: "pickaxe") as? SKSpriteNode
						{
							if ((pickaxeChild.hasActions()))
							{
								pickaxeChild.removeAllActions()
								pickaxeChild.removeFromParent()
							}
						}
						let pickaxeSprite = SKSpriteNode(texture: SKTexture(imageNamed: "pickaxe"))
						pickaxeSprite.name = "pickaxe"
						pickaxeSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
						pickaxeSprite.zPosition = 1
						pickaxeSprite.position = CGPoint(x: link.size.width*3/8, y: link.size.height/3)
						
						pickaxeSprite.size = CGSize(width: link.size.width*1.2 , height: link.size.height*1.2)
						link.addChild(pickaxeSprite)
						let miningLvl = link.getMiningLvl()
						let delay = Int.random(in: 0 ... (10/miningLvl))
						let timeIntvl = TimeInterval(delay)
						
						//run rock mining animation
						let temp = self.harvestAnimation(sprite: &link)
						pickaxeSprite.run(SKAction.repeatForever(temp))
						
						
						if #available(iOS 10.0, *) {
							self.skillingTimer = Timer.scheduledTimer(withTimeInterval: timeIntvl, repeats: false, block:
								{ _ in
									self.executeSkilling(resource: &self.resource, resourceType: self.resourceType, originalTexture: SKTexture(imageNamed: "gold_rock"), depletedTexture: SKTexture(imageNamed: "minedRock"))
									pickaxeSprite.removeAllActions()
									pickaxeSprite.removeFromParent()
									weapon.isHidden = false
							})
						} else {
							// Fallback on earlier versions
						}
						
					}
						
						
					else if self.resourceType == "wood" && self.resource.getRequiredLvl() <= link.getWoodCuttingLvl()
					{
						if self.skillingTimer != nil { self.skillingTimer.invalidate()}
						
						if let pickaxeChild = link.childNode(withName: "axe") as? SKSpriteNode
						{
							if ((pickaxeChild.hasActions()))
							{
								pickaxeChild.removeAllActions()
								pickaxeChild.removeFromParent()
							}
						}
						let pickaxeSprite = SKSpriteNode(texture: SKTexture(imageNamed: "axe"))
						pickaxeSprite.name = "axe"
						pickaxeSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
						pickaxeSprite.zPosition = 1
						pickaxeSprite.position = CGPoint(x: link.size.width/4, y: -link.size.height/8)
						
						pickaxeSprite.size = CGSize(width: link.size.width*1.2 , height: link.size.height*1.2)
						link.addChild(pickaxeSprite)
						let miningLvl = link.getMiningLvl()
						let delay = Int.random(in: 0 ... (10/miningLvl))
						let timeIntvl = TimeInterval(delay)
						
						//run rock mining animation
						let temp = self.harvestAnimation(sprite: &link)
						pickaxeSprite.run(SKAction.repeatForever(temp))
						
						
						if #available(iOS 10.0, *) {
							self.skillingTimer = Timer.scheduledTimer(withTimeInterval: timeIntvl, repeats: false, block:
								{ _ in
									self.executeSkilling(resource: &self.resource, resourceType: self.resourceType, originalTexture: SKTexture(imageNamed: "tree"), depletedTexture: SKTexture(imageNamed: "cutTree"))
									pickaxeSprite.removeAllActions()
									pickaxeSprite.removeFromParent()
									weapon.isHidden = false

							})
						} else {
							// Fallback on earlier versions
						}
						
						
					}
					else if self.resourceType == "fish" && self.resource.getRequiredLvl() <= link.getFishingLvl()
					{
						if self.skillingTimer != nil { self.skillingTimer.invalidate()}
						
						if let pickaxeChild = link.childNode(withName: "harpoon") as? SKSpriteNode
						{
							if ((pickaxeChild.hasActions()))
							{
								pickaxeChild.removeAllActions()
								pickaxeChild.removeFromParent()
							}
						}
						let pickaxeSprite = SKSpriteNode(texture: SKTexture(imageNamed: "harpoon"))
						pickaxeSprite.name = "harpoon"
						pickaxeSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
						pickaxeSprite.zPosition = 1
						pickaxeSprite.position = CGPoint(x: link.size.width*3/8, y: link.size.height/3)
						
						pickaxeSprite.size = CGSize(width: link.size.width*1.2 , height: link.size.height*1.2)
						link.addChild(pickaxeSprite)
						let fishingLvl = link.getFishingLvl()
						let delay = Int.random(in: 0 ... (10/fishingLvl))
						let timeIntvl = TimeInterval(delay)
						
						//run rock mining animation
						let temp = self.harvestAnimation(sprite: &link)
						pickaxeSprite.run(SKAction.repeatForever(temp))
						
						
						if #available(iOS 10.0, *) {
							self.skillingTimer = Timer.scheduledTimer(withTimeInterval: timeIntvl, repeats: false, block:
								{ _ in
									self.executeSkilling(resource: &self.resource, resourceType: self.resourceType, originalTexture: SKTexture(imageNamed: "fishingSpot"), depletedTexture: SKTexture(imageNamed: "fishingSpotDepleted"))
									pickaxeSprite.removeAllActions()
									pickaxeSprite.removeFromParent()
									weapon.isHidden = false

							})
						} else
						{
							// Fallback on earlier versions
						}
					}
				}
			})
			link.zRotation = atan2((-durFuncDistY),(-durFuncDistX)) + CGFloat.pi/2
		}
		//link.run(moveAction)
		// rotate character
	}
	
	
	
	
	func bounceMonster(location: CGPoint, monsterName: String) {
		
		let monster = monsterNode.childNode(withName: monsterName) as! Character
		let healthBarBoss = healthBarMovingNode.childNode(withName: monster.name!) as! SKSpriteNode

		monster.removeAllActions()
		healthBarBoss.removeAllActions()
		
		let velocity = 400
		
		let durFuncDistX = location.x - monster.position.x
		let durFuncDistY = location.y - monster.position.y
		
		let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(velocity))
		let healthMoveAction = SKAction.move(by: CGVector(dx: durFuncDistX, dy: durFuncDistY), duration: time)
		// perform skilling
		healthBarBoss.run(healthMoveAction)
		monster.run((healthMoveAction), completion: {
			monster.isBouncing = false
			monster.isRandomWalking = true
			let moveAction = SKAction.run {
				let randMove = self.randomMove(monsterName: monsterName)
				let time:TimeInterval = 0.8
				monster.zRotation = atan2((-randMove.y+monster.position.y),(-randMove.x+monster.position.x)) + CGFloat.pi/2
				monster.run(SKAction.move(to: randMove, duration: time))
				var yMove = randMove.y
				yMove += monster.size.height*2/3
				healthBarBoss.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
				
			}
			let wait1 = SKAction.wait(forDuration: 0.5)
			let wait2 = SKAction.wait(forDuration: 2.5)
			let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait1,moveAction,wait2]))
			monster.run(randomMoveSequence, withKey: "randomMoveSequence")
		})
		
		monster.zRotation = atan2((-durFuncDistY),(-durFuncDistX)) + CGFloat.pi/2
	}
	
	func bounceLink(location: CGPoint, attackMode: String) {
		
		movingNode.removeAllActions()
		
		if self.skillingTimer != nil { self.skillingTimer.invalidate()}
		
		removeSkillTool(name: "pickaxe")
		removeSkillTool(name: "harpoon")
		removeSkillTool(name: "axe")
		let link = stationaryNode.childNode(withName: "link") as! Character
		//distance between link and click
		var durFuncDistX = link.position.x - location.x
		var durFuncDistY = link.position.y - location.y
		
		var pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		
		let velocity = 400
		// get travel time
		var startX = link.position.x
		var startY = link.position.y
		let startPoint = CGPoint(x: startX, y: startY)
		
		
		// get links starting position as a center of tile
		
		
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			
			let linkLocation = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
			if child.contains(linkLocation)
			{
				startX = child.position.x + movingNode.position.x
				startY = child.position.y + movingNode.position.y
				print (child)
			}
		}
		
		
		
		for child in (tileNode?.children)! as! [SKSpriteNode]
		{
			if child.contains(location)
			{
				
				//movePosition = child.position
				durFuncDistX = startX + child.position.x
				durFuncDistY = startY + child.position.y
				print (child)
			}
			
		}
		pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
		var yMove = durFuncDistY
		var xMove = durFuncDistX
		
		let movePoint = CGPoint(x: durFuncDistX, y: durFuncDistY)
		//print (movePoint)
		// if ranged or magic combat is active and you're far away from enemy
		
			// do melee or move next to resource
		if attackMode != "none"
		{
			if pythagDistance < distanceBetweenTiles*1.1 {
				xMove = 0
				yMove = 0
			} else {
				let finalMove = getQuadrantInStationaryNode(movePosition: movePoint, startingPosition: startPoint)
				xMove = finalMove.x
				yMove = finalMove.y
			}
		}
		
		pythagDistance = pow((pow(startX-xMove,2) + pow(startY-yMove,2)), 0.5)
		let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(velocity))
		
		let healthMoveAction = SKAction.move(by: CGVector(dx: -xMove, dy: -yMove), duration: time)
		// perform skilling
		movingNode.run(healthMoveAction)
		link.zRotation = atan2((-durFuncDistY),(-durFuncDistX)) + CGFloat.pi/2
	}
	
	func harvestAnimation(sprite: inout Character) -> SKAction
	{
		let fadeIn = SKAction.fadeIn(withDuration: 0.1)
		let swipe = SKAction.moveBy(x: 0, y: 0, duration: 0.2)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		let moveBack = SKAction.moveBy(x: 0, y: 0, duration: 0)
		let rotateStart = SKAction.rotate(toAngle: -CGFloat.pi/3, duration: 0)
		let rotate = SKAction.rotate(toAngle: 0, duration: 0.5)
		let rotateBack = SKAction.rotate(toAngle: -CGFloat.pi/3, duration: 0)
		let group = SKAction.group([swipe,rotate])
		let swipeSequence = SKAction.sequence([rotateStart,fadeIn,group,fadeOut,rotateBack,moveBack])
		return swipeSequence
	}
	
	// determine what side the boss is in relation to link
	
	func getQuadrantInStationaryNode(movePosition: CGPoint, startingPosition: CGPoint)->CGPoint {
		let relativePositionX = startingPosition.x - movePosition.x
		let relativePositionY = startingPosition.y - movePosition.y
		var point:CGPoint!
		if relativePositionX >= 0 && relativePositionY > 0 {
			if abs(relativePositionX) > abs(relativePositionY) {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else  {
				point = CGPoint(x: movePosition.x, y: movePosition.y+distanceBetweenTiles)
			}
		} else if relativePositionX > 0 && relativePositionY <= 0  {

			if abs(relativePositionX) >= abs(relativePositionY) {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else  {
				point = CGPoint(x: movePosition.x, y: movePosition.y-distanceBetweenTiles)

			}
		} else if relativePositionX <= 0 && relativePositionY <= 0  {

			if abs(relativePositionX) >= abs(relativePositionY) {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			} else {
				point = CGPoint(x: movePosition.x , y: movePosition.y-distanceBetweenTiles)
			}
		} else {

			if abs(relativePositionX) > abs(relativePositionY) {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			} else {
				point = CGPoint(x: movePosition.x, y: movePosition.y+distanceBetweenTiles)
			}
		}
		return point
	}
	
	func getQuadrant(movePosition: CGPoint, objectPosition: CGPoint)->CGPoint {
		let link = stationaryNode.childNode(withName: "link") as! Character
		let objectPositionX = objectPosition.x
		let objectPositionY = objectPosition.y
		let relativePositionX = objectPositionX - link.position.x
		let relativePositionY = objectPositionY - link.position.y
		var point:CGPoint!
		if relativePositionX >= 0 && relativePositionY > 0 {
			if abs(relativePositionX) >= abs(relativePositionY) {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else {
				point = CGPoint(x: movePosition.x, y: movePosition.y+distanceBetweenTiles)
			}
		} else if relativePositionX > 0 && relativePositionY <= 0  {
			if abs(relativePositionX) >= abs(relativePositionY) {
				point = CGPoint(x: movePosition.x + distanceBetweenTiles, y: movePosition.y)
			} else  {
				point = CGPoint(x: movePosition.x, y: movePosition.y-distanceBetweenTiles)
				
			}
		} else if relativePositionX <= 0 && relativePositionY <= 0  {
			if abs(relativePositionX) >= abs(relativePositionY) {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			} else {
				point = CGPoint(x: movePosition.x , y: movePosition.y-distanceBetweenTiles)
			}
		} else {
			if abs(relativePositionX) > abs(relativePositionY) {
				point = CGPoint(x: movePosition.x - distanceBetweenTiles, y: movePosition.y)
			} else {
				point = CGPoint(x: movePosition.x, y: movePosition.y+distanceBetweenTiles)
			}
		}
		return point
	}
	
	// move the boss out of the way if link overlaps
	
	func moveOutOfWay() {
		let link = stationaryNode.childNode(withName: "link") as? Character
		for monster in monsterNode.children as! [Character] {
			let healthBarBoss = healthBarMovingNode.childNode(withName: monster.name!) as! SKSpriteNode
			if link != nil
			{
				let bossPositionX = monster.position.x+movingNode.position.x
				let bossPositionY = monster.position.y+movingNode.position.y
				let xDiff = abs(link!.position.x - bossPositionX)
				let yDiff = abs(link!.position.y - bossPositionY)
				let dist = distanceBetweenTiles*5/10
				if xDiff < dist && yDiff < dist
				{
					if !monster.isBouncing
					{
						monster.removeAllActions()
						healthBarBoss.removeAllActions()
						monster.isBouncing = true
						var monsterTile: SKSpriteNode!
						for tile in (tileNode?.children)! as! [SKSpriteNode]
						{
							if tile.contains(monster.position) {
								monsterTile = tile
								
							}
						}
						var nextMoveArray:[CGPoint] = []
						for child in (tileNode?.children)! as! [SKSpriteNode]
						{
							let adjustedDist = distanceBetweenTiles*5/4
							
							let pythagDist = pow((pow(child.position.x - monsterTile.position.x,2) + pow(child.position.y - monsterTile.position.y,2)), 0.5)
							let pyDist = distanceBetweenTiles*10/9
							if !child.contains(monsterTile.position) && (child.position.x >= monsterTile.position.x-adjustedDist && child.position.x <= monsterTile.position.x+adjustedDist) && (child.position.y >= monsterTile.position.y-adjustedDist && child.position.y <= monsterTile.position.y+adjustedDist) && (!child.contains(monsterTile.position)) && pythagDist < pyDist
							{
								nextMoveArray.append(child.position)
							}
						}
						if nextMoveArray.count > 0
						{
							let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
							monster.zRotation = atan2((-randMove.y+monster.position.y),(-randMove.x+monster.position.x)) + CGFloat.pi/2
							
							let time:TimeInterval = 0.2
							let moveAction = SKAction.move(to: randMove, duration: time)
							let wait = SKAction.wait(forDuration: 1)
							let sequence = SKAction.sequence([moveAction,wait])
							monster.run((sequence), completion: {
								monster.isBouncing = false
							})
							var yMove = randMove.y
							yMove+=monster.size.height*2/3
							let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
							let sequence2 = SKAction.sequence([healthMoveAction,wait])
							healthBarBoss.run(sequence2)
						}
					}
				}
			}
		}
		//let boss = monsterNode.childNode(withName: "boss") as? Character
		//let healthBarBoss = healthBarMovingNode.childNode(withName: "boss") as! SKSpriteNode
		
	}
	
	// update the boss position when following link
	
	func updateBossPos(monsterName: String, speed:CGFloat) {
		let link = stationaryNode.childNode(withName: "link") as? Character
		let boss = monsterNode.childNode(withName: monsterName) as? Character
		let healthBarBoss = healthBarMovingNode.childNode(withName: monsterName) as! SKSpriteNode
		
		if !boss!.isBouncing && boss != nil && link != nil
		{
			
			let bossPositionX = boss!.position.x+movingNode.position.x
			let bossPositionY = boss!.position.y+movingNode.position.y
			let durFuncDistX = link!.position.x - bossPositionX
			let durFuncDistY = link!.position.y - bossPositionY
			let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
			
			
			linkToBossDist = pythagDistance*6/10
			let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(100))
			if pythagDistance <= distanceBetweenTiles*1.1
			{
				
				
				if !link!.inCombat {
					monsterInCombatWithLink = monsterName
					runCombat(monsterName: monsterName)
					if boss!.isRandomWalking {
						boss!.isRandomWalking = false
						boss!.removeAction(forKey: "randomMoveSequence")
						healthBarBoss.removeAction(forKey: "randomMoveSequence")
					}
				} else if monsterInCombatWithLink == monsterName {
					runCombat(monsterName: monsterName)
					if boss!.isRandomWalking {
						boss!.isRandomWalking = false
						boss!.removeAction(forKey: "randomMoveSequence")
						healthBarBoss.removeAction(forKey: "randomMoveSequence")
					}
				} else {
					if !boss!.isRandomWalking && !boss!.isHidden
					{
						print ("here")
						boss?.isRandomWalking = true
						let moveAction = SKAction.run {
							let randMove = self.randomMove(monsterName: monsterName)
							let time:TimeInterval = 0.8
							boss!.zRotation = atan2((-randMove.y+boss!.position.y),(-randMove.x+boss!.position.x)) + CGFloat.pi/2
							boss!.run(SKAction.move(to: randMove, duration: time))
							var yMove = randMove.y
							yMove += boss!.size.height*2/3
							healthBarBoss.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
							
						}
						let wait1 = SKAction.wait(forDuration: 0.5)
						let wait2 = SKAction.wait(forDuration: 2.5)
						let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait1,moveAction,wait2]))
						boss?.run(randomMoveSequence, withKey: "randomMoveSequence")
					}
				}
			}
			else if pythagDistance < distanceBetweenTiles*3
			{
				if !link!.inCombat {
					monsterInCombatWithLink = monsterName
				}
				if rangedOn && link?.attacking == false && monsterInCombatWithLink == monsterName
				{
					runCombatLink(monsterName: monsterName)
				}
				if magicOn && link?.attacking == false && monsterInCombatWithLink == monsterName
				{
					runCombatLink(monsterName: monsterName)
				}
				
				if boss!.isRandomWalking && monsterInCombatWithLink == monsterName {
					boss!.isRandomWalking = false
					boss!.removeAction(forKey: "randomMoveSequence")
					healthBarBoss.removeAction(forKey: "randomMoveSequence")
				}
				if monsterInCombatWithLink != monsterName {

					if !boss!.isRandomWalking && !boss!.isHidden
					{
						boss?.isRandomWalking = true
						let moveAction = SKAction.run {
							let randMove = self.randomMove(monsterName: monsterName)
							let time:TimeInterval = 0.8
							boss!.zRotation = atan2((-randMove.y+boss!.position.y),(-randMove.x+boss!.position.x)) + CGFloat.pi/2
							boss!.run(SKAction.move(to: randMove, duration: time))
							var yMove = randMove.y
							yMove += boss!.size.height*2/3
							healthBarBoss.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
							
						}
						let wait1 = SKAction.wait(forDuration: 0.5)
						let wait2 = SKAction.wait(forDuration: 2.5)
						let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait1,moveAction,wait2]))
						boss?.run(randomMoveSequence, withKey: "randomMoveSequence")
					}
				}

//				if timer != nil
//				{
//					timer!.invalidate()
//					timer = nil
//				}
				if monsterInCombatWithLink == monsterName {
					var movePosition = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
					
					let bossPosition = CGPoint(x: bossPositionX, y: bossPositionY)
					movePosition = CGPoint(x: getQuadrant(movePosition: movePosition, objectPosition: bossPosition).x, y: getQuadrant(movePosition: movePosition, objectPosition: bossPosition).y)
					let moveAction = SKAction.move(to: movePosition, duration: time)
					boss!.zRotation = atan2(movePosition.y,movePosition.x) + CGFloat.pi/2
					boss!.run(moveAction)
					
					let bossHeightAdjust = boss!.size.height*2/3
					let yMove = movePosition.y+bossHeightAdjust
					let healthMoveAction = SKAction.move(to: CGPoint(x: movePosition.x, y: yMove), duration: time)
					healthBarBoss.run(healthMoveAction)
				}
			}
			else
			{
				if !boss!.isRandomWalking && !boss!.isHidden
				{

					boss?.isRandomWalking = true
					let moveAction = SKAction.run {
						let randMove = self.randomMove(monsterName: monsterName)
						let time:TimeInterval = 0.8
						boss!.zRotation = atan2((-randMove.y+boss!.position.y),(-randMove.x+boss!.position.x)) + CGFloat.pi/2
						boss!.run(SKAction.move(to: randMove, duration: time))
						var yMove = randMove.y
						yMove += boss!.size.height*2/3
						healthBarBoss.run(SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time))
						
					}
					let wait1 = SKAction.wait(forDuration: 0.5)
					let wait2 = SKAction.wait(forDuration: 2.5)
					let randomMoveSequence = SKAction.repeatForever(SKAction.sequence([wait1,moveAction,wait2]))
					boss?.run(randomMoveSequence, withKey: "randomMoveSequence")
				}
			}
		}
	}
	
	
	func hidePage(page: inout SKSpriteNode) {
		if page.name == "bankPage" {
			bankOpen = false
		}
		if page.name == "furnacePage" {
			furnaceOpen = false
		}
		if page.name == "anvilPage" {
			anvilOpen = false
		}
		if page.name == "fletchPage" {
			fletchOpen = false
		}
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
		
		for xIndex in 0...columnNumber+1 {
			for yIndex in 0...rowNumber*2+2 {
				let xPosition = distanceBetweenTiles*CGFloat(xIndex-midWayNumX)
				let yPosition = distanceBetweenTiles*CGFloat(yIndex-midWayNumY)
				let xOffSet = distanceBetweenTiles*0.5*oddOrEvenNumX
				let yOffSet = distanceBetweenTiles*0.5*oddOrEvenNumY
				if x == xIndex {
					tempXCoord = -xOffSet+xPosition
					if y == yIndex {
						let y1 = -yOffSet+yPosition
						tempYCoord = y1-distanceBetweenTiles
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
		} else {
			hidePage(page: &page)
		}
	}
	
	func interactWithPage(touch: UITouch)->Bool {
		let location = touch.location(in: stationaryNode)
		var attackPage = stationaryNode.childNode(withName: "attackPage") as! SKSpriteNode
		var combatPage = stationaryNode.childNode(withName: "combatStylePage") as! SKSpriteNode
		var skillsPage = stationaryNode.childNode(withName: "skillsPage") as! SKSpriteNode
		var inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		var bankPage = stationaryNode.childNode(withName: "bankPage") as! SKSpriteNode
		var furnacePage = stationaryNode.childNode(withName: "furnacePage") as! SKSpriteNode
		var anvilPage = stationaryNode.childNode(withName: "anvilPage") as! SKSpriteNode
		var fletchPage = stationaryNode.childNode(withName: "fletchPage") as! SKSpriteNode


		let attackPageLocation = touch.location(in: attackPage)
		let combatPageLocation = touch.location(in: combatPage)
		//let skillsPageLocation = touch.location(in: skillsPage)
		//let inventoryPageLocation = touch.location(in: inventoryPage)
		
		var isPage = true
		//skills and inv buttons/pages
		let menuPage = stationaryNode.childNode(withName: "menuPage") as! SKSpriteNode
		let menuLocation = touch.location(in: menuPage)
		if bankPage.contains(location)
		{
			
		}
		else if furnacePage.contains(location)
		{
			
		}
		else if anvilPage.contains(location)
		{
			
		}
		else if fletchPage.contains(location)
		{
			
		}
		else if menuPage.contains(location) {
			hidePage(page: &fletchPage)
			let inventoryButton = menuPage.childNode(withName: "inventoryButton") as! SKSpriteNode
			let skillsButton = menuPage.childNode(withName: "skillsButton") as! SKSpriteNode
			let combatButton = menuPage.childNode(withName: "combatButton") as! SKSpriteNode
			if inventoryButton.contains(menuLocation)
			{
				inventoryButton.alpha = 1
				skillsButton.alpha = 0.7
				combatButton.alpha = 0.7
				hidePage(page: &combatPage)
				hidePage(page: &attackPage)
				hidePage(page: &skillsPage)
				reappearPage(page: &inventoryPage)
				
				
				
			} else if skillsButton.contains(menuLocation)
			{
				inventoryButton.alpha = 0.7
				skillsButton.alpha = 1
				combatButton.alpha = 0.7
				hidePage(page: &combatPage)
				hidePage(page: &attackPage)
				hidePage(page: &inventoryPage)
				
				reappearPage(page: &skillsPage)
				
				
				
			} else if combatButton.contains(menuLocation)
			{
				inventoryButton.alpha = 0.7
				skillsButton.alpha = 0.7
				combatButton.alpha = 1
				reappearPage(page: &combatPage)
				hidePage(page: &skillsPage)
				hidePage(page: &inventoryPage)

				if meleeOn {
					reappearPage(page: &attackPage)
				}
				
				
			}
		}
		else if attackPage.contains(location)
		{
			hidePage(page: &bankPage)

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
		else if inventoryPage.contains(location)
		{
		}
		else if skillsPage.contains(location)
		{
			hidePage(page: &bankPage)
			hidePage(page: &furnacePage)
			hidePage(page: &anvilPage)
			hidePage(page: &fletchPage)


		}
		else if combatPage.contains(location)
		{
			hidePage(page: &bankPage)
			hidePage(page: &furnacePage)
			hidePage(page: &anvilPage)
			hidePage(page: &fletchPage)



			let meleeButton = combatPage.childNode(withName: "meleeButton") as! SKSpriteNode
			let rangedButton = combatPage.childNode(withName: "rangedButton") as! SKSpriteNode
			let magicButton = combatPage.childNode(withName: "magicButton") as! SKSpriteNode
			if meleeButton.contains(combatPageLocation) && !meleeOn
			{
				reappearPage(page: &attackPage)
				
				meleeOn = true
				rangedOn = false
				magicOn = false
				meleeButton.texture = SKTexture(imageNamed: "meleeOn")
				rangedButton.texture = SKTexture(imageNamed: "archery")
				magicButton.texture = SKTexture(imageNamed: "magicOff")
				
			} else if rangedButton.contains(combatPageLocation) && !rangedOn
			{
				hidePage(page: &attackPage)
				
				meleeOn = false
				rangedOn = true
				magicOn = false
				meleeButton.texture = SKTexture(imageNamed: "melee")
				rangedButton.texture = SKTexture(imageNamed: "archeryOn")
				magicButton.texture = SKTexture(imageNamed: "magicOff")
			} else if magicButton.contains(combatPageLocation) && !magicOn
			{
				hidePage(page: &attackPage)
				
				meleeOn = false
				rangedOn = false
				magicOn = true
				meleeButton.texture = SKTexture(imageNamed: "melee")
				rangedButton.texture = SKTexture(imageNamed: "archery")
				magicButton.texture = SKTexture(imageNamed: "magicOn")
				
			}
		} else {
			hidePage(page: &bankPage)
			hidePage(page: &furnacePage)
			hidePage(page: &anvilPage)
			hidePage(page: &fletchPage)

			isPage = false
		}
		return isPage
	}
	
	func handleLinkMove(touch: UITouch, skillAction: Bool) {
		let link = stationaryNode.childNode(withName: "link") as! Character
		
		
		//let healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as! SKSpriteNode
		
		let location = touch.location(in: stationaryNode)
		let movingLocation = touch.location(in: movingNode)
		link.removeAllActions()
		//healthBarLink.removeAllActions()
		
		var containsMonster = false
		for monster in monsterNode.children as! [Character] {
			if monster.contains(movingLocation)
			{
				containsMonster = true
				let bossPositionX = monster.position.x+movingNode.position.x
				let bossPositionY = monster.position.y+movingNode.position.y
				let durFuncDistX = link.position.x - bossPositionX
				let durFuncDistY = link.position.y - bossPositionY
				let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
				if pythagDistance <= distanceBetweenTiles*1.1
				{
					break
				} else if pythagDistance < distanceBetweenTiles*3
				{
					if !rangedOn && !magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "melee")
						break
					}
				} else
				{
					if !rangedOn && !magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "melee")
						break
					} else if rangedOn
					{
						moveAndOrientCharacter(location: location, attackMode: "ranged")
						break
					} else if magicOn
					{
						moveAndOrientCharacter(location: location, attackMode: "magic")
						break
					}
				}
			}
		}
		
		for tile in (tileNode?.children)! as! [SKSpriteNode] {
			if tile.contains(movingLocation) && !containsMonster{
				if skillAction {
					moveAndOrientCharacter(location: location, attackMode: "skill")
					break
				} else {
					var containsBank = false
					for bank in bankNode.children as! [SKSpriteNode] {
						
						if bank.contains(movingLocation) {
							containsBank = true
							moveAndOrientCharacter(location: location, attackMode: "bank")
							break
						}
					}
					var containsFurnace = false
					for furnace in furnaceNode.children as! [SKSpriteNode] {
						
						if furnace.contains(movingLocation) {
							containsFurnace = true
							moveAndOrientCharacter(location: location, attackMode: "furnace")
							break
						}
					}
					var containsAnvil = false
					for anvil in anvilNode.children as! [SKSpriteNode] {
						
						if anvil.contains(movingLocation) {
							containsAnvil = true
							moveAndOrientCharacter(location: location, attackMode: "anvil")
							break
						}
					}
					
					if !containsBank && !containsFurnace && !containsAnvil {
						
						moveAndOrientCharacter(location: location, attackMode: "none")
						break
					}
				}
			}
		}
		
	}
	
	func respondToTouch(touch: UITouch) {
		
		//let boss = monsterNode.childNode(withName: "boss") as? Character
		let location = touch.location(in: stationaryNode)
		if !interactWithPage(touch: touch) {
			// run skilling
			let consumedResourceRockBool = runSkill(touch: touch, parentNode: rocksNode, resourceType: "rock", originalTexture: SKTexture(imageNamed: "gold_rock"), depletedTexture: SKTexture(imageNamed: "minedRock"))
			let consumedResourceWoodBool = runSkill(touch: touch, parentNode: woodCuttingNode, resourceType: "wood", originalTexture: SKTexture(imageNamed: "tree"), depletedTexture: SKTexture(imageNamed: "cutTree"))
			let consumedResourceFishBool = runSkill(touch: touch, parentNode: fishingNode, resourceType: "fish", originalTexture: SKTexture(imageNamed: "fish"), depletedTexture: SKTexture(imageNamed: "darkTile"))
			
			let skillAction = consumedResourceRockBool || consumedResourceWoodBool || consumedResourceFishBool
			
			
			// animate pointer if on object
			let movingLocation = touch.location(in: movingNode)
			
			var touchesBank = false
			for bank in bankNode.children as! [SKSpriteNode]
			{
				if bank.contains(movingLocation) {touchesBank = true}
			}
			var touchesFurnace = false
			for furnace in furnaceNode.children as! [SKSpriteNode]
			{
				if furnace.contains(movingLocation) {touchesFurnace = true}
			}
			var touchesAnvil = false
			for anvil in anvilNode.children as! [SKSpriteNode]
			{
				if anvil.contains(movingLocation) {touchesAnvil = true}
			}
			var containsMonster = false
			
			for monster in monsterNode.children as! [Character] {
				if monster.contains(movingLocation)
				{
					containsMonster = true
					animatePointer (location: location, type: "red")
					let link = stationaryNode.childNode(withName: "link") as! Character
					if !link.inCombat {
						monsterInCombatWithLink = monster.name!
					}
					break
				} else
				{
					animatePointer (location: location, type: "grey")
				}
			}
			if skillAction || touchesBank || touchesFurnace || touchesAnvil {
				animatePointer (location: location, type: "red")
			} else if !containsMonster {
				animatePointer (location: location, type: "grey")
			}
			
			handleLinkMove(touch: touch, skillAction: skillAction)
		}
		
	}
	
	func createAnvilMenu(page: inout SKSpriteNode)
	{
		//make 4x3 grid
		let yArray = [-3,-1,1,3]
		let xArray = [-3,-1,1,3]
		
		var makeableItemsArray = ["boots", "chest", "helm", "legs", "pickaxe", "axe"]
		//var makeableItemsCount = 0
		
		for i in 0...yArray.count-1
		{
			let y = page.size.height * CGFloat(yArray[i])/8
			
			for j in 0...xArray.count-1
			{
				//panel in grid
				var panelTextureString = ""
				//let pageName = page.name
				panelTextureString = makeableItemsArray.popLast() ?? "backgroundImage"
				let panelTexture = SKTexture(imageNamed: panelTextureString)
				//makeableItemsCount += 1
				
				let inventoryPanel = SKSpriteNode(texture: panelTexture)
				let x = page.size.width * CGFloat(xArray[j])/8
				inventoryPanel.position = CGPoint(x: x, y: y)
				inventoryPanel.size = CGSize(width: page.size.width/4*9.5/10, height: page.frame.height/4*9.2/10)
				inventoryPanel.name = "\(i+1)\(j+1)"
				page.addChild(inventoryPanel)
				
				
				
				//level and percent labels??
				let countLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
				countLabel.text = ""
				countLabel.name = "countLabel"
				countLabel.position = CGPoint(x: inventoryPanel.size.width/20, y: inventoryPanel.size.height/8)
				countLabel.horizontalAlignmentMode = .left
				countLabel.fontSize = scale*10
				countLabel.fontColor = .black
				
				inventoryPanel.addChild(countLabel)
				
			}
			
			
		}
	}
	
	func handleCharacterDeath() {
		let link = stationaryNode.childNode(withName: "link") as! Character
		let healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as! SKSpriteNode
		
		if link.deadFlag
		{
			link.deadFlag = false
			link.isHidden = true
			link.removeAllActions()
			healthBarLink.removeAllActions()
			for monster in monsterNode.children as! [Character] {
				if monster.inCombat {
					monster.removeAllActions()
					let healthBarMonster = movingNode.childNode(withName: monster.name!) as! SKSpriteNode
					healthBarMonster.removeAllActions()

				}
			}
			link.position = CGPoint(x: 1000, y: 1000)
			healthBarLink.isHidden = true
			timer = nil
			timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(reviveLink), userInfo: nil, repeats: false)
		}
		
		
		for monster in monsterNode.children as! [Character] {
			if monster.deadFlag
			{
				
				var temp = monster
				monsterDrop(monster: &temp)
				monster.deadFlag = false
				
				let healthBarBoss = healthBarMovingNode.childNode(withName: monster.name!) as! SKSpriteNode
				monster.isHidden = true
				monster.removeAllActions()
				//healthBarBoss.removeAllActions()
				link.removeAllActions()
				monster.position = CGPoint(x: 1000, y: 1000)
				healthBarBoss.position = CGPoint(x: 1000, y: 1000)
				
				healthBarBoss.run(SKAction.fadeOut(withDuration: 0))
				
				timer2 = nil
				timer2 = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(reviveMonster), userInfo: monster.name!, repeats: false)
			}
		}
	}
	
	// run initialization functions on didMove()
	
	func initFunctions(tileName: String) {
		setUpScaleAndNodes()
		createTiles(tileName: tileName)
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
	func createNpc(charName: String, position: CGPoint, sprite: inout SKSpriteNode)
	{
		//link code block
		sprite.name = charName
		sprite.position = position
		movingNode.addChild(sprite)
        
        
        var imgListArray :[SKTexture] = []
        pointer.alpha = 1
        var count = 0
        var curTexture = SKTexture(imageNamed: charName)
        
        //fill animation array
        while (curTexture.description != nil)
        {
            if (charName != "bipin1")
            {
                let strImageName:String = charName + String(count)
                let curTexture  = SKTexture(imageNamed: strImageName)
                imgListArray.append(curTexture ?? SKTexture(imageNamed: "backgroundImage"))
            }
            else
            {
                let strImageName:String = charName
                let curTexture  = SKTexture(imageNamed: strImageName)
                imgListArray.append(curTexture ?? SKTexture(imageNamed: "backgroundImage"))
            }
            
        }
        
        
        let animateSprite = SKAction.animate(with: imgListArray, timePerFrame: 0.03)
        
        //animation has to be done outside this function??
        //run this indefeintiely
        
        sprite.run((animateSprite), completion:{0})
        
        
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
	
	
	/*********** MINING FUNCTIONS ************/
	//spawn X number of objects given a ceratin sprite
	func spawnObject(_ spriteFile:String, _ count:Int, _ parentNode: SKNode)
	{
		//add object nodes to selfNode hre
		movingNode.addChild(parentNode)
		
		for i in 1...count
		{
			
			var allChildren: [SKSpriteNode] = []
			for child in rocksNode.children as! [SKSpriteNode]{
				allChildren.append(child)
			}
			for child2 in woodCuttingNode.children as! [SKSpriteNode] {
				allChildren.append(child2)
			}
			for child3 in fishingNode.children as! [SKSpriteNode] {
				allChildren.append(child3)
			}
			let xRand = Int.random(in: 1...columnNumber)
			let yRand = Int.random(in: 1...rowNumber*2+1)
			
			//let children = parentNode.children as! [SKSpriteNode]
			var isOverlap = false
			let randPoint = getCGPointAtPosition(x: xRand, y: yRand)
			let adjustedPoint = CGPoint(x: randPoint.x, y: randPoint.y)
			
			for child in allChildren
			{
				let xDist = child.position.x-randPoint.x
				var yDist = child.position.y
				yDist-=randPoint.y
				let distance = pow(pow(xDist, 2)+pow(yDist, 2),0.5)
				if distance < 0.1
				{
					isOverlap = true
				}
			}
			if !isOverlap
			{
				let randTier = Int.random(in: 1...1)
				let colorizeAction = colorizeTier(tier: randTier)
				
				//let temp = SKSpriteNode(texture: SKTexture(imageNamed: spriteFile))
				let resource = Resource(texture: SKTexture(imageNamed: spriteFile), size: CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio), tier: randTier, name: "(spriteFile)\(i)")
				resource.run(colorizeAction)
				parentNode.addChild(resource)
				resource.position = adjustedPoint
				resource.zPosition = 1
			}
		}
	}
	
	//make bar to count gold coins/ rocks
	func makeGoldCountBar()
	{
		let tileDist = self.frame.height/7.5*aspectRatio
		let tileDistWidth = self.frame.width/7.5*aspectRatio
		
		goldCountBar = SKSpriteNode(texture: SKTexture(imageNamed: "goldCountBar"))
		stationaryNode.addChild(goldCountBar!)
		
		let blockXPos =  distanceBetweenTiles*2
		let blockYPos = distanceBetweenTiles*6
		let barPos = CGPoint(x: blockXPos, y: blockYPos)
		
		goldCountBar?.size = CGSize(width: tileDist*2.5, height: tileDist)
		goldCountBar?.position = barPos
		goldCountBar?.zPosition = 1
		
		
		//set up integer text label
		goldCountLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		goldCountLabel!.zPosition = 2
		goldCountLabel!.text = String(goldCount)
		goldCountLabel!.fontSize = 40*scale
		goldCountLabel!.fontColor = SKColor.white
		goldCountLabel!.verticalAlignmentMode = .center
		//goldCountLabel!.horizontalAlignmentMode = .right
		goldCountLabel!.position = CGPoint(x: tileDistWidth, y: 0)
		
		goldCountBar!.addChild(goldCountLabel!)
		
	}
	
	
	
	func incrementSkill(_ resource: inout Resource, _ resourceType: String)
	{
		let healthBarLink = stationaryNode.childNode(withName: "healthBarLink") as! SKSpriteNode
		let link = stationaryNode.childNode(withName: "link") as! Character
		let xpLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		healthBarLink.addChild(xpLabel)
		xpLabel.fontSize = CGFloat(36)
		xpLabel.fontColor = UIColor.init(red: 254/255, green: 215/255, blue: 10/255, alpha: 1)
		xpLabel.text = "+4 XP"
		let fadeIn2 = SKAction.fadeIn(withDuration: 1)
		let fadeOut2 = SKAction.fadeOut(withDuration: 1)
		xpLabel.run(SKAction.sequence([fadeIn2, fadeOut2]))
		
		//name rocks to be able to access them
		resource.name = "consumed"
		
		//increments
		if resourceType == "rock" {
			link.addMiningXP(amount: 4)
			let levelLabel = getSkillsPanel(skillName: "mining").childNode(withName: "levelLabel") as! SKLabelNode
			levelLabel.text = "LVL: "+String(link.getMiningLvl())
			let percentLabel = getSkillsPanel(skillName: "mining").childNode(withName: "percentLabel") as! SKLabelNode
			percentLabel.text = String(link.getxpToNextLevel(xp: link.miningXP, lvl: link.getMiningLvl()))
			goldCount += 1
			goldCountLabel?.text = String(goldCount)
		} else if resourceType == "wood" {
			link.addWoodCuttingXP(amount: 4)
			let levelLabel = getSkillsPanel(skillName: "woodcutting").childNode(withName: "levelLabel") as! SKLabelNode
			levelLabel.text = "LVL: "+String(link.getWoodCuttingLvl())
			let percentLabel = getSkillsPanel(skillName: "woodcutting").childNode(withName: "percentLabel") as! SKLabelNode
			percentLabel.text = String(link.getxpToNextLevel(xp: link.woodCuttingXP, lvl: link.getWoodCuttingLvl()))
			woodCount += 1
			goldCountLabel?.text = String(woodCount)
		} else if resourceType == "fish" {
			link.addFishingXP(amount: 4)
			let levelLabel = getSkillsPanel(skillName: "fishing").childNode(withName: "levelLabel") as! SKLabelNode
			levelLabel.text = "LVL: "+String(link.getFishingLvl())
			let percentLabel = getSkillsPanel(skillName: "fishing").childNode(withName: "percentLabel") as! SKLabelNode
			percentLabel.text = String(link.getxpToNextLevel(xp: link.fishingXP, lvl: link.getFishingLvl()))
			//woodCount += 1
			//goldCountLabel?.text = String(woodCount)
		}
	}
	
	func addToFurnace(input: inout Any){
		let bankPage = stationaryNode.childNode(withName: "furnacePage") as! SKSpriteNode
		var firstZeroIndex = -1
		let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
		
		//gets index of first open spot
		for i in 0...furnaceArray.count-1
		{
			if furnaceArray[i] == 0
			{
				firstZeroIndex = i
				break
			}
		}
		
		if firstZeroIndex >= 0
		{
			
			furnaceArray[firstZeroIndex] = 1 //bitmap filled
			
			let panel = bankPage.childNode(withName: encodeArray[firstZeroIndex]) as! SKSpriteNode
			
			//print(panel)
			//button panel, dont do anything just return
			if panel.name == "14" {return}
			
			if let item = input as? Weapon {
				let tier = item.tier
				panel.texture = item.texture
				panel.run(colorizeTier(tier: tier!))
				
			}
				
				
			else if let item = input as? SKSpriteNode
			{
				let itemColor = item.color
				//print("beforepanTExture is", panel.texture)
				panel.texture = item.texture
				//print("afterPanTExture is", panel.texture)
				if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
					panel.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
				}
			}
		}
		
		
	}
	
	func addToBank(input: inout Any){
		let bankPage = stationaryNode.childNode(withName: "bankPage") as! SKSpriteNode
		var firstZeroIndex = -1
		let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
		
		//gets index of first open spot
		for i in 0...bankArray.count-1
		{
			if bankArray[i] == 0
			{
				firstZeroIndex = i
				break
			}
		}
		
		if firstZeroIndex >= 0
		{
			bankArray[firstZeroIndex] = 1 //bitmap filled
			
			let panel = bankPage.childNode(withName: encodeArray[firstZeroIndex]) as! SKSpriteNode
			
			if let item = input as? Weapon {
				let tier = item.tier
				panel.texture = item.texture
				panel.run(colorizeTier(tier: tier!))
				
			}
			else if let item = input as? SKSpriteNode
			{
				
				let itemColor = item.color
				panel.texture = item.texture
				if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
					panel.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
				}
			}
		}
		
		
	}
	
	
	func addToInventory(input: inout Any)
	{
		
		
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		var firstZeroIndex = -1
		let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
		
		//gets index of first open spot
		for i in 0...inventoryArray.count-1
		{
			if inventoryArray[i] == 0
			{
				firstZeroIndex = i
				break
			}
		}
		
		if firstZeroIndex >= 0
		{
			inventoryArray[firstZeroIndex] = 1 //bitmap filled
			
			
			let panel = inventoryPage.childNode(withName: encodeArray[firstZeroIndex]) as! SKSpriteNode
			
			var tier = 0

			if let item = input as? Weapon {
				tier = item.tier
				panel.texture = item.texture
				panel.run(colorizeTier(tier: tier))

			}
			else if let item = input as? SKSpriteNode
			{
				var matchedItem = false
				for (key, value) in invDictionary {
					if item.texture!.description == key
					{
						matchedItem = true
						panel.texture = SKTexture(imageNamed: value)
					}
				}
				if !matchedItem
				{
					panel.texture = item.texture
				}
				let itemColor = item.color
				//panel.texture = item.texture
				if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
					panel.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
				}
			}


		}
		
	}
	
	/*
	func addToInventory(input: String)
	{
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		var firstZeroIndex = -1
		let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
		
		//gets index of first open spot
		for i in 0...inventoryArray.count-1
		{
			if inventoryArray[i] == 0
			{
				firstZeroIndex = i
				break
			}
		}
		
		if firstZeroIndex >= 0
		{
			inventoryArray[firstZeroIndex] = 1 //bitmap filled
			
			
			let panel = inventoryPage.childNode(withName: encodeArray[firstZeroIndex]) as! SKSpriteNode
			
			for (key, value) in invDictionary {
				print("\(key) -> \(value)")
				print("input is: " + input)
				if input == key
				{
					
					panel.texture = SKTexture(imageNamed: value)
				}
			}
			/*
			if input == "wood" {panel.texture = SKTexture(imageNamed: "cutLogs")}
			
			if input == "rock" {panel.texture = SKTexture(imageNamed: "gold_rock")}
			*/
		}
		
	}*/
	
	
	func executeSkilling(resource: inout Resource, resourceType: String, originalTexture: SKTexture, depletedTexture: SKTexture) {
		
		//ANIMATIONNN
		//????
		
		incrementSkill(&resource, resourceType) //updates gold count text
		let temp = resource
		
		
		let resourceColor = resource.color
		let consumedColorAction = SKAction.colorize(with: UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), colorBlendFactor: 1, duration: 0)
		resource.run(consumedColorAction)
		
		//resource.texture = depletedTexture
		let wait = SKAction.wait(forDuration: 3)
		let makeResourceUsable = SKAction.run
		{
			//temp.texture = originalTexture
			temp.run(SKAction.colorize(with: resourceColor, colorBlendFactor: 1, duration: 0))
			temp.name = "notConsumed"
		}
		
		resource.run(SKAction.sequence([wait, makeResourceUsable]))
		var resource2 = resource as Any
		addToInventory(input: &resource2)
		
	}
	
	func runSkill(touch: UITouch, parentNode: SKNode, resourceType: String, originalTexture: SKTexture, depletedTexture: SKTexture) -> Bool
	{
		
		let children = parentNode.children as! [Resource]
		let stationaryTouchLocation = touch.location(in: stationaryNode)
		let movingTouchLocation = touch.location(in: movingNode)
		//for each child of rocksNode check if the rock contains touch location
		for child in children
		{
			let temp = child
			
			if temp.contains(movingTouchLocation) && temp.name != "consumed"
			{
				
				animatePointer(location: stationaryTouchLocation, type: "red")
				resource = temp
				
				self.resourceType = resourceType
				
				return true
			}
		}
		return false
	}
	
	func removeItem(touch: UITouch, storageName: String, storageArray: inout [Int]) {
		let location = touch.location(in: stationaryNode)
		let inventoryPage = stationaryNode.childNode(withName: storageName) as! SKSpriteNode
		let inventoryPageLocation = touch.location(in: inventoryPage)
		if inventoryPage.contains(location) {
			for item in inventoryPage.children as! [SKSpriteNode]
			{
				if item.contains(inventoryPageLocation) && item.texture!.description != backgroundTexture.description
				{
					//print(item.texture!.description)
					//print(backgroundTexture.description)
					item.texture = backgroundTexture
					let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
					let encodeArrayIndex = encodeArray.firstIndex(of: item.name!)!
					storageArray[encodeArrayIndex] = 0
				}
			}
		}
	}
	
	func withdrawFromBank(touch: UITouch) {
		let bankPage = stationaryNode.childNode(withName: "bankPage") as! SKSpriteNode
		let bankPageLocation = touch.location(in: bankPage)
		if bankOpen
		{
			for item in bankPage.children as! [SKSpriteNode]
			{
				if item.contains(bankPageLocation) && item.texture!.description != backgroundTexture.description
				{
					var temp = item as Any
					addToInventory(input: &temp)
					removeItem(touch: touch, storageName: "bankPage", storageArray: &bankArray)
				}
			}
		}
	}
	
	func smeltFurnace()
	{
		let furnacePage = stationaryNode.childNode(withName: "furnacePage") as! SKSpriteNode
		for item in furnacePage.children as! [SKSpriteNode]
		{
			//change texture of all ores to ironBar
			if item.texture!.description != backgroundTexture.description && item.name != "14"
			{
				//print("smelting...")
				let itemColor = item.color
				item.texture = SKTexture(imageNamed: "ironBar")
				item.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
			}
		}
		
	}
	
	
	func withdrawOrRunFurnace(touch: UITouch) {
		let furnacePage = stationaryNode.childNode(withName: "furnacePage") as! SKSpriteNode
		let bankPageLocation = touch.location(in: furnacePage)
		if furnaceOpen
		{
			for item in furnacePage.children as! [SKSpriteNode]
			{
				
				if item.contains(bankPageLocation) && item.texture!.description != backgroundTexture.description && item.name != "14"
				{
					var temp = item as Any
					addToInventory(input: &temp)
					removeItem(touch: touch, storageName: "furnacePage", storageArray: &furnaceArray)
				}
				else if (item.contains(bankPageLocation) && item.name == "14")
				{
					//print("NEED TO ADD XP ,smelt button clicked")
					smeltFurnace()
				}
			}
		}
	}
	
	func monsterDrop(monster: inout Character) {
		let randTier = Int.random(in: 1...10)
		let colorizeAction = colorizeTier(tier: randTier)
		for child in tileNode?.children as! [SKSpriteNode]
		{
			
			if child.contains(monster.position) {
				let randDrop = Int.random(in: 1...7)
				var texture: SKTexture!
				var size: CGSize!
				if randDrop == 1
				{
					texture = SKTexture(imageNamed: "boots")
					size = CGSize(width: child.size.width/4, height: child.size.width/4)
				}
				else if randDrop == 2
				{
					texture = SKTexture(imageNamed: "legs")
					size = CGSize(width: child.size.width/4, height: child.size.width/2)

				}
				else if randDrop == 3
				{
					texture = SKTexture(imageNamed: "chest")
					size = CGSize(width: child.size.width/2, height: child.size.width/2)
					
				}
				else if randDrop == 4
				{
					texture = SKTexture(imageNamed: "helm")
					size = CGSize(width: child.size.width/4, height: child.size.width/4)
					
				}
				else if randDrop == 5
				{
					texture = SKTexture(imageNamed: "sword")
					size = CGSize(width: child.size.width/4, height: child.size.width)
					
				}
				else if randDrop == 6
				{
					texture = SKTexture(imageNamed: "bow")
					size = CGSize(width: child.size.width, height: child.size.width)
					
				}
				else if randDrop == 7
				{
					texture = SKTexture(imageNamed: "staff")
					size = CGSize(width: child.size.height*5/12, height: child.size.height)
					
				}
				let weapon = Weapon(texture: texture, size: size, tier: randTier, name: "droppedItem")
				
				weapon.name = "droppedItem"
				weapon.position = CGPoint(x: 0, y: 0)
				weapon.zPosition = 0
				weapon.run(colorizeAction)
				child.addChild(weapon)
				
			}
		}
		
	}
	
	func beginDragItem(touch: UITouch) {
		let location = touch.location(in: stationaryNode)
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		let inventoryPageLocation = touch.location(in: inventoryPage)
		

		if inventoryPage.contains(location) {
			for item in inventoryPage.children as! [SKSpriteNode]
			{
				if item.contains(inventoryPageLocation) && item.texture!.description != backgroundTexture.description
				{
					beginTouchPoint = location
					dragged = true
					draggedItem = item.copy() as? SKSpriteNode
					beginDraggingTile = item
				}
			}
		}
	}
	
	func dragItem(touch: UITouch) {
		let location = touch.location(in: stationaryNode)
		var pythagDistance:CGFloat = 0
		if draggedItem != nil {
			pythagDistance = pow((pow(beginTouchPoint.x-location.x,2) + pow(beginTouchPoint.y-location.y,2)), 0.5)
		}
		if dragged && pythagDistance > distanceBetweenTiles/8
		{
			beginDrag = false
			draggedItem.zPosition = 2
			stationaryNode.addChild(draggedItem)
			beginDraggingTile.texture = backgroundTexture
			dragged = false
			itemBeingDragged = true
		}
		if itemBeingDragged {
			draggedItem.position = location
		}
		
	}
	
	func handleItemDragEnd(touch: UITouch) {
		if itemBeingDragged == true
		{
			let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
			let draggedItemPosition = touch.location(in: inventoryPage)
			if inventoryPage.contains(draggedItem.position)
			{
				for item in inventoryPage.children as! [SKSpriteNode]
				{
					if item.contains(draggedItemPosition) {
						
						let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
						let encodeArrayIndex = encodeArray.firstIndex(of: item.name!)!
						let encodeArrayStartIndex = encodeArray.firstIndex(of: beginDraggingTile.name!)!
						
						if inventoryArray[encodeArrayIndex] == 0
						{
							item.texture = draggedItem.texture
							inventoryArray[encodeArrayStartIndex] = 0
						}
						else
						{
							beginDraggingTile.texture = item.texture
							let itemColor = item.color
							if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
								beginDraggingTile.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
							}
							item.texture = draggedItem.texture
							
						}
						let draggedItemColor = draggedItem.color
						if draggedItemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
							item.run(SKAction.colorize(with: draggedItemColor, colorBlendFactor: 1, duration: 0))
						}
						inventoryArray[encodeArrayIndex] = 1
						
					}
				}
			}
			else
			{
				dropItemItem()
			}
			draggedItem.removeFromParent()
		}
		else
		{
			dropItem(touch: touch)
			withdrawFromBank(touch: touch)
			withdrawOrRunFurnace(touch: touch)
			smithAnvil(touch: touch)
			fletchLogs(touch: touch)
			respondToTouch(touch: touch)
			pickupItem(touch: touch)
		}
		beginDrag = false
		itemBeingDragged = false
		dragged = false
	}

	func smithAnvil(touch: UITouch)
	{
		//text if touch has hit any element in ["boots", "chest", "helm", "legs", "pickaxe", "axe"] and test accordingly
		let anvilPage = stationaryNode.childNode(withName: "anvilPage") as! SKSpriteNode
		//let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		let anvilPageTouchLocation = touch.location(in: anvilPage)
		
		for clickIcon in anvilPage.children as! [SKSpriteNode]
		{
			if (clickIcon.contains(anvilPageTouchLocation))
			{
				//print("clickIcon contains: ", clickIcon.texture?.description)
				let armorPieceToBuild = clickIcon.texture?.description
				let bootsTextureDescriptor = SKTexture(imageNamed: "boots").description
				let helmTextureDescriptor = SKTexture(imageNamed: "helm").description
				let chestTextureDescriptor = SKTexture(imageNamed: "chest").description
				let legsTextureDescriptor = SKTexture(imageNamed: "legs").description
				let pickaxeTextureDescriptor = SKTexture(imageNamed: "pickaxe").description
				let axeTextureDescriptor = SKTexture(imageNamed: "axe").description
				//let ironBarDescriptor = SKTexture(imageNamed: "ironBar").description
				//let backgroundTextureDescriptor = SKTexture(imageNamed: "backgroundImage").description
				
				//var ironBarCount = 0
				
				
				//smith boots
				if (armorPieceToBuild == bootsTextureDescriptor)
				{smithArmor(piece: "boots", barCost: 1)}
					
				else if (armorPieceToBuild == helmTextureDescriptor)
				{smithArmor(piece: "helm", barCost: 2)}
					
				else if (armorPieceToBuild == chestTextureDescriptor)
				{smithArmor(piece: "chest", barCost: 3)}
					
				else if (armorPieceToBuild == legsTextureDescriptor)
				{smithArmor(piece: "legs", barCost: 3)}
					
				else if (armorPieceToBuild == pickaxeTextureDescriptor)
				{smithArmor(piece: "pickaxe", barCost: 1)}
					
				else if (armorPieceToBuild == axeTextureDescriptor)
				{smithArmor(piece: "axe", barCost: 1)}
			}
		}
	}
	func smithArmor(piece: String, barCost: Int)
	{
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		let ironBarDescriptor = SKTexture(imageNamed: "ironBar").description
		//let backgroundTextureDescriptor = SKTexture(imageNamed: "backgroundImage").description
		
		let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
		var barsArray:[SKSpriteNode] = []
		
		
		//loop through to find iron bars and slots where they are
		for item in inventoryPage.children as! [SKSpriteNode]
		{
			//found an iron bar
			if (item.texture?.description == ironBarDescriptor)
			{barsArray.append(item)}
			
			//if have enough bars, got the info needed
			if (barsArray.count == barCost)
			{
				//set the three textures in barsArray to bkgd
				for bar in barsArray
				{
					bar.texture = SKTexture(imageNamed: "backgroundImage")
					//update inventory array
					let encodeArrayIndex = encodeArray.firstIndex(of: bar.name!)!
					inventoryArray[encodeArrayIndex] = 0
					barsArray = []
				}
				
				//find first 0 in inventory array and set that to piece String
				var temp: Any = SKSpriteNode(texture: SKTexture(imageNamed: piece))
				addToInventory(input: &temp)
				
				break
			}
			
		}
		
		
		print("iron bars at: ", barsArray)
		
		
		
		
	}
	
	func dropItemItem(){
		for child in tileNode?.children as! [SKSpriteNode]
		{
			let linkPositionInMovingNode = CGPoint(x: -movingNode.position.x, y: -movingNode.position.y)
			if child.contains(linkPositionInMovingNode) {
				let droppedItem = draggedItem.copy() as! SKSpriteNode
				droppedItem.texture = draggedItem.texture
				droppedItem.size = CGSize(width: droppedItem.size.width/2, height: droppedItem.size.height/2)
				droppedItem.position = CGPoint(x: 0, y: 0)
				droppedItem.zPosition = 0
				droppedItem.name = "droppedItem"
				child.addChild(droppedItem)
				
				let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
				let encodeArrayIndex = encodeArray.firstIndex(of: draggedItem.name!)!
				inventoryArray[encodeArrayIndex] = 0
				
				let itemColor = draggedItem.color
				if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
					droppedItem.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
				}
				
			}
		}
	}
	
	
	
	// drop item over tile where link is upon double click
	func dropItem(touch: UITouch) {
		let location = touch.location(in: stationaryNode)
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		let inventoryPageLocation = touch.location(in: inventoryPage)
		if bankOpen
		{
			for item in inventoryPage.children as! [SKSpriteNode]
			{
				if item.contains(inventoryPageLocation) && item.texture!.description != backgroundTexture.description
				{
					var temp = item as Any
					addToBank(input: &temp)
					removeItem(touch: touch, storageName: "inventoryPage", storageArray: &inventoryArray)

				}
			}
		}
		else if furnaceOpen
		{
			for item in inventoryPage.children as! [SKSpriteNode]
			{
				if item.contains(inventoryPageLocation) && item.texture!.description == SKTexture(imageNamed: "gold_rock").description
				{
					var temp = item as Any
					addToFurnace(input: &temp)
					removeItem(touch: touch, storageName: "inventoryPage", storageArray: &inventoryArray)
					
				}
			}
		}
			
		else
		{
			
			if inventoryPage.contains(location) {
				for item in inventoryPage.children as! [SKSpriteNode]
				{
					if item.contains(inventoryPageLocation) && item.texture!.description != backgroundTexture.description
					{
						let storedTexture = item.texture
						let link = stationaryNode.childNode(withName: "link") as! Character
						var containsGear = true
						
						var name: String!
						
						var gear: SKSpriteNode!
						if storedTexture?.description == SKTexture(imageNamed: "boots").description
						{
							
							name = "boots"
							gear = SKSpriteNode(texture: SKTexture(imageNamed: "boots"))
							gear.name = "boots"
							gear.size = CGSize(width: link.size.width*3/5, height: link.size.width/4)
							gear.position = CGPoint(x: 0, y: -link.size.height/2)
						}
						else if storedTexture?.description == SKTexture(imageNamed: "legs").description
						{
							
							name = "legs"

							gear = SKSpriteNode(texture: SKTexture(imageNamed: "legs"))
							gear.name = "legs"
							gear.size = CGSize(width: link.size.width*2/5, height: link.size.height/3)
							gear.position = CGPoint(x: 0, y: -link.size.height/4)
						}
						else if storedTexture?.description == SKTexture(imageNamed: "chest").description
						{
							
							name = "chest"

							gear = SKSpriteNode(texture: SKTexture(imageNamed: "chest"))
							gear.name = "chest"
							gear.size = CGSize(width: link.size.width*2/3, height: link.size.width/2)
							gear.position = CGPoint(x: 0, y: link.size.height/12)
						}
						else if storedTexture?.description == SKTexture(imageNamed: "helm").description
						{
							
							name = "helm"

							gear = SKSpriteNode(texture: SKTexture(imageNamed: "helm"))
							gear.name = "helm"
							gear.size = CGSize(width: link.size.width/2.5, height: link.size.width/2.5)
							gear.position = CGPoint(x: 0, y: link.size.height*4/9)
						}
						else if storedTexture?.description == SKTexture(imageNamed: "sword").description
						{
							
							name = "linkSword"

							gear = SKSpriteNode(texture: SKTexture(imageNamed: "sword"))
							gear.name = "linkSword"
							gear.size = CGSize(width: link.size.width/3, height: link.size.width)
							gear.position = CGPoint(x: link.size.width/3, y: -link.size.height/10)
							gear.anchorPoint = CGPoint(x: 0.5, y: 0)
							meleeOn = true
							rangedOn = false
							magicOn = false
						}
						else if storedTexture?.description == SKTexture(imageNamed: "bow").description
						{
							
							name = "bow"
							
							gear = SKSpriteNode(texture: SKTexture(imageNamed: "bow"))
							gear.name = "bow"
							gear.size = CGSize(width: link.size.width, height: link.size.width)
							gear.position = CGPoint(x: link.size.width/3, y: -link.size.height/10)
							gear.anchorPoint = CGPoint(x: 0.5, y: 0)
							meleeOn = false
							rangedOn = true
							magicOn = false
						}
						else if storedTexture?.description == SKTexture(imageNamed: "staff").description
						{
							
							name = "staff"
							
							gear = SKSpriteNode(texture: SKTexture(imageNamed: "staff"))
							gear.name = "staff"
							gear.size = CGSize(width: link.size.height*5/12, height: link.size.height)
							gear.position = CGPoint(x: link.size.width/3, y: -link.size.height/10)
							gear.anchorPoint = CGPoint(x: 0.5, y: 0)
							meleeOn = false
							rangedOn = false
							magicOn = true
						}
						else
						{
							containsGear = false
						}
						
						
						if containsGear {
							let itemColor = item.color
							item.texture = backgroundTexture
							let encodeArray = ["41","42","43","44","31","32","33","34","21","22","23","24","11","12","13","14"]
							let encodeArrayIndex = encodeArray.firstIndex(of: item.name!)!
							inventoryArray[encodeArrayIndex] = 0
							
							for child in link.children as! [SKSpriteNode]
							{
								var match = false
								if child.name == "linkSword" || child.name == "bow" || child.name == "staff" {
									if name == "linkSword" || name == "bow" || name == "staff" {
										match = true
									}
								} else {
									if child.name == name {
										match = true
									}
								}
								if match {
									var temp = child as Any
									addToInventory(input: &temp)
									let childName = child.name
									let childTier = getTierFromColor(color: child.color)
									if childName == "boots" || childName == "helm" || childName == "legs" || childName == "chest"
									{
										link.addEffectiveLvl(combatParam: "defense", tier: -childTier)
									}
									else if childName == "linkSword"
									{
										link.addEffectiveLvl(combatParam: "attack", tier: -childTier)
										link.addEffectiveLvl(combatParam: "strength", tier: -childTier)
										
									}
									else if childName == "bow"
									{
										link.addEffectiveLvl(combatParam: "ranged", tier: -childTier)
									}
									else if childName == "staff"
									{
										link.addEffectiveLvl(combatParam: "magic", tier: -childTier)
										
									}
									child.removeFromParent()
								}
							}
							link.addChild(gear)
							let colorTier = getTierFromColor(color: itemColor)
							if name == "boots" || name == "helm" || name == "legs" || name == "chest"
							{
								link.addEffectiveLvl(combatParam: "defense", tier: colorTier)
							}
							else if name == "linkSword"
							{
								link.addEffectiveLvl(combatParam: "attack", tier: colorTier)
								link.addEffectiveLvl(combatParam: "strength", tier: colorTier)

							}
							else if name == "bow"
							{
								link.addEffectiveLvl(combatParam: "ranged", tier: colorTier)
							}
							else if name == "staff"
							{
								link.addEffectiveLvl(combatParam: "magic", tier: colorTier)

							}
							if itemColor != UIColor(red: 1, green: 1, blue: 1, alpha: 0) {
								gear.run(SKAction.colorize(with: itemColor, colorBlendFactor: 1, duration: 0))
							}
						}
					}
				}
			}
		}
	}
	
	
	
	// pickup
	func pickupItem(touch: UITouch) {
		let location = touch.location(in: movingNode)
		
		for child in tileNode?.children as! [SKSpriteNode]
		{
			if child.contains(location)
			{
				if let droppedItem = child.childNode(withName: "droppedItem") as? SKSpriteNode
				{
					var temp = droppedItem as Any
					addToInventory(input: &temp)
					droppedItem.removeFromParent()
				}
				
				
			}
		}
		
	}
	//nikhil added on 9.16
	/***********************************************************
	func fletchLogs(touch: UITouch)
	{
	let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
	let cutLogsDescriptor = SKTexture(imageNamed: "cutLogs").description
	
	for item in inventoryPage.children as! [SKSpriteNode]
	{
	if item.contains(touch.location(in: inventoryPage)) && item.texture!.description == logsDescriptor
	{
	//createFletchPage
	}
	}
	}
	*/
	
	func createFletchMenu(page: inout SKSpriteNode)
	{
		//make 4x3 grid
		let yArray = [-3,-1,1,3]
		let xArray = [-3,-1,1,3]
		
		var makeableItemsArray = ["staff", "bow"]
		//var makeableItemsCount = 0
		
		for i in 0...yArray.count-1
		{
			let y = page.size.height * CGFloat(yArray[i])/8
			
			for j in 0...xArray.count-1
			{
				//panel in grid
				var panelTextureString = ""
				//let pageName = page.name
				
				if ((i+1 == 3  && j+1 == 3) || (i+1 == 3 && j+1 == 4)) {panelTextureString = makeableItemsArray.popLast() ?? "backgroundImage"}
				else
				{
					panelTextureString = "backgroundImage"
				}
				
				let panelTexture = SKTexture(imageNamed: panelTextureString)
				//makeableItemsCount += 1
				
				let inventoryPanel = SKSpriteNode(texture: panelTexture)
				
				let x = page.size.width * CGFloat(xArray[j])/8
				inventoryPanel.position = CGPoint(x: x, y: y)
				inventoryPanel.size = CGSize(width: page.size.width/4*9.5/10, height: page.frame.height/4*9.2/10)
				inventoryPanel.name = "\(i+1)\(j+1)"
				page.addChild(inventoryPanel)
				
				
				
				//level and percent labels??
				let countLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
				countLabel.text = ""
				countLabel.name = "countLabel"
				countLabel.position = CGPoint(x: inventoryPanel.size.width/20, y: inventoryPanel.size.height/8)
				countLabel.horizontalAlignmentMode = .left
				countLabel.fontSize = scale*10
				countLabel.fontColor = .black
				
				inventoryPanel.addChild(countLabel)
				
			}
			
			
		}
	}
	
	
	//nikhil added on 9.16
	func fletchLogs(touch: UITouch)
	{
		//print("running Fletchlogs")
		let cutLogsDescriptor = SKTexture(imageNamed: "cutLogs").description
		let inventoryPage = stationaryNode.childNode(withName: "inventoryPage") as! SKSpriteNode
		let touchPosition = touch.location(in: inventoryPage)

		if (fletchOpen)
		{
			
			
			print("fletch menu open.")
			//code goes here
			let fletchPage = stationaryNode.childNode(withName: "fletchPage") as! SKSpriteNode
			let fletchPageTouchLocation = touch.location(in: fletchPage)
			
			for clickIcon in fletchPage.children as! [SKSpriteNode]
			{
				if (clickIcon.contains(fletchPageTouchLocation))
				{
					//print("clickIcon contains: ", clickIcon.texture?.description)
					let armorPieceToBuild = clickIcon.texture?.description
					let staffTextureDescriptor = SKTexture(imageNamed: "staff").description
					let bowTextureDescriptor = SKTexture(imageNamed: "bow").description
					//let backgroundTextureDescriptor = SKTexture(imageNamed: "backgroundImage").description
					
					//var ironBarCount = 0
					
					
					
					//fletch staff
					if (armorPieceToBuild == staffTextureDescriptor)
					{
						print("clicked staff")
						//print(item.texture!.description)
						for item in inventoryPage.children as! [SKSpriteNode]
						{
							
							if (item.texture!.description == cutLogsDescriptor)
							{
								item.texture = SKTexture(imageNamed: "staff")
								return
							}
							
						}
						
						
					}
						
					else if (armorPieceToBuild == bowTextureDescriptor)
					{
						print("clicked bow")
						for item in inventoryPage.children as! [SKSpriteNode]
						{
							
							if (item.texture!.description == cutLogsDescriptor)
							{
								item.texture = SKTexture(imageNamed: "bow")
								return
							}
							
						}
						
					}
					
				}
				
			}
			
			return
		}
		
		
		for item in inventoryPage.children as! [SKSpriteNode]
		{
			
			if item.contains(touchPosition) && item.texture!.description == cutLogsDescriptor
			{
				print("clicked log!")
				//change texturs as below
				var fletchPage = self.stationaryNode.childNode(withName: "fletchPage") as! SKSpriteNode
				self.fletchOpen = true
				self.reappearPage(page: &fletchPage)
				break
			}
			
		}
		
		
	}
    
    
    func createObjectOnMap(name:String, positions:[(x: Int, y: Int)], parentNode: SKNode)
    {
        //add object nodes to selfNode hre
        //movingNode.addChild(parentNode)
        var count = 0
        
        for pos in positions
        {
            var allChildren: [SKSpriteNode] = []
            for child in rocksNode.children as! [SKSpriteNode]{
                allChildren.append(child)
            }
            for child2 in woodCuttingNode.children as! [SKSpriteNode] {
                allChildren.append(child2)
            }
            for child3 in fishingNode.children as! [SKSpriteNode] {
                allChildren.append(child3)
            }
            for child4 in monsterNode.children as! [SKSpriteNode] {
                allChildren.append(child4)
            }
            for child5 in bankNode.children as! [SKSpriteNode] {
                allChildren.append(child5)
            }
            for child6 in furnaceNode.children as! [SKSpriteNode] {
                allChildren.append(child6)
            }
            for child7 in anvilNode.children as! [SKSpriteNode] {
                allChildren.append(child7)
            }
            
            
            
            let xRand = Int.random(in: 1...columnNumber)
            let yRand = Int.random(in: 1...rowNumber*2+1)
            
            //let children = parentNode.children as! [SKSpriteNode]
            var isOverlap = false
            let randPoint = getCGPointAtPosition(x: pos.x, y: pos.y)
            let adjustedPoint = CGPoint(x: randPoint.x, y: randPoint.y)
            
            //check for overlaps
            for child in allChildren
            {
                let xDist = child.position.x-randPoint.x
                var yDist = child.position.y
                yDist-=randPoint.y
                let distance = pow(pow(xDist, 2)+pow(yDist, 2),0.5)
                if distance < 0.1
                {
                    isOverlap = true
                }
            }
            if !isOverlap
            {
                let randTier = Int.random(in: 1...1)
                let colorizeAction = colorizeTier(tier: randTier)
                
                //let temp = SKSpriteNode(texture: SKTexture(imageNamed: spriteFile))
                let resource = Resource(texture: SKTexture(imageNamed: name), size: CGSize(width: self.frame.height/7.5*aspectRatio, height: self.frame.height/7.5*aspectRatio), tier: randTier, name: "(spriteFile)\(count)")
                resource.run(colorizeAction)
                parentNode.addChild(resource)
                resource.position = adjustedPoint
                resource.zPosition = 1
            }
            count += 1
        }
        
    }
    

    
    
}





