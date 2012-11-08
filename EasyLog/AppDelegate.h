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
	NSMutableArray *projectList;
	
}

@property (weak) IBOutlet NSWindow *projectListWindow;
@property (weak) IBOutlet NSWindow *addProjectDialog;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) NSString *nameForNewProject, *fileNameForNewProject, *pathForNewProject, *filePathForNewProject;
@property BOOL enableLogging;



- (IBAction)saveAction:(id)sender;
- (IBAction)pickLogFileDirectory:(id)sender;
- (IBAction)startLogging:(id)sender;
- (IBAction)stopLogging:(id)sender;
- (IBAction)quitApp:(id)sender;
- (IBAction)openProjectsList:(id)sender;
- (IBAction)openAddProjectDialog:(id)sender;
- (IBAction)saveAndCloseAddProjectDialog:(id)sender;
- (IBAction)cancelAddProjectDialog:(id)sender;
- (IBAction)selectProject:(id)sender;


@end
