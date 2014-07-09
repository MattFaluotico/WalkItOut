//
//  MasterViewController.swift
//  MySteps
//
//  Created by Matthew Faluotico on 6/12/14.
//  Copyright (c) 2014 Matthew Faluotico. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext? = nil
    
    var stepHandler = StepDataHandler(false)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register NIBS
        var nib = UINib(nibName: "CellToday", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellToday")
        
        nib = UINib(nibName: "CellWeek", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellWeek")
        
        nib = UINib(nibName: "CellStatsAverage", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellStatsAverage")
        
        nib = UINib(nibName: "CellStatsBest", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellStatsBest")
        
        nib = UINib(nibName: "CellStatsTotal", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellStatsTotal")
        
        nib = UINib(nibName: "CellHistory", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CellHistory")
        
        
        
        // Set Nav Label
        var l = UILabel()
        var titleLabelText = NSMutableAttributedString(string: "CountMySteps")
        var boldAttDic = NSDictionary(object: UIFont.boldSystemFontOfSize(24.0), forKey: NSFontAttributeName)
        var thinAttDic = NSDictionary(object: UIFont(name: "HelveticaNeue-Thin", size: 24.0), forKey: NSFontAttributeName);
        titleLabelText.setAttributes(boldAttDic, range: NSMakeRange(5, 2))
        titleLabelText.setAttributes(thinAttDic, range: NSMakeRange(0, 5))
        titleLabelText.setAttributes(thinAttDic, range: NSMakeRange(7, 5))
        
        l.attributedText = titleLabelText
        l.textColor = UIColor.whiteColor()
        l.textAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = l;
        l.sizeToFit()
        
        // set the settings button
        
//        let editButton = UIBarButtonItem(title: "set", style: .Bordered, target: self, action: "none")
//        self.navigationItem.leftBarButtonItem = editButton
        // set the share button

        let addButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "l")
        addButton.style = .Bordered
        addButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = self.fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
//        return sectionInfo.numberOfObjects
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if (indexPath.row >= INDEX_HISTORY_CELL) {
            cell = tableView.dequeueReusableCellWithIdentifier("CellHistory") as CellHistory
            return cell;
        }
        
        switch(indexPath.row) {
        
        case INDEX_TODAY_CELL:
            cell  = tableView.dequeueReusableCellWithIdentifier("CellToday") as CellToday
        case INDEX_WEEK_CELL:
            cell = tableView.dequeueReusableCellWithIdentifier("CellWeek") as CellWeek
        case INDEX_STATS_AVERAGE_CELL:
            cell = tableView.dequeueReusableCellWithIdentifier("CellStatsAverage") as CellStatsAverage
        case INDEX_STATS_BEST_CELL:
            cell = tableView.dequeueReusableCellWithIdentifier("CellStatsBest") as CellStatsBest
        case INDEX_STATS_TOTAL_CELL:
            cell = tableView.dequeueReusableCellWithIdentifier("CellStatsTotal") as CellStatsTotal
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("CellHistory") as CellHistory
        }
        
        return cell;
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
                
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var height = CGFloat()
        
        if (indexPath.row >= INDEX_HISTORY_CELL) {
            height = HEIGHT_HISTORY_CELL;
            return height;
        }
        
        switch (indexPath.row) {
            case INDEX_TODAY_CELL:
            height = HEIGHT_TODAY_CELL
            case INDEX_WEEK_CELL:
            height = HEIGHT_WEEK_CELL
            case INDEX_STATS_AVERAGE_CELL:
            height = HEIGHT_STATS_AVERAGE_CELL
            case INDEX_STATS_BEST_CELL:
            height = HEIGHT_STATS_BEST_CELL
            case INDEX_STATS_TOTAL_CELL:
            height = HEIGHT_STATS_TOTAL_CELL
            default:
            height = HEIGHT_HISTORY_CELL
        }
            
        return height
            
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        cell.textLabel.text = object.valueForKey("day").description
    }

    // #pragma mark - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("StepDay", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	var error: NSError? = nil
    	if !_fetchedResultsController!.performFetch(&error) {
    	     // Replace this implementation with code to handle the error appropriately.
    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //println("Unresolved error \(error), \(error.userInfo)")
    	     abort()
    	}
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case NSFetchedResultsChangeInsert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case NSFetchedResultsChangeDelete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
            case NSFetchedResultsChangeInsert:
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case NSFetchedResultsChangeDelete:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case NSFetchedResultsChangeUpdate:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath), atIndexPath: indexPath)
            case NSFetchedResultsChangeMove:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */


}
