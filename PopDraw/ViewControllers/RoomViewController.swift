//
//  RoomViewController.swift
//  PopDraw
//
//  Created by deast on 1/17/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
  
  @IBOutlet var drawView: DrawView!
  
  var room = Room(id: "1", name: "First!!1")
  
  var ref = Firebase(url: "https://popdraw.firebaseio.com/")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var roomRef = ref.childByAppendingPath(room.id)
    
    title = room.name
    
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    navigationItem.leftItemsSupplementBackButton = true
    
    drawView.moveHandler = { point in
      roomRef.childByAutoId().setValue([ "x": point.x, "y" : point.y])
    }
    
    roomRef.observeEventType(.ChildAdded, withBlock: { snapshot in
      
      if let xPoint = snapshot.value["x"] as? CGFloat {
        if let yPoint = snapshot.value["y"] as? CGFloat {
          self.drawView.addPoint(CGPointMake(xPoint, yPoint))
        }
      }
    
    })
    
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
