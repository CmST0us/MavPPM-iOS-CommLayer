//
//  MPUDPServer.h
//  MPCommLayer
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCommunicatorServiceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPUDPServer : NSObject<MPCommunicatorServiceDelegate>

@property (nonatomic, weak) id<MPCommunicatorServiceDelegate> delegate;

- (instancetype)initWithListenPort:(uint16_t)port;

- (void)setRemoteClientAddress:(NSString *)address
                          port:(uint16_t)port;

- (BOOL)start;

- (BOOL)pause;

- (BOOL)resume;

- (BOOL)close;

- (BOOL)writeData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
