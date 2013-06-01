//
//  AppController.m
//  EasyLog
//
//  Created by Phaedra Deepsky on 2013-06-01.
//  Copyright (c) 2013 Phaedra Deepsky. All rights reserved.
//

#import "AppController.h"
#import "ProjectWindowController.h"

@interface AppController ()
@property (nonatomic, strong)NSStatusItem *statusItem;
@property (nonatomic, strong)NSMenu *menu;
@property (nonatomic)ProjectWindowController *projectWindow;

@end

@implementation AppController
- (id)init
{
    self = [super init];
    if (self) {
		[self setStatusMenu];
        [self setStatusIcon];
	}
    return self;
}

- (void)setStatusIcon
{
	if (!_statusItem) {
		_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	}
	
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setImage:[NSImage imageNamed:@"Icon"]];
	[self.statusItem setMenu:self.menu];
	[self.menu setAutoenablesItems:NO];
}

- (void)setStatusMenu
{
	if (!_menu) {
		_menu = [[NSMenu alloc]init];
	}
	[self.menu addItem:[[NSMenuItem alloc]initWithTitle:@"New Project" action:@selector(newProject) keyEquivalent:@"N"]];
	[self.menu addItem:[[NSMenuItem alloc]initWithTitle:@"Stop All" action:nil keyEquivalent:@""]];
	[self.menu addItem:[NSMenuItem separatorItem]];
	[self.menu addItem:[[NSMenuItem alloc]initWithTitle:@"Preferences" action:nil keyEquivalent:@","]];
	[self.menu addItem:[NSMenuItem separatorItem]];
	[self.menu addItem:[[NSMenuItem alloc]initWithTitle:@"Quit" action:@selector(quitApp) keyEquivalent:@"q"]];
	[[self.menu itemWithTitle:@"New Project"]setKeyEquivalentModifierMask:NSCommandKeyMask];
	[[self.menu itemWithTitle:@"New Project"]setTarget:self];
	[[self.menu itemWithTitle:@"Preferences"]setKeyEquivalentModifierMask:NSCommandKeyMask];
	[[self.menu itemWithTitle:@"Preferences"]setTarget:self];
	[[self.menu itemWithTitle:@"Quit"]setKeyEquivalentModifierMask:NSCommandKeyMask];
	
}

- (void)newProject
{
	_projectWindow = [[ProjectWindowController alloc]initWithWindowNibName:@"ProjectWindow"];
	[self.projectWindow showWindow:self];
}

- (void)quitApp
{
	[self.delegate quitApp];
}
@end
