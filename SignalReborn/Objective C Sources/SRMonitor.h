//
//
//  SignalReborn
//
//  Created by Charlie While on 19/06/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

struct CTResult
{
    int flag;
    int a;
};

struct CellInfo
{
    int servingmnc;
    int network;
    int location;
    int cellid;
    int station;
    int freq;
    int rxlevel;
    int c1;
    int c2;
};

extern CFStringRef const kCTCellMonitorCellType;
extern CFStringRef const kCTCellMonitorCellTypeServing;
extern CFStringRef const kCTCellMonitorCellTypeNeighbor;
extern CFStringRef const kCTCellMonitorCellId;
extern CFStringRef const kCTCellMonitorLAC;
extern CFStringRef const kCTCellMonitorMCC;
extern CFStringRef const kCTCellMonitorMNC;

//Notifications to register for
extern CFStringRef const kCTCellMonitorUpdateNotification;

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);
void _CTServerConnectionAddToRunLoop(id, CFRunLoopRef, CFStringRef);

void _CTServerConnectionRegisterForNotification(id, CFStringRef);
void _CTServerConnectionCellMonitorStart(id);
void _CTServerConnectionCellMonitorStop(id);
void _CTServerConnectionCellMonitorCopyCellInfo(id, void*, CFArrayRef*);

int _CTServerConnectionCellMonitorGetCellCount(id, int *);
int _CTServerConnectionCellMonitorGetUmtsCellCount(id, int *);
void _CTServerConnectionGetSignalStrength(id, int *);

@interface SRMonitor : NSObject
-(id)setupServerAndNotifications;
-(NSArray *)getTheCellInfo:(id)CTConnection;
@end



