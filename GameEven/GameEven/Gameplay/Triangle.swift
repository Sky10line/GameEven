//
//  Triangle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import UIKit
import GameplayKit
import Foundation

class Triangle: Draggable, DraggableProtocol{
    private var path: CGPath?
    private var points: [CGPoint] = []
    private var thirdPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    private let firstPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let secondPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let thirdPoint1 = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    
    private var p1: CGPoint!
    private var p2: CGPoint!
    private var p3: CGPoint!
    
    func getName() -> String {
        return self.spriteNode!.name!
    }
    
    func getPos() -> CGPoint {
        return self.spriteNode!.position
    }
    
    func setThirdPoint(Point: CGPoint){
        self.thirdPoint = Point
    }
    
    func insertCollider(){
        let width = self.spriteNode!.size.width
        let height = self.spriteNode!.size.height

        let offsetX = -width/2;
        let offsetY = -height/2;

        let node = self.spriteNode!
        
        node.addChild(firstPoint)
        node.addChild(secondPoint)
        node.addChild(thirdPoint1)
        
        //create points on node
        firstPoint.position = CGPoint(x: offsetX, y: offsetY)
        secondPoint.position = CGPoint(x: offsetX * (-1), y: offsetY)
        
        
        //====================
        
        // Recorta a primeira linha de pixels do topo da imagem.
        let topPixelLine = self.spriteNode?.texture?.cgImage().cropping(to: CGRect(x: 0, y: 0, width: (self.spriteNode?.texture?.cgImage().width)!, height: 1))

        // Transforma em data a primeira linha de pixels.
        let dataOfLine = CFDataGetBytePtr(topPixelLine?.dataProvider?.data)
        
        var thirdTrianglePoint = 0

        // Testa de forma bruta toda a sequência de pixels.
            for x in 0..<Int((self.spriteNode?.texture?.cgImage().width)!) {
                let pixelIndex = (((Int((self.spriteNode?.texture?.cgImage().width)!) * 1) + x) * 4)

        
                // Se o valor em pixelIndex+3 (posição em que fica o Alpha do pixel) for diferente de 0.
                if dataOfLine![pixelIndex+3] != 0 {
                    
                    // Então encontrou o X do ponto.
                    thirdTrianglePoint = x

                    print(" - - - - X do ThirdPoint: \(x) - - - - ")
                    break
                }
        }
        
        // Acha a escala comparando o tamanho da imagem com o tamanho do spriteNode.
        let scale = Float(self.spriteNode!.size.height) / Float(self.spriteNode!.texture!.cgImage().height)
        
        // Encontra o terceiro ponto, aplicando a escala no X do ponto.
        let thirdPointScaled = CGPoint(x: CGFloat(Float(thirdTrianglePoint) * scale) + offsetX, y: offsetY * (-1))
        
        // Define a posição do spriteNode para a posição do terceiro ponto escalonado.
        thirdPoint1.position = thirdPointScaled
        
        //====================
        
        self.spriteNode?.physicsBody = SKPhysicsBody(texture: self.spriteNode!.texture!, size: self.spriteNode!.size)
        
        if let pb = self.spriteNode?.physicsBody {
            pb.categoryBitMask = 1
            pb.collisionBitMask = 1
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
    }
    
    func checkInside(back: SKNode, scene: SKNode) -> Bool{
        
        //convert points of the node to view points 
        p1 = scene.convert(firstPoint.position, from: self.spriteNode!)
        p2 = scene.convert(secondPoint.position, from: self.spriteNode!)
        p3 = scene.convert(thirdPoint1.position, from: self.spriteNode!)
        
        if(back.contains(p1) && back.contains(p2) && back.contains(p3)) { //checa primeiro em cima e embaixo
                return true
        }
        return false
    }
}
