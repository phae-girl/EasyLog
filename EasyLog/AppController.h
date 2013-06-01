//
//  AppController.h
//  EasyLog
//
//  Created by Phaedra Deepsky on 2013-06-01.
//  Copyright (c) 2013 Phaedra Deepsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppControllerDelegateProtocol <NSObject>
@required
- (void)quitApp;

@end

@interface AppController : NSObject

@property (nonatomic, weak) NSObject <AppControllerDelegateProtocol> *delegate;

- (id)init;
@end
