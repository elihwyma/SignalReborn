//
//  rootController.m
//  SignalReborn
//
//  Created by Charlie While on 04/07/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rootController.h"


@implementation rootController
-(NSString *)copyFiles {
    [self runCommandInPath:@"cp /var/root/Library/Caches/locationd/cache_encryptedB.db-wal /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db-wal" asRoot:YES];
    [self runCommandInPath:@"cp /var/root/Library/Caches/locationd/cache_encryptedB.db-shm /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db-shm" asRoot:YES];
    return([self runCommandInPath:@"cp /var/root/Library/Caches/locationd/cache_encryptedB.db /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db" asRoot:YES]);
}
-(void)purge {
    [self runCommandInPath:@"rm -rf /var/root/Library/Caches/locationd/cache_encryptedB.db" asRoot:YES];
    [self runCommandInPath:@"rm -rf /var/root/Library/Caches/locationd/cache_encryptedB.db-shm" asRoot:YES];
    [self runCommandInPath:@"rm -rf /var/root/Library/Caches/locationd/cache_encryptedB.db-wal" asRoot:YES];
    
    [self runCommandInPath:@"rm -rf /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db" asRoot:YES];
    [self runCommandInPath:@"rm -rf /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db-wal" asRoot:YES];
    [self runCommandInPath:@"rm -rf /var/mobile/Library/Application\\ Support/SignalReborn/SignalCache.db-shm" asRoot:YES];
    
    [self runCommandInPath:@"killall locationd" asRoot:YES];
}

- (NSString *)runCommandInPath:(NSString *_Nonnull)command asRoot:(BOOL)root {
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSString *shellPath = [environmentDict objectForKey:@"SHELL"];
    
    NSString *binary = [command componentsSeparatedByString:@" "][0];
    if (![self locateCommandInPath:binary shell:shellPath]) {
        NSException *exception = [NSException exceptionWithName:@"Binary not found" reason:[NSString stringWithFormat:@"%@ doesn't exist in $PATH", binary] userInfo:nil];
        NSLog(@"[SignalReborn] Exception %@", exception);
        return @"Not found";
    }
    
    NSTask *task = [[NSTask alloc] init];
    
    if (root) {
        [task setLaunchPath:@"/usr/libexec/signal/SignalHelper"];
        [task setArguments:@[shellPath, @"-c", command]];
    }
    else {
        [task setLaunchPath:shellPath];
        [task setArguments:@[@"-c", command]];
    }
    
    NSPipe * outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    
    @try {
        [task launch];
        [task waitUntilExit];
        NSFileHandle * read = [outputPipe fileHandleForReading];
        NSData * dataRead = [read readDataToEndOfFile];
        NSString * stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
        return stringRead;
    }
    @catch (NSException *e) {
        NSLog(@"[SignalReborn] %@ Could not spawn %@. Reason: %@", e.name, command, e.reason);
        return @"Error";
    }
}

- (NSString *)locateCommandInPath:(NSString *)command shell:(NSString *)shellPath {
    
    NSTask *which = [[NSTask alloc] init];
    [which setLaunchPath:shellPath];
    [which setArguments:@[@"-c", [NSString stringWithFormat:@"which %@", command]]];

    NSPipe *outPipe = [NSPipe pipe];
    [which setStandardOutput:outPipe];

    [which launch];
    [which waitUntilExit];

    NSFileHandle *read = [outPipe fileHandleForReading];
    NSData *dataRead = [read readDataToEndOfFile];
    NSString *stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
    if ([stringRead containsString:@"not found"] || [stringRead isEqualToString:@""]) {
        NSLog(@"[SignalReborn] Can't find %@", command);
        return NULL;
    }
    
    return stringRead;
}

@end
