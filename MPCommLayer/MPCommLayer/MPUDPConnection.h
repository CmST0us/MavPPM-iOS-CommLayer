//
//  MPUDPConnection.h
//  MPCommLayer
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPUDPConnection : NSObject

- (instancetype)initWithRemoteHostName:(NSString *)hostname
                                  port:(uint16_t)port;
- (BOOL)start;

- (BOOL)pause;

- (BOOL)resume;

- (BOOL)close;

- (BOOL)writeData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
