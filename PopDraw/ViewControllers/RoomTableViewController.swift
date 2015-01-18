//
//  RoomTableViewController.swift
//  PopDraw
//
//  Created by deast on 1/17/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

struct Room {
  let id: String
  let name: String
}

class RoomTableViewController: UITableViewController, UISplitViewControllerDelegate {
  
  private let roomCellIdentifier = "roomCell"
  
  private var collapseDetailViewController = true
  
  private let rooms = [
    Room(id: "1", name: "First!!1"),
    Room(id: "2", name: "Catz")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    splitViewController?.delegate = self;
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let roomNavController = segue.destinationViewController as? UINavigationController {
      if let roomViewController = roomNavController.topViewController as? RoomViewController {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
          let room = rooms[selectedIndexPath.row]
          roomViewController.room = room
        }
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rooms.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(roomCellIdentifier) as UITableViewCell;
    
    let room = rooms[indexPath.row];
    cell.textLabel?.text = room.name;
    
    return cell;
  }
  
  // MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    collapseDetailViewController = false
  }
  
}
