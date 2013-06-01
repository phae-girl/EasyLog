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
#import "AppController.h"

@interface AppDelegate () <AppControllerDelegateProtocol>
@property (copy) NSString *nameForNewProject, *fileNameForNewProject, *pathForNewProject, *filePathForNewProject, *currentProjectName;
@property BOOL enableLogging;
@property Project* project;
@property Session* session;

//June 1, 2013 refactoring additions
@property (nonatomic, strong)AppController *appController;

@end

#pragma mark -
#pragma mark NSDate Convenience Category

@implementation NSDate (FormattedStrings)
- (NSString *)timeString
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    return [timeFormatter stringFromDate:self];
}

- (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMM-dd"];
    return [dateFormatter stringFromDate:self];
}

@end

@implementation AppDelegate

#pragma mark -
#pragma mark Core Data Properties
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark -
#pragma mark Project Dialog Methods
- (IBAction)userDidSelectProject:(id)sender
{
	if (self.project.projectName != NULL) {
		[self saveAction:nil];
		self.project = nil;
	}
	if (self.project.projectName == NULL) {
		self.project = [self fetchProject:self.currentProjectName];
	}
}

//- (IBAction)userSelectedStartFromSelectProjectDialog:(id)sender {
//	[self userSelectedStartLoggingFromMenuBar:nil];
//	[self.selectProjectWindow orderOut:nil];
//}
//
//- (IBAction)userSelectedCancelFromSelectProjectDialog:(id)sender {
//	[self.selectProjectWindow orderOut:nil];
//}
//- (IBAction)userSelectedAddProjectFromProjectDialog:(id)sender {
//	[self userSelectedAddProjectFromMenuBar:nil];
//	[self.selectProjectWindow orderOut:nil];
//}

#pragma mark -
#pragma mark Awake and Init

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
	if (!_appController) {
		_appController = [[AppController alloc]init];
		[self.appController setDelegate:self];
	}
}
//#pragma mark -
//#pragma mark Menu Bar Methods
//- (IBAction)userSelectedStartLoggingFromMenuBar:(id)sender
//{
//
//	if (self.project == NULL) {
//		[self userSelectedSelectProjectFromMenuBar:nil];
//	}
//	else {
//		[self.startMenuItem setTitle:[NSString stringWithFormat: @"Tracking: %@", self.project.projectName]];
//		[self.startMenuItem setEnabled:NO];
//		[self.stopMenuItem setEnabled:YES];
//		
//		self.session = (Session*)[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:[self managedObjectContext]];
//		self.session.startTime = [NSDate date];
//		}
//	[self saveAction:nil];
//}
//- (IBAction)userSelectedStopLoggingFromMenuBar:(id)sender
//{
//		
//	if (self.session) {
//		self.session.endTime = [NSDate date];
//		self.session.sessionTotalTime = [NSNumber numberWithInt:[self.session.endTime timeIntervalSinceDate:self.session.startTime]];
//		self.project.projectTotalTimeCounter = @([self.project.projectTotalTimeCounter intValue] + [self.session.sessionTotalTime intValue]);
//		self.project.projectTotalTime = [self nicelyFormattedTimeStringFrom:[self.project.projectTotalTimeCounter intValue]];
//		[self saveAction:nil];
//		
//		if ([self.project.enableLoging boolValue]) {
//			[self logSession];
//		}
//	}
//	[self.startMenuItem setEnabled:YES];
//	[self.stopMenuItem setEnabled:NO];
//	[self.startMenuItem setTitle:[NSString stringWithFormat: @"Resume %@", self.project.projectName]];
//	
//	_session = nil;
//}
//- (IBAction)userSelectedAddProjectFromMenuBar:(id)sender
//{
//	
//	self.nameForNewProject = @"New Project";
//	self.enableLogging = YES;
//	self.fileNameForNewProject = [self.nameForNewProject stringByAppendingString:@".txt"];
//	self.pathForNewProject = @"~/Documents/";
//	self.filePathForNewProject = [self.pathForNewProject stringByAppendingString:_fileNameForNewProject];
//	
//	[self addObserver:self forKeyPath:@"nameForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
//	[self addObserver:self forKeyPath:@"fileNameForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
//	[self addObserver:self forKeyPath:@"pathForNewProject" options:NSKeyValueObservingOptionNew context:NULL];
//	
//	[NSApp activateIgnoringOtherApps:YES];
//	[self.addProjectDialog makeKeyAndOrderFront:nil];
//}
//- (IBAction)userSelectedSelectProjectFromMenuBar:(id)sender {
//
//	[NSApp activateIgnoringOtherApps:YES];
//	[self.selectProjectWindow makeKeyAndOrderFront:nil];
//}
//
- (IBAction)userSelectedQuitAppFromMenuBar:(id)sender {
	[self quitApp];
}

