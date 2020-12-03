//
//  Node.swift
//  GameEven
//
//  Created by Rogerio Lucon on 03/12/20.
//

import SpriteKit

extension SKSpriteNode {
    
    func resizeble(adjustPosX: Bool, adjustPosY: Bool){
        resizeble()
        adjustPosition(x: adjustPosX, y: adjustPosY)
    }
    
    func resizeble(_ adjustPos: Bool){
        resizeble()
        if adjustPos {
            adjustPosition()
        }
    }
    
    func resizeble(){
        
        let scale = scaleValue()
        
        self.size.width = self.size.width * scale
        self.size.height = self.size.height * scale
    }
    
    func adjustPosition(){
        adjustPosition(x: true, y: true)
    }
    
    func adjustPosition(x: Bool ,y: Bool){
        
        let scale = scaleValue()
        
        if x {
            self.position.x = self.position.x * scale
        }
        if y {
            self.position.y = self.position.y * scale
        }
    }
    
    func scaleValue() -> CGFloat {
        let baseWidth: CGFloat = 414
        let baseHeight: CGFloat = 896
        
        let screen = UIScreen.main.bounds
        
        var newDimension: CGFloat = 0
        var scale: CGFloat = 0
        
        if abs(baseWidth - screen.width) > abs(baseHeight - screen.height) {
            newDimension = screen.width
            scale = ((100 * newDimension) / baseWidth) / 100
        } else {
            newDimension = screen.height
            scale = ((100 * newDimension) / baseHeight) / 100
        }
        
        if scale > 2 {
            scale = 2
        }
        
        return scale
    }
}
