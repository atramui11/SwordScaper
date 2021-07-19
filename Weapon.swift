//
//  Weapon.swift
//  SwordScape


import Foundation
import SpriteKit
import Darwin


class Weapon: SKSpriteNode {
	public var tier:Int!
	private var resource: SKSpriteNode!
	public var weaponName: String!
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(texture: SKTexture?, size :CGSize, tier: Int, name: String) {
		
		super.init(texture: texture, color: UIColor.clear, size: size)
		resource = SKSpriteNode(texture: texture)
		resource.texture = texture
		resource.size = size
		self.tier = tier
		self.weaponName = name
	}
	
	
}