-(void)quitApp
{
	NSError *error = nil;
	
	if (![[self managedObjectContext]save:&error]) {
		NSLog(@"Save Error: %@",error);
	}
	
	[NSApp terminate:nil];

}

#pragma mark -
#pragma mark Preferences Dialog Methods
- (IBAction)openProjectsList:(id)sender
{

	[NSApp activateIgnoringOtherApps:YES];
	[self.projectListWindow makeKeyAndOrderFront:nil];
}

- (IBAction)addProject:(id)sender {
    [self.managedObjectContext insertObject:[[Project alloc]init]];
}

- (IBAction)removeProject:(id)sender {
    NSInteger row = self.projectListTableView.selectedRow;
    if (row != -1) {
        [[self managedObjectContext]removeValueAtIndex:row fromPropertyWithKey:@"Projects"];
    }
}

#pragma mark -
#pragma mark Add Project Dialog Methods
- (IBAction)saveAndCloseAddProjectDialog:(id)sender
{
	self.project = (Project*)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	self.project.projectName = self.nameForNewProject;
	self.project.enableLoging = @(self.enableLogging);
	self.project.projectTotalTimeCounter = 0;
	self.project.logFilePath = [self.filePathForNewProject stringByExpandingTildeInPath];
	
	[self writeDefaults:self.project.projectName toKey:@"lastAddedProject"];
	
	[self.managedObjectContext insertObject:self.project];
	
	NSError *error = nil;
	
	if (![[self managedObjectContext]save:&error]) {
		NSLog(@"Save Error: %@",error);
	}
	[self.addProjectDialog orderOut:nil];
	self.project = nil;
}
- (IBAction)cancelAddProjectDialog:(id)sender
{
	[self.addProjectDialog orderOut:nil]; 
}

//TODO: Clean up code for file picker
- (IBAction)pickLogFileDirectory:(id)sender
{
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
			self.pathForNewProject = [[[files[i] path] stringByAbbreviatingWithTildeInPath]stringByAppendingString:@"/"];
			
		}
	}
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
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

#pragma mark -
#pragma mark Fetch Methods
- (NSArray*) fetchProjectList
{
	
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
- (id) fetchProject:(NSString*)aProject
{
	
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
	return fetchedObjects[0];
}

#pragma mark -
#pragma mark User Default Convenience Methods
- (void)writeDefaults:(id)value toKey:(NSString*)key
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:value forKey:key];
	[defaults synchronize];
}
- (NSString*)readDefaultsForKey:(NSString*)key
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* value = [[NSString alloc] initWithString:[defaults stringForKey:key]];
	return value;
}

#pragma mark -
#pragma mark Format Time String Method

- (NSString*)nicelyFormattedTimeStringFrom:(int)aNumberOfSeconds
{
	int hours = aNumberOfSeconds / 3600,remainder = aNumberOfSeconds % 3600,minutes = remainder / 60,seconds = remainder % 60;
	
	NSMutableArray* sessionLength = [NSMutableArray array];
	
	if (hours > 0) {
		[sessionLength addObject:[NSString stringWithFormat:@"%u", hours]], [sessionLength addObject:@" hours, "];
		[sessionLength addObject:[NSString stringWithFormat:@"%u", minutes]], [sessionLength addObject:@" minutes, and "];
		[sessionLength addObject:[NSString stringWithFormat:@"%u", seconds]], [sessionLength addObject:@" seconds"];
	}
	else if (minutes >0) {
		[sessionLength addObject:[NSString stringWithFormat:@"%u", minutes]], [sessionLength addObject:@" minutes, and "];
		[sessionLength addObject:[NSString stringWithFormat:@"%u", seconds]], [sessionLength addObject:@" seconds"];
	}
	else {
		[sessionLength addObject:[NSString stringWithFormat:@"%u", seconds]], [sessionLength addObject:@" seconds"];
	}
	return [sessionLength componentsJoinedByString:@""];
}

#pragma mark -
#pragma mark Log Session Method

- (void)logSession
{
	NSString* logString = [@[[[NSDate date] dateString],@"Session Start:",[self.session.startTime timeString],
							@"Session End:",[self.session.endTime timeString],@"Session Total:",[self nicelyFormattedTimeStringFrom:[self.session.sessionTotalTime intValue]],@"Project Total:",[self nicelyFormattedTimeStringFrom:[self.project.projectTotalTimeCounter intValue]],@"\n"] componentsJoinedByString:@" "];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:	self.project.logFilePath]) {
		[fileManager createFileAtPath: self.project.logFilePath contents:[logString dataUsingEncoding:NSUTF8StringEncoding]attributes:nil];
	}
	
	else {
		NSFileHandle *fout = [NSFileHandle fileHandleForUpdatingAtPath:self.project.logFilePath];
		[fout seekToEndOfFile];
		[fout writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
		[fout closeFile];
	}
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
