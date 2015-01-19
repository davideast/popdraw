//
//  RoomViewController.swift
//  PopDraw
//
//  Created by deast on 1/17/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//
//  TODO: Sandbox each user to their own drawings. Loop through
//        each user's coordinates and draw them on the page. Use
//        a start point to set the path's starting point and then
//        the rest of the coordinates for drawing.
//
//  <room-id>
//    / <path-id>
//        / <path-detail-id>
//          / x
//          / y
//
// Exp:
//
//  <room-id>
//    / startPoints
//      / <start-point-id>
//        / x
//        / y
//    / <paths>
//      / <start-pointid>
//        / x
//        / y
//
//  Listen for start points. When a start point is added, go read its associated path and draw the points

import UIKit

class RoomViewController: UIViewController {
  
  @IBOutlet var drawView: DrawView!
  
  var room = Room(id: "1", name: "First!!1")
  
  var ref = Firebase(url: "https://popdraw.firebaseio.com/")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var roomRef = ref.childByAppendingPath(room.id)
    var count = 0
    
    title = room.name
    
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    navigationItem.leftItemsSupplementBackButton = true
    
    drawView.moveHandler = { point in
      roomRef.childByAutoId().setValue([ "x": point.x, "y" : point.y])
    }
    
    roomRef.observeEventType(.ChildAdded, withBlock: { snapshot in
      
      if let xPoint = snapshot.value["x"] as? CGFloat {
        
        if let yPoint = snapshot.value["y"] as? CGFloat {
          
          var point = CGPointMake(xPoint, yPoint)
          if(count == 0) {
            self.drawView.moveToFirstPoint(point)
            count++
          } else {
            self.drawView.addPoint(point)
          }
        }
        
      }
      
    })
    
  }
  
  func dictionaryFromCGPoint(point: CGPoint) -> Dictionary<String, CGFloat> {
    return [ "x": point.x, "y": point.y ]
  }
  
  func CGPointFromAnyObject(anyobj: AnyObject) -> CGPoint {
    return CGPointMake(anyobj["x"] as CGFloat, anyobj["y"] as CGFloat)
  }
  
  func stringKeyFromCGPoint(point: CGPoint) -> String {
    return point.x.description + "-" + point.y.description
  }
  
  func CGPointFromString(pointString: String) -> CGPoint {
    var pointsArray = split(pointString) {$0 == "-"}
    var xPoint: CGFloat = CGFloatFromString(pointsArray[0])!
    var yPoint: CGFloat = CGFloatFromString(pointsArray[1])!
    return CGPointMake(xPoint, yPoint)
  }
  
  func CGFloatFromString(string: String) -> CGFloat? {
    if let n = NSNumberFormatter().numberFromString(string) {
      let f = CGFloat(n)
      return f
    }
    return nil
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
