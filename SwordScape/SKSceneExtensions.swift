//
//  SKSceneExtensions.swift
//  SwordScape


import SpriteKit
import GameplayKit
import Darwin

extension GameScene {
	
	// determines scales and aspect ratios based on screen
	func setUpScaleAndNodes() {
		// get screen size
		
		let screenSize = UIScreen.main.bounds
		screenWidth = screenSize.width
		screenHeight = screenSize.height
		
		// define scales for aspect ratios
		
		if screenWidth <= 320 {
			scale = scale1
		} else if screenWidth <= 375 {
			scale = scale2
		} else if screenWidth <= 414 {
			scale = scale3
		} else if screenWidth <= 768 {
			scale = scale4
		} else if screenWidth <= 834 {
			scale = scale5
		} else if screenWidth <= 1024 {
			scale = scale6
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
		
		selfNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
		selfNode.zPosition = -3
		self.addChild(selfNode)
		
		tileNode = SKSpriteNode()
		selfNode.addChild(tileNode!)
		
		
		background = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		background.size = CGSize(width: self.frame.width, height: self.frame.height)
		background.position = CGPoint(x: 0, y: 0)
		background.zPosition = -2
		selfNode.addChild(background)
	}
	
	
	func initializeGame() {
		let size = CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale)
		
		link = Character(texture: SKTexture(imageNamed: "link.png"), size: size, attackSpd: 1)
		
		boss = Character(texture: SKTexture(imageNamed: "monster.png"), size: CGSize(width: self.frame.width/9/iconScale, height: self.frame.width/9/iconScale), attackSpd: 2)
		
		
		//link = SKSpriteNode(texture: SKTexture(imageNamed: "link.png"))
		healthBarLink = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		healthBarBoss = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImage.png"))
		createCharacter(charName: "link", name: "linkSword", position: CGPoint(x:0,y:0),sprite: &link, health: 100, healthBar: &healthBarLink)
		
		//boss = SKSpriteNode(texture: SKTexture(imageNamed: "monster.png"))
		createCharacter(charName: "boss", name: "bossSword",position: CGPoint(x:0,y:distanceBetweenTiles*4),sprite: &boss, health: 100, healthBar: &healthBarBoss)
		
		
		
		//pointer block
		pointer = SKSpriteNode()
		pointer.size = CGSize(width: self.frame.width/10/iconScale, height: self.frame.width/10/iconScale)
		pointer.position = CGPoint(x: 0, y: 0)
		pointer.zPosition = 1
		selfNode.addChild(pointer)
		
		timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(randomWalk), userInfo: nil, repeats: true)
		
	}
	
	func createCharacter(charName: String, name: String, position: CGPoint, sprite: inout Character, health: Int, healthBar: inout SKSpriteNode) {
		//link code block
		sprite.name = charName
		sprite.position = position
		selfNode.addChild(sprite)
		
		healthBar.size = CGSize(width: sprite.size.width, height: sprite.size.width/3)
		healthBar.position = CGPoint(x: sprite.position.x, y: sprite.position.y+sprite.size.height*2/3)
		healthBar.zPosition = 0
		selfNode.addChild(healthBar)
		
		
		let barHeight = healthBar.size.height*9/10
		let barLeftWidth = healthBar.size.width*19/20
		barLeft = SKSpriteNode(texture: numberTileTexture)
		barLeft.name = "barLeft"
		barLeft.size = CGSize(width: barLeftWidth, height:  barHeight)
		let xPos = -sprite.size.width*9.5/20
		barLeft.position = CGPoint(x: xPos, y: 0)
		barLeft.anchorPoint = CGPoint(x: 0, y: 0.5)
		barLeft.zPosition = 0
		healthBar.addChild(barLeft)
		
		barLeft.run(colorize(number: 8))
		
		let xPos2 = sprite.size.width*9.5/20
		barRight = SKSpriteNode(texture: numberTileTexture)
		barRight.name = "barRight"
		barRight.size = CGSize(width: 0, height: barHeight)
		barRight.position = CGPoint(x: xPos2, y: 0)
		barRight.anchorPoint = CGPoint(x: 1, y: 0.5)
		barRight.zPosition = 0
		healthBar.addChild(barRight)
		
		barRight.run(colorize(number: 7))
		
		
		sword = SKSpriteNode(texture: SKTexture(imageNamed: "sword"))
		sword.name = name
		sword.size = CGSize(width: sprite.size.width/3, height: sprite.size.width)
		sword.position = CGPoint(x: sprite.size.width/2, y: 0)
		sword.anchorPoint = CGPoint(x: 0.5, y: 0)
		
		sword.zPosition = 0
		
		sprite.addChild(sword)
		let fadeOut = SKAction.fadeOut(withDuration: 0)
		sword.run(fadeOut)
		
		
		hitBox = SKSpriteNode(texture: SKTexture(imageNamed: "hit"))
		hitBox.name = "hitBox"
		hitBox.size = CGSize(width: sprite.size.width, height: sprite.size.width)
		hitBox.position = CGPoint(x: 0, y: -sprite.size.height*2/3)
		hitBox.zPosition = 0
		healthBar.addChild(hitBox)
		hitBox.run(fadeOut)
		
		hitLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBold")
		hitLabel.text = ""
		hitLabel.fontSize = 30*scale
		hitLabel.fontColor = SKColor.white
		hitLabel.verticalAlignmentMode = .center
		hitLabel.position = CGPoint(x: 0, y: 0)
		hitBox.addChild(hitLabel)
		
	}
	// create game tiles for each row and column
	
	func createTiles(){
		
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
	func makeTileNodes(NodeLocation: CGPoint, randomNumber: Int){
		
		numberTile = SKSpriteNode(texture: createRandomTileTexture())
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
	
	
	
	func swipeAction(sprite: inout Character) -> SKAction {
		
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
	
	func determineHit(character: inout Character, healthBar: inout SKSpriteNode!) {
		
		if character.hitChance() == 1 {
			let charName = character.name
			let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
			box.removeAllActions()
			let barLeft = healthBar.childNode(withName: "barLeft") as! SKSpriteNode
			let barRight = healthBar.childNode(withName: "barRight") as! SKSpriteNode
			
			let bossBoxLabel = box.children[0] as! SKLabelNode
			bossBoxLabel.text = "1"
			box.texture = SKTexture(imageNamed: "hit")
			let wait1 = SKAction.wait(forDuration: 0)
			let fadeIn = SKAction.fadeIn(withDuration: 0.2)
			let wait2 = SKAction.wait(forDuration: 0.5)
			let fadeOut = SKAction.fadeOut(withDuration: 0.2)
			let removeHealth = SKAction.run({
				let originalHealth = box.size.width*19/20
				barLeft.size = CGSize(width: barLeft.size.width-originalHealth/10, height: barLeft.size.height)
				barRight.size = CGSize(width: barRight.size.width+originalHealth/10, height: barRight.size.height)
				if barLeft.size.width < 0.1 && charName == "link" {
					self.flagBoss = true
				} else if barLeft.size.width < 0.1 && charName == "boss" {
					self.flagLink = true
				}
			})
			let hitSequence = SKAction.sequence([wait1,fadeIn,removeHealth,wait2,fadeOut])
			//print("here")
			box.run(hitSequence)
		} else {
			let box = healthBar.childNode(withName: "hitBox") as! SKSpriteNode
			box.removeAllActions()
			
			let bossBoxLabel = box.children[0] as! SKLabelNode
			bossBoxLabel.text = "0"
			box.texture = SKTexture(imageNamed: "miss")
			let fadeIn = SKAction.fadeIn(withDuration: 0.2)
			let wait1 = SKAction.wait(forDuration: 0)
			let wait2 = SKAction.wait(forDuration: 0.5)
			let fadeOut = SKAction.fadeOut(withDuration: 0.2)
			
			let hitSequence = SKAction.sequence([wait1,fadeIn,wait2,fadeOut])
			box.run(hitSequence)
		}
	}
	
	
	
	func runCombat() {
		
		link.getAttackLVL()
		if linkAttacking == false  {
			//print("here")
			link.zRotation = atan2((link.position.y-boss.position.y),(link.position.x-boss.position.x)) + CGFloat.pi/2
			linkAttacking = true
			//link.addAttackXP(amount: 10)
			let sword = link.childNode(withName: "linkSword") as! SKSpriteNode
			sword.run((swipeAction(sprite: &link)), completion: {
				print ("here1")
				let wait1 = SKAction.wait(forDuration: self.linkAttackSpeed)
				sword.run((wait1), completion: {
					self.linkAttacking = false
				})
				self.determineHit(character: &self.link, healthBar: &self.healthBarBoss)
				
			})
		}
		if bossAttacking == false  {
			boss.zRotation = atan2((boss.position.y-link.position.y),(boss.position.x-link.position.x)) + CGFloat.pi/2
			bossAttacking = true
			let sword = boss.childNode(withName: "bossSword") as! SKSpriteNode
			sword.run((swipeAction(sprite: &boss)), completion: {
				let wait1 = SKAction.wait(forDuration: self.bossAttackSpeed)
				sword.run((wait1), completion: {
					self.bossAttacking = false
				})
				self.determineHit(character: &self.boss, healthBar: &self.healthBarLink)
			})
		}
		
	}
	
	func createRandomTileTexture()->SKTexture {
		var imgListArray :[SKTexture] = []
		for countValue in 1...6 {
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
	
	// random boss movement
	
	@objc func randomWalk() {
		
		var nextMoveArray:[CGPoint] = []
		for child in (tileNode?.children)! as! [SKSpriteNode] {
			let adjustedDist = distanceBetweenTiles*5/4
			if child.position != boss.position && (child.position.x >= boss.position.x-adjustedDist && child.position.x <= boss.position.x+adjustedDist) && (child.position.y >= boss.position.y-adjustedDist && child.position.y <= boss.position.y+adjustedDist) && (child.position.x == boss.position.x || child.position.y == boss.position.y ) {
				nextMoveArray.append(child.position)
			}
		}
		let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
		let time:TimeInterval = 0.4
		let moveAction = SKAction.move(to: randMove, duration: time)
		boss.run(moveAction)
		boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
		let yMove = randMove.y+boss.size.height*2/3
		let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
		healthBarBoss.run(healthMoveAction)
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
		let healthMoveAction = SKAction.move(to: CGPoint(x: movePosition.x, y: yMove), duration: time)
		healthBarLink.run(healthMoveAction)
		link.run(moveAction)
		link.zRotation = atan2((durFuncDistY),(durFuncDistX)) + CGFloat.pi/2
	}
	// determine what side the boss is in relation to link
	
	func getQuadrant(movePosition: CGPoint)->CGPoint {
		let relativePositionX = boss.position.x - link.position.x
		let relativePositionY = boss.position.y - link.position.y
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
		if boss != nil && link != nil {
			let xDiff = abs(link.position.x - boss.position.x)
			let yDiff = abs(link.position.y - boss.position.y)
			let dist = distanceBetweenTiles*5/10
			if xDiff < dist && yDiff < dist {
				if !bossIsBoucing {
					boss.removeAllActions()
					healthBarBoss.removeAllActions()
					bossIsBoucing = true
					var nextMoveArray:[CGPoint] = []
					for child in (tileNode?.children)! as! [SKSpriteNode] {
						let adjustedDist = distanceBetweenTiles*5/4
						let pythagDist = pow((pow(child.position.x - boss.position.x,2) + pow(child.position.y - boss.position.y,2)), 0.5)
						let pyDist = distanceBetweenTiles*10/9
						if !child.contains(boss.position) && (child.position.x >= boss.position.x-adjustedDist && child.position.x <= boss.position.x+adjustedDist) && (child.position.y >= boss.position.y-adjustedDist && child.position.y <= boss.position.y+adjustedDist) && (!child.contains(boss.position)) && pythagDist < pyDist  {
							nextMoveArray.append(child.position)
						}
					}
					
					let randMove = nextMoveArray[Int.random(in: 0 ... nextMoveArray.count-1)]
					boss.zRotation = atan2((-randMove.y+boss.position.y),(-randMove.x+boss.position.x)) + CGFloat.pi/2
					
					let time:TimeInterval = 0.2
					let moveAction = SKAction.move(to: randMove, duration: time)
					let wait = SKAction.wait(forDuration: 1)
					let sequence = SKAction.sequence([moveAction,wait])
					boss.run((sequence), completion: {
						self.bossIsBoucing = false
					})
					let yMove = randMove.y+boss.size.height*2/3
					let healthMoveAction = SKAction.move(to: CGPoint(x: randMove.x, y: yMove), duration: time)
					let sequence2 = SKAction.sequence([healthMoveAction,wait])
					healthBarBoss.run(sequence2)
				}
			}
		}
	}
	
	// update the boss position when following link
	
	func updateBossPos(speed:CGFloat) {
		if !bossIsBoucing && boss != nil && link != nil {
			let durFuncDistX = link.position.x - boss.position.x
			let durFuncDistY = link.position.y - boss.position.y
			let pythagDistance = pow((pow(durFuncDistX,2) + pow(durFuncDistY,2)), 0.5)
			let time:TimeInterval = TimeInterval(pythagDistance/CGFloat(200))
			if pythagDistance <= distanceBetweenTiles*1.1 {
				runCombat()
			} else if pythagDistance < distanceBetweenTiles*3 {
				if timer != nil {
					timer!.invalidate()
					timer = nil
				}
				
				var movePosition = link.position
				for child in (tileNode?.children)! as! [SKSpriteNode] {
					if child.contains(link.position) {
						movePosition = child.position
					}
				}
				movePosition = CGPoint(x: getQuadrant(movePosition: movePosition).x, y: getQuadrant(movePosition: movePosition).y)
				let moveAction = SKAction.move(to: movePosition, duration: time*2)
				boss.run(moveAction)
				boss.zRotation = atan2((-movePosition.y+boss.position.y),(-movePosition.x+boss.position.x)) + CGFloat.pi/2
				let yMove = movePosition.y+boss.size.height*2/3
				let healthMoveAction = SKAction.move(to: CGPoint(x: movePosition.x, y: yMove), duration: time*2)
				healthBarBoss.run(healthMoveAction)
			} else {
				if timer == nil {
					timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(randomWalk), userInfo: nil, repeats: true)
				}
			}
		}
	}
}

