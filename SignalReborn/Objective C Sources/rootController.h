//
//  rootController.h
//  SignalReborn
//
//  Created by Charlie While on 04/07/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//
#import "NSTask.h"

@interface rootController : NSObject
- (NSString *_Nullable)copyFiles;
- (NSString *_Nullable)runCommandInPath:(NSString *_Nonnull)command asRoot:(BOOL)sling;
- (NSString *_Nullable)locateCommandInPath:(NSString *_Nullable)command shell:(NSString *_Nullable)shellPath;
- (void)purge;
@end
