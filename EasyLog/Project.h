//
//  Project.h
//  EasyLog
//
//  Created by Phaedra Deepsky on 2012-11-06.
//  Copyright (c) 2012 Phaedra Deepsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * projectTotalTime;
@property (nonatomic, retain) NSNumber * projectTotalTimeCounter;
@property (nonatomic, retain) NSNumber * enableLoging;
@property (nonatomic, retain) NSString * logFilePath;
@property (nonatomic, retain) NSSet *sessions;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
