
import Foundation
import SpriteKit
import Darwin


class Character: SKSpriteNode {
	
	private var character:SKSpriteNode!
	private var attackSpeed: Int!
	public var attackXP: Int = 0
	public var defenseXP: Int = 0
	public var strengthXP: Int = 0
	public var hpXP: Int = 0
	public var health: Int = 0
	public var rangedXP: Int = 0
	public var magicXP: Int = 0
	public var miningXP: Int = 0
	public var woodCuttingXP: Int = 0
	public var deadFlag = false
	public var inCombat = false
	public var attacking = false
	public var isBouncing = false
	public var isRandomWalking = false
	public var autoRetaliate = true
	public var fishingXP: Int = 0
	

	
	let numberTileTexture = SKTexture(imageNamed: "scrabbleTile.png")

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(texture: SKTexture?, size :CGSize, attackSpd: Int) {
		
		super.init(texture: texture, color: UIColor.clear, size: size)
		character = SKSpriteNode(texture: texture)
		character.texture = texture
		character.size = size
		
		attackSpeed = attackSpd
	}
	
	public func addAttackXP(amount: Int) {
		//print (attackXP)
		attackXP += amount
	}
	public func addDefenseXP(amount: Int) {
		defenseXP += amount
	}
	public func addStrengthXP(amount: Int) {
		strengthXP += amount
	}
	public func addhpXP(amount: Int) {
		hpXP += amount
	}
	
	public func addRangedXP(amount: Int) {
		rangedXP += amount
	}
	
	public func addMagicXP(amount: Int) {
		magicXP += amount
	}
	public func addMiningXP(amount: Int) {
		miningXP += amount
	}
	
	public func addWoodCuttingXP(amount: Int) {
		woodCuttingXP += amount
	}
	
	public func addFishingXP(amount: Int) {
		fishingXP += amount
	}
	
	private func getLvl(input: Int)->Int{
		if input == 0 {
			return 1
		}
		//let inside = log(0.000357143*(3*input+2800))
		
		return Int(8.82389*log(0.000357143*(3*Double(input)+2800)))+1
	}
	
	public func getAttackLVL()->Int {
		return getLvl(input: attackXP)
	}
	
	public func getStrLvl()->Int {
		return getLvl(input: strengthXP)

	}
	public func getDefLvl()->Int {
		return getLvl(input: defenseXP)
	}
	
	public func getHpLvl()->Int {
		return getLvl(input: hpXP)
	}
	
	public func getRangedLvl()->Int {
		return getLvl(input: rangedXP)
	}
	
	public func getMagicLvl()->Int {
		return getLvl(input: magicXP)
	}
	
	public func getMiningLvl()->Int {
		return getLvl(input: miningXP)
	}
	
	public func getWoodCuttingLvl()->Int {
		return getLvl(input: woodCuttingXP)
	}
	public func getFishingLvl()->Int {
		return getLvl(input: fishingXP)
	}
	
	public func getxpToNextLevel(xp: Int, lvl: Int)->Int {
		var xpSum = 0
		for i in 1...lvl {
			xpSum += Int(100*pow(Double(1.12), Double(i)))
		}
		return xpSum - xp
	}
	
	public func getHP()->Int {
		return 20+getHpLvl()
	}
	
	public func hitAmount(combatStyle: String)->Int {
		if combatStyle == "melee" {
			return Int.random(in: 0 ... getStrLvl())
		} else if combatStyle == "ranged" {
			return Int.random(in: 0 ... getRangedLvl())
		} else if combatStyle == "magic" {
			return Int.random(in: 0 ... getMagicLvl())
		}
		return 0
	}
	
	public func hitChance(combatStyle: String, enemyDefenceLvl: Int)->Int {
		if combatStyle == "melee" {
			let defenseDifference = getAttackLVL()-enemyDefenceLvl
			//print (defenseDifference)
			return Int.random(in: 0 ... defenseDifference+1)
		} else if combatStyle == "ranged" {
			let defenseDifference = getRangedLvl()-enemyDefenceLvl
			return Int.random(in: 0 ... defenseDifference+1)
		} else if combatStyle == "magic" {
			let defenseDifference = getMagicLvl()-enemyDefenceLvl
			return Int.random(in: 0 ... defenseDifference+1)
		}
		return 0
	}
	
}
