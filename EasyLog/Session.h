//
//  Session.h
//  EasyLog
//
//  Created by Phaedra Deepsky on 2012-11-06.
//  Copyright (c) 2012 Phaedra Deepsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * sessionTotalTime;
@property (nonatomic, retain) Project *project;

@end
