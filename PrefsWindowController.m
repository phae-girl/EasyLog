//
//  PrefsWindowController.m
//  EasyLog
//
//  Created by Phaedra Deepsky on 2013-06-01.
//  Copyright (c) 2013 Phaedra Deepsky. All rights reserved.
//

#import "PrefsWindowController.h"

@interface PrefsWindowController () 

@end

@implementation PrefsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)dealloc
{
	NSLog(@"%s",__PRETTY_FUNCTION__);
}


@end
