//
//  Rock.swift
//  SwordScape


import Foundation
import SpriteKit
import Darwin


class Resource: SKSpriteNode {
	public var isConsumed =  false
	public var tier:Int!
	private var resource: SKSpriteNode!
	public var resourceName: String!
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(texture: SKTexture?, size :CGSize, tier: Int, name: String) {
		
		super.init(texture: texture, color: UIColor.clear, size: size)
		resource = SKSpriteNode(texture: texture)
		resource.texture = texture
		resource.size = size
		self.tier = tier
		self.resourceName = name
	}
	
	public func getRequiredLvl()->Int {
		if tier < 2 {
			return (tier-1)*10+1
		} else if tier < 10 {
			return tier*10
		}
		return tier*10-1
	}
}
