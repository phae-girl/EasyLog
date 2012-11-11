//
//  AppDelegate.h
//  EasyLog
//
//  Created by Phaedra Deepsky on 2012-11-06.
//  Copyright (c) 2012 Phaedra Deepsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem *statusItem;
	IBOutlet NSMenu *menu;
	NSMenuItem *startMenuItem, *stopMenuItem;
	
}

#pragma mark -
#pragma mark Temporary Properties
@property NSString *currentProjectName;


#pragma mark -
#pragma mark Core Data Properties
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark -
#pragma mark Windows and Dialogs
@property (weak) IBOutlet NSWindow *projectListWindow;
@property (weak) IBOutlet NSWindow *addProjectDialog;
@property (weak) IBOutlet NSWindow *selectProjectWindow;

#pragma mark -
#pragma mark Internal
@property (weak) NSString *nameForNewProject, *fileNameForNewProject, *pathForNewProject, *filePathForNewProject;
@property BOOL enableLogging;

#pragma mark -
#pragma mark Temporary Methods
- (IBAction)userDidSelectProject:(id)sender;
- (IBAction)userSelectedStartFromSelectProjectDialog:(id)sender;
- (IBAction)userSelectedCancelFromSelectProjectDialog:(id)sender;
- (IBAction)userSelectedAddProjectFromProjectDialog:(id)sender;

#pragma mark -
#pragma mark Menu Bar Methods
- (IBAction)userSelectedStartLoggingFromMenuBar:(id)sender;
- (IBAction)userSelectedStopLoggingFromMenuBar:(id)sender;
- (IBAction)userSelectedAddProjectFromMenuBar:(id)sender;
- (IBAction)userSelectedSelectProjectFromMenuBar:(id)sender;
- (IBAction)userSelectedQuitAppFromMenuBar:(id)sender;

#pragma mark -
#pragma mark Preferences Dialog Methods
- (IBAction)openProjectsList:(id)sender;

#pragma mark -
#pragma mark Add Project Dialog Methods
- (IBAction)saveAndCloseAddProjectDialog:(id)sender;
- (IBAction)cancelAddProjectDialog:(id)sender;
- (IBAction)pickLogFileDirectory:(id)sender;

#pragma mark -
#pragma mark Built in Core Data Methods
- (IBAction)saveAction:(id)sender;


@end
