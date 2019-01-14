//
//  MPCommDelegate.h
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/14.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MPCommEvent) {
    MPCommEventNone,
    MPCommEventOpenCompleted,
    MPCommEventErrorOccurred,
    MPCommEventEndEncountered,
    MPCommEventHasBytesAvailable,
    MPCommEventHasSpaceAvailable,
};

@protocol MPCommDelegate <NSObject>
- (void)communicator:(id)aCommunicator handleEvent:(MPCommEvent)event;
- (void)communicator:(id)aCommunicator didReadData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
