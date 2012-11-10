//
//  AppDelegate.m
//  EasyLog
//
//  Created by Phaedra Deepsky on 2012-11-06.
//  Copyright (c) 2012 Phaedra Deepsky. All rights reserved.
//

#import "AppDelegate.h"
#import "Project.h"
#import "Session.h"

@implementation AppDelegate
{
	Session* session;
	Project* project;
}

#pragma mark -
#pragma mark Core Data Properties
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
#pragma mark -
#pragma mark Windows and Dialogs
@synthesize projectListWindow = _projectListWindow;
@synthesize addProjectDialog = _addProjectDialog;
@synthesize selectProjectWindow = _selectProjectWindow;
#pragma mark -
#pragma mark Internal
@synthesize nameForNewProject, fileNameForNewProject, pathForNewProject, filePathForNewProject;
@synthesize enableLogging;

#pragma mark -
#pragma mark Awake and Init
- (void)awakeFromNib {
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[statusItem setMenu:menu];
	[statusItem setHighlightMode:YES];
	[statusItem setImage:[NSImage imageNamed:@"Icon"]];
	//[statusItem setTarget:self];
	//[statusItem setAction:@selector(openWindow:)];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	project = (Project*)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
//	
//
	projectList = [NSMutableArray arrayWithArray:[self fetchProjectList]];
	[projectList insertObject:@"New Project" atIndex:0];
	[projectList insertObject:[NSMenuItem separatorItem] atIndex:1];
	
//	for (NSString *projectName in projectList) {
//		[menu addItemWithTitle:projectName action:@selector(selectProject:) keyEquivalent:@""];
//		NSLog(@"%@", projectName);
//	}
	
	if (project.projectName == NULL) {
		project = [self fetchProject:@"Holy Fuck!"];
	}
}


#pragma mark -
#pragma mark Menu Bar Methods
- (IBAction)startLogging:(id)sender {
	NSLog(@"Start Logging");
	session = (Session*)[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:[self managedObjectContext]];
	session.startTime = [NSDate date];
	NSLog(@"Logging Project: %@, Start Time: %@",project.projectName, session.startTime);
}

- (IBAction)openAddProjectDialog:(id)sender {
	
	self.nameForNewProject = @"New Project";
	self.enableLogging = YES;
	self.fileNameForNewProject = [self.nameForNewProject stringByAppendingString:@".txt"];
	self.pathForNewProject = @"~/Documents/";
	self.filePathForNewProject = [self.pathForNewProject stringByAppendingString:fileNameForNewProject];
	
	[self addObserver:self forKeyPath:@"nameForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
	[self addObserver:self forKeyPath:@"fileNameForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
	[self addObserver:self forKeyPath:@"pathForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
	
	
	[NSApp activateIgnoringOtherApps:YES];
	[_addProjectDialog makeKeyAndOrderFront:nil];
}

- (IBAction)openSelectProjectDialog:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[_selectProjectWindow makeKeyAndOrderFront:nil];
}

- (IBAction)stopLogging:(id)sender {
	NSLog(@"Stop Logging");
	
	if (session) {
		session.endTime = [NSDate date];
		session.sessionTotalTime = [NSNumber numberWithInt:[session.endTime timeIntervalSinceDate:session.startTime]];
		NSLog(@"Total Session Time %@",session.sessionTotalTime);
		
	}
}

- (IBAction)quitApp:(id)sender {
	NSError *error = nil;
	
	if (![[self managedObjectContext]save:&error]) {
		NSLog(@"Save Error: %@",error);
	}
	
	[NSApp terminate:nil];
}

#pragma mark -
#pragma mark Preferences Dialog Methods
- (IBAction)openProjectsList:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[_projectListWindow makeKeyAndOrderFront:nil];
}

#pragma mark -
#pragma mark Add Project Dialog Methods
- (IBAction)saveAndCloseAddProjectDialog:(id)sender {
	project = (Project*)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	project.projectName = self.nameForNewProject;
	project.enableLoging = [NSNumber numberWithBool:self.enableLogging];
	project.projectTotalTimeCounter = 0;
	project.logFilePath = [self.filePathForNewProject stringByExpandingTildeInPath];
	NSLog(@"Project pre-save name: %@", project.projectName);
	[self writeDefaults:project.projectName toKey:@"lastAddedProject"];
	
	[self.managedObjectContext insertObject:project];
	
	NSError *error = nil;
	
	if (![[self managedObjectContext]save:&error]) {
		NSLog(@"Save Error: %@",error);
	}
	[_addProjectDialog orderOut:nil];
	project = nil;
	
	
}

- (IBAction)cancelAddProjectDialog:(id)sender {
	[_addProjectDialog orderOut:nil]; 
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"nameForNewProject"]) {
		[self setValue:[self.nameForNewProject stringByAppendingString:@".txt"] forKey:@"fileNameForNewProject"];
	}
	if ([keyPath isEqualToString:@"fileNameForNewProject"]) {
		[self setValue:[self.pathForNewProject stringByAppendingString:self.fileNameForNewProject] forKey:@"filePathForNewProject"];
	}
	if ([keyPath isEqualToString:@"pathForNewProject"]) {
		[self setValue:[self.pathForNewProject stringByAppendingString:self.fileNameForNewProject] forKey:@"filePathForNewProject"];
	}
	
}

