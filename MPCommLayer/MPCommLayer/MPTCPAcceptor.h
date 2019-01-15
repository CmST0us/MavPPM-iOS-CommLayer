//
//  MPTCPAcceptor.h
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/15.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MPCommTCPAcceptorEvent) {
    MPCommTCPAcceptorEventCanAccept,
    MPCommTCPAcceptorEventError,
};

@class MPTCPAcceptor;
@class MPTCPSocket;
@protocol MPCommTCPAcceptorDelegate <NSObject>
- (void)acceptor:(MPTCPAcceptor *)aAcceptor handleEvent:(MPCommTCPAcceptorEvent)aEvent;
- (void)acceptor:(MPTCPAcceptor *)aAcceptor didAcceptSocket:(MPTCPSocket *)aSocket;
@end

@interface MPTCPAcceptor : NSObject
@property (nonatomic, weak) id<MPCommTCPAcceptorDelegate> delegate;

- (instancetype)initWithDelegate:(nullable id<MPCommTCPAcceptorDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)bindToPort:(short)aPort;
- (void)listen:(int)backlog;
- (void)accept;

@end

NS_ASSUME_NONNULL_END
