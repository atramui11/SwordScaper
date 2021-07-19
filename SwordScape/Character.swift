//
//  Character.swift
//  SwordScape


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
		print (attackXP)
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
	
	public func getAttackLVL()->Int {
		let inside:Double = Double(Double(1000*attackXP)+933333)/Double(933333)
		let logVal = log(inside)
		return Int(1000000*logVal/113329)+1
	}
	
	public func getStrLvl()->Int {
		let inside:Double = Double(Double(1000*strengthXP)+933333)/Double(933333)
		let logVal = log(inside)
		return Int(1000000*logVal/113329)+1
	}
	
	public func getDefLvl()->Int {
		let inside:Double = Double(Double(1000*defenseXP)+933333)/Double(933333)
		let logVal = log(inside)
		return Int(1000000*logVal/113329)+1
	}
	
	public func getHpLvl()->Int {
		let inside:Double = Double(Double(1000*hpXP)+933333)/Double(933333)
		let logVal = log(inside)
		return Int(1000000*logVal/113329)+1
	}
	
	public func getHP()->Int {
		return 20+getHpLvl()
	}
	
	public func hitAmount()->Int {
		return Int.random(in: 0 ... getStrLvl())
	}
	
	public func hitChance(enemyDefenceLvl: Int)->Int {
		let defenseDifference = getAttackLVL()-enemyDefenceLvl
		return Int.random(in: 0 ... getAttackLVL())
	}
	
	
	
	
}
