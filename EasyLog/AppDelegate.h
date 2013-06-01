//
//  AppDelegate.h
//  EasyLog
//
//  Created by Phaedra Deepsky on 2012-11-06.
//  Copyright (c) 2012 Phaedra Deepsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>

#pragma mark -
#pragma mark Core Data Properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark -
#pragma mark Windows and Dialogs
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSWindow *addProjectDialog;
@property (weak) IBOutlet NSWindow *projectListWindow;
@property (weak) IBOutlet NSWindow *selectProjectWindow;
@property (weak) IBOutlet NSTableView *projectListTableView;


//#pragma mark -
//#pragma mark Project Dialog Methods
//- (IBAction)userDidSelectProject:(id)sender;
//- (IBAction)userSelectedAddProjectFromProjectDialog:(id)sender;
//- (IBAction)userSelectedCancelFromSelectProjectDialog:(id)sender;
//- (IBAction)userSelectedStartFromSelectProjectDialog:(id)sender;
//
//#pragma mark -
//#pragma mark Menu Bar Methods
//- (IBAction)userSelectedAddProjectFromMenuBar:(id)sender;
//- (IBAction)userSelectedQuitAppFromMenuBar:(id)sender;
//- (IBAction)userSelectedSelectProjectFromMenuBar:(id)sender;
//- (IBAction)userSelectedStartLoggingFromMenuBar:(id)sender;
//- (IBAction)userSelectedStopLoggingFromMenuBar:(id)sender;

#pragma mark -
#pragma mark Preferences Dialog Methods
- (IBAction)openProjectsList:(id)sender;
- (IBAction)addProject:(id)sender;
- (IBAction)removeProject:(id)sender;


#pragma mark -
#pragma mark Add Project Dialog Methods
- (IBAction)cancelAddProjectDialog:(id)sender;
- (IBAction)pickLogFileDirectory:(id)sender;
- (IBAction)saveAndCloseAddProjectDialog:(id)sender;

#pragma mark -
#pragma mark Built in Core Data Methods
- (IBAction)saveAction:(id)sender;

@end
