//
//  MPUDPSocket.h
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/14.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MPCommDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPUDPSocket : NSObject
@property (nonatomic, weak) id<MPCommDelegate> delegate;

- (instancetype)initWithDelegate:(id<MPCommDelegate>)delegate;

- (instancetype)initWithLocalPort:(short)localPort
                         delegate:(id<MPCommDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)read;
- (void)write:(NSData *)data;
- (void)connect:(NSString *)aDomain port:(short)aPort;
- (void)close;
@end

NS_ASSUME_NONNULL_END
