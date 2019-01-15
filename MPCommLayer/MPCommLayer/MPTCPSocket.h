//
//  MPTCPSocket.h
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/14.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCommDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPTCPSocket : NSObject
@property (nonatomic, weak) id<MPCommDelegate> delegate;

#pragma mark - Local Method
/**
 Use By MPTCPAcceptor

 @param socketFd client socket fd
 @param aDomain client domain(ip)
 @param port client port
 @return MPTCPSocket
 */
- (instancetype)initWithSocketFd:(int)socketFd
                  endpointDomain:(NSString *)aDomain
                    endpointPort:(short)port;
/**
 Start TCP Listen
 */
- (void)open;
- (void)continueFinished;

#pragma mark - Remote Method
- (instancetype)initWithDelegate:(nullable id<MPCommDelegate>)delegate;

- (void)connect:(NSString *)aDomain port:(short)aPort;

#pragma mark - IO Method
- (void)read;
- (void)write:(NSData *)data;
- (void)closeWrite;
- (void)close;

@end

NS_ASSUME_NONNULL_END
