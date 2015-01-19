//
//  DrawView.swift
//  PopDraw
//
//  Created by deast on 1/17/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class DrawView: UIView {
  
  var path : UIBezierPath
  var moveHandler: ((CGPoint) -> ())?
  var firstTouchHandler: ((CGPoint) -> ())?
  //var drawHandler: ((Dictionary<String, Double>) -> ())?
  
  required init(coder aDecoder: NSCoder) {
    path = UIBezierPath()
    super.init(coder: aDecoder)
    self.multipleTouchEnabled = false
    self.backgroundColor = UIColor.whiteColor()
    path.lineWidth = 2.0
  }
  
  func moveToFirstPoint(point: CGPoint) {
    path.moveToPoint(point)
  }
  
  func addPoint(point : CGPoint) {
    path.addLineToPoint(point)
    self.setNeedsDisplay()
  }
  
  override func drawRect(rect: CGRect) {
    UIColor.blackColor().setStroke()
    path.stroke()
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    var touch: AnyObject = touches.anyObject()!
    var p : CGPoint = touch.locationInView(self)
    firstTouchHandler?(p)
    //path.moveToPoint(p)
  }
  
  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    var touch: AnyObject = touches.anyObject()!
    var p : CGPoint = touch.locationInView(self)
    moveHandler?(p)
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    self.touchesMoved(touches, withEvent: event)
  }
  
  override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
    self.touchesMoved(touches, withEvent: event)
  }
  
  
}
