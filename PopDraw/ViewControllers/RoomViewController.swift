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
//  Possible Data Structures
//
//  When touches begin write to a drawing path
//  When touches end write to a drawingAdded path
//  When a child is added to drawingAdded it needs to read from it's associated drawing path
//
//  / room
//    / startingPoints
//      / <key>
//        / key - <key>
//
//    / drawings
//      / <key>
//          / <draw-key>
//            / x
//            / y
//

import UIKit

class RoomViewController: UIViewController {
  
  @IBOutlet var drawView: DrawView!
  
  var room = Room(id: "1", name: "First!!1")
  
  var ref = Firebase(url: "https://popdraw.firebaseio.com/")
  
  var handle : UInt = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var roomRef = ref.childByAppendingPath(room.id)
    var startPointsRef = roomRef.childByAppendingPath("startingPoints")
    var drawingsRef = roomRef.childByAppendingPath("drawings")
    var currentPointRef = startPointsRef.childByAutoId()
    var currentDrawRef = drawingsRef.childByAutoId()
    var count = 0
    
    title = room.name
    
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    navigationItem.leftItemsSupplementBackButton = true
    
    drawView.firstTouchHandler = { point in
      // Create a new currentPointRef
      currentPointRef = startPointsRef.childByAutoId()
      // Use the key from currentPointRef to create a new drawingRef
      currentDrawRef = drawingsRef.childByAppendingPath(currentPointRef.key)
      // Set the value of the currentPointRef to the key to trigger a child_added event
      currentPointRef.setValue([ "key": currentPointRef.key ])
      //self.drawView.moveToFirstPoint(point)
    }
    
    drawView.moveHandler = { point in
      // Write the the current drawing ref
      currentDrawRef.childByAutoId().setValue(self.dictionaryFromCGPoint(point))
    }
    
    startPointsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
      let enumerator = snapshot.children
      while let startingSnap = enumerator.nextObject() as? FDataSnapshot {
        self.listenToDrawPath(startingSnap.value as NSString)
      }
    })
    
  }
  
  func listenToDrawPath(key : NSString) {
    var count = 0
    // create a reference to the drawings/<key> draw path
    // when each point is drawn for the path, draw it on the page
    // the first point is always the first point to move to
    var drawingsRef = ref.childByAppendingPath(room.id).childByAppendingPath("drawings").childByAppendingPath(key)
    self.handle = drawingsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
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
