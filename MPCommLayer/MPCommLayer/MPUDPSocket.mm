//
//  MPUDPSocket.m
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/14.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <libSocketKit/UDPSocket.hpp>

#import "MPUDPSocket.h"

using namespace socketkit;

@interface MPUDPSocket () {
    std::unique_ptr<UDPSocket> _socket;
}

@end

@implementation MPUDPSocket

- (instancetype)init {
    return [self initWithDelegate:NULL];
}

- (instancetype)initWithDelegate:(id<MPCommDelegate>)delegate {
    return [self initWithLocalPort:0 delegate:delegate];
}

- (instancetype)initWithLocalPort:(short)localPort
                         delegate:(id<MPCommDelegate>)delegate{
    self = [super init];
    if (self) {
        _socket = std::unique_ptr<UDPSocket>(new UDPSocket(localPort));
        self.delegate = delegate;
        _socket->getRunloop()->run();
    }
    return self;
}

- (void)setDelegate:(id<MPCommDelegate>)delegate {
    _delegate = delegate;
    __weak typeof(self) weakSelf = self;
    auto eh = [weakSelf](ICommunicator *communicator, CommunicatorEvent event) {
        switch (event) {
            case socketkit::CommunicatorEvent::HasBytesAvailable: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(communicator:handleEvent:)]) {
                    [weakSelf.delegate communicator:weakSelf handleEvent:MPCommEventHasBytesAvailable];
                }
            }
                break;
            case socketkit::CommunicatorEvent::ErrorOccurred: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(communicator:handleEvent:)]) {
                    [weakSelf.delegate communicator:weakSelf handleEvent:MPCommEventErrorOccurred];
                }
            }
                break;
            default:
                break;
        }
    };
    _socket->mEventHandler = eh;
}

- (void)connect:(NSString *)aDomain
           port:(short)aPort {
    std::string domainStr = [aDomain cStringUsingEncoding:NSUTF8StringEncoding];
    auto ep = std::make_shared<Endpoint>(domainStr, aPort);
    _socket->connect(ep);
}

- (void)write:(NSData *)data {
    int size = (int)data.length;
    _socket->write((uchar *)data.bytes, size);
}

- (void)read {
    __weak typeof(self) weakSelf = self;
    _socket->read([weakSelf](uchar *buffer, int size) {
        if (weakSelf.delegate &&
            [weakSelf.delegate respondsToSelector:@selector(communicator:didReadData:)]) {
            if (size > 0) {
                NSData *data = [[NSData alloc] initWithBytes:(const void *)buffer length:size];
                [weakSelf.delegate communicator:weakSelf didReadData:data];
            }
        }
    });
}

- (void)close {
    _socket->getRunloop()->stop();
}

- (void)dealloc {
    _socket.reset();
}

@end