- (IBAction)pickLogFileDirectory:(id)sender {
	//-----------------
	//NSOpenPanel: Displaying a File Open Dialog in OS X 10.7
	//From: http://cyborgdino.com/2012/02/nsopenpanel-displaying-a-file-open-dialog-in-os-x-10-7/
	//-----------------

	
	// Loop counter.
	
	int i;
	// Create a File Open Dialog class.
	
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	// Set array of file types
	
//	NSArray *fileTypesArray;
//	
//	fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];
	// Enable options in the dialog.
	
	[openDlg setCanChooseFiles:NO];
	[openDlg setCanChooseDirectories:YES];
	
//	[openDlg setAllowedFileTypes:fileTypesArray];
	[openDlg setAllowsMultipleSelection:NO];
	// Display the dialog box.  If the OK pressed,
	
	// process the files.
	
	if ( [openDlg runModal] == NSOKButton ) {
		// Gets list of all files selected
		
		NSArray *files = [openDlg URLs];
		// Loop through the files and process them.
		
		for( i = 0; i < [files count]; i++ ) {
			// Do something with the filename.
			self.pathForNewProject = [[[[files objectAtIndex:i] path] stringByAbbreviatingWithTildeInPath]stringByAppendingString:@"/"];
			NSLog(@"File path: %@", self.pathForNewProject);
		}
	}
}

#pragma mark -
#pragma mark Fetch Methods
- (NSArray*) fetchProjectList {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		NSLog(@"Error: %@",error);
	}
	
	NSMutableArray* projList = [NSMutableArray array];
	
	for (Project *p in fetchedObjects) {
		[projList addObject:p.projectName];
	}
	
	return projList;
}

- (id) fetchProject:(NSString*)aProject {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectName == %@",aProject];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		NSLog(@"Fetch Error: %@", error);
	}
	return [fetchedObjects objectAtIndex:0];
	
	
}

#pragma mark -
#pragma mark User Default Convenience Methods
- (void)writeDefaults:(id)value toKey:(NSString*)key  {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:value forKey:key];
	[defaults synchronize];
}

- (NSString*)readDefaultsForKey:(NSString*)key {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* value = [[NSString alloc] initWithString:[defaults stringForKey:key]];
	return value;
}

#pragma mark -
#pragma mark Built in Core Data Methods
// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.Deepsky.EasyLog" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.Deepsky.EasyLog"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EasyLog" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"EasyLog.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
	
    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark -
#pragma mark Built in Terminate Method
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
