//
//  SignalReborn
//
//  Created by Amy While on 19/06/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

//Apple now considers this legacy, so I don't know how long it will last in future updates of iOS

#import <Foundation/Foundation.h>
#import "SRMonitor.h"

int CellMonitorCallback(id connection, CFStringRef string, CFDictionaryRef dictionary, void *data)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FuckyWucky" object:nil];
    return 0;
}

@implementation SRMonitor
-(id)setupServerAndNotifications {
    id CTConnection = _CTServerConnectionCreate(NULL, CellMonitorCallback, NULL);
    _CTServerConnectionAddToRunLoop(CTConnection, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    _CTServerConnectionRegisterForNotification(CTConnection, kCTCellMonitorUpdateNotification);
    _CTServerConnectionCellMonitorStart(CTConnection);
    return CTConnection;
}

- (NSArray *)getTheCellInfo: (id)CTConnection {
    int tmp = 0;
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(CTConnection, (void*)&tmp, &cells);
    NSArray *cellArray = (__bridge NSArray*)cells;
    return cellArray;
}
@end


