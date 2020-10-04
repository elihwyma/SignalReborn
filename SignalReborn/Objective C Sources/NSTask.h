//
//  NSTask.h
//  SignalReborn
//
//  Created by Charlie While on 04/07/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask : NSObject

@property (copy) NSURL * executableURL;
@property (copy) NSArray * arguments;
@property (copy) NSDictionary * environment;
@property (copy) NSURL * currentDirectoryURL;
@property (retain) id standardInput;
@property (retain) id standardOutput;
@property (retain) id standardError;
@property (readonly) int processIdentifier;
@property (getter=isRunning, readonly) BOOL running;
@property (readonly) int terminationStatus;
@property (readonly) long long terminationReason;
@property (copy) id terminationHandler;
@property (assign) long long qualityOfService;
+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;
+ (id)launchedTaskWithExecutableURL:(id)arg1 arguments:(id)arg2 error:(out id*)arg3 terminationHandler:(/*^block*/id)arg4;
- (void)waitUntilExit;
- (id)currentDirectoryPath;
- (void)setCurrentDirectoryPath:(id)arg1;
- (id)launchPath;
- (void)setLaunchPath:(id)arg1;
- (void)launch;
- (BOOL)launchAndReturnError:(id*)arg1;
- (void)interrupt;
- (long long)suspendCount;
- (BOOL)suspend;
- (BOOL)resume;
- (void)terminate;
- (NSArray *)arguments;
@end
