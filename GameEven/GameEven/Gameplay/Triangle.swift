//
//  Triangle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import UIKit
import GameplayKit

class Triangle: Draggable, DraggableProtocol{
    private var path: CGPath?
    private var points: [CGPoint] = []
    private var thirdTrianglePoint: CGFloat = 0
    
    private let firstPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let secondPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let thirdPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    
    private var p1: CGPoint!
    private var p2: CGPoint!
    private var p3: CGPoint!
    
    func getName() -> String {
        return self.spriteNode!.name!
    }
    
    func getPos() -> CGPoint {
        return self.spriteNode!.position
    }
    
    func setThirdPoint(Point: CGFloat){
        self.thirdTrianglePoint = Point
    }
    
    func insertCollider(){
        
        let width = self.spriteNode!.size.width
        let height = self.spriteNode!.size.height
        
        let scale = Float(self.spriteNode!.size.height) / Float(self.spriteNode!.texture!.cgImage().height)

        let offsetX = -width/2;
        let offsetY = -height/2;
        
        points.insert(CGPoint(x: offsetX, y: offsetY), at: 0)
        points.insert(CGPoint(x: offsetX * (-1), y: offsetY), at: 1)
        points.insert(CGPoint(x: CGFloat(Float(thirdTrianglePoint) * scale) + offsetX, y: offsetY * (-1)), at: 2)

        let node = self.spriteNode!
        
        node.addChild(firstPoint)
        node.addChild(secondPoint)
        node.addChild(thirdPoint)
        
        //findThirdPoint()
        
        //create points on node
        firstPoint.position = CGPoint(x: points[0].x, y: points[0].y)
        secondPoint.position = CGPoint(x: points[1].x, y: points[1].y)
        thirdPoint.position = CGPoint(x: points[2].x, y: points[2].y)
        
        let path = CGMutablePath();

        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])

        path.closeSubpath()
        self.path = path
        
        self.spriteNode?.physicsBody = SKPhysicsBody(polygonFrom: path)
        
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
        p3 = scene.convert(thirdPoint.position, from: self.spriteNode!)
        
        if(back.contains(p1) && back.contains(p2) && back.contains(p3)) { //checa primeiro em cima e embaixo
                return true
        }
        return false
    }
    
    //MARK: Função de definição do terceiro ponto, não usar no programa
    func findThirdPoint(){
        //====================
        
        // Recorta a primeira linha de pixels do topo da imagem.
        let topPixelLine = self.spriteNode?.texture?.cgImage().cropping(to: CGRect(x: 0, y: 0, width: (self.spriteNode?.texture?.cgImage().width)!, height: 1))

        // Transforma em data a primeira linha de pixels.
        let dataOfLine = CFDataGetBytePtr(topPixelLine?.dataProvider?.data)
        
        var thirdTrianglePoint = 0
        
        var i = 0

        // Testa de forma bruta toda a sequência de pixels.
            for x in 0..<Int((self.spriteNode?.texture?.cgImage().width)!) {
                let pixelIndex = (((Int((self.spriteNode?.texture?.cgImage().width)!) * 1) + x) * 4)

                //i+=1
                //print(i)
                
                // Se o valor em pixelIndex+3 (posição em que fica o Alpha do pixel) for diferente de 0.
                if dataOfLine![pixelIndex+3] != 0 {
                    
                    // Então encontrou o X do ponto.
                    thirdTrianglePoint = x

                    print(" - - - - X do ThirdPoint: \(x) - - - - ")
                    break
            }
        }
    }
}
