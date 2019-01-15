//
//  MPTCPSocket.m
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/14.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <libSocketKit/TCPSocket.hpp>

#import "MPTCPSocket.h"

using namespace socketkit;

@interface MPTCPSocket () {
    std::unique_ptr<TCPSocket> _socket;
}

@end

@implementation MPTCPSocket

- (instancetype)init {
    return [self initWithDelegate:NULL];
}

- (instancetype)initWithDelegate:(id<MPCommDelegate>)delegate {
    self = [super init];
    if (self) {
        _socket = std::unique_ptr<TCPSocket>(new TCPSocket());
        self.delegate = delegate;
        _socket->getRunloop()->run();
    }
    return self;
}

- (instancetype)initWithSocketFd:(int)socketFd
                  endpointDomain:(NSString *)aDomain
                    endpointPort:(short)port {
    self = [super init];
    if (self) {
        std::string domainStr = [aDomain cStringUsingEncoding:NSUTF8StringEncoding];
        
        auto ep = std::make_shared<Endpoint>(domainStr, port);
        _socket = std::unique_ptr<TCPSocket>(new TCPSocket(socketFd ,ep));
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
            case socketkit::CommunicatorEvent::OpenCompleted: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(communicator:handleEvent:)]) {
                    [weakSelf.delegate communicator:weakSelf handleEvent:MPCommEventOpenCompleted];
                }
            }
                break;
            case socketkit::CommunicatorEvent::EndEncountered: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(communicator:handleEvent:)]) {
                    [weakSelf.delegate communicator:weakSelf handleEvent:MPCommEventEndEncountered];
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

- (void)open {
    _socket->open();
}

- (void)continueFinished {
    _socket->continueFinished();
}

- (void)write:(NSData *)data {
    auto writeData = std::make_shared<utils::Data>((int)data.length);
    writeData->copy(data.bytes, (int)data.length);
    _socket->write(writeData);
}

- (void)read {
    __weak typeof(self) weakSelf = self;
    _socket->read([weakSelf](std::shared_ptr<utils::Data> readData) {
        if (weakSelf.delegate &&
            [weakSelf.delegate respondsToSelector:@selector(communicator:didReadData:)]) {
            if (readData->getDataSize() > 0) {
                NSData *data = [[NSData alloc] initWithBytes:(const void *)readData->getDataAddress() length:readData->getDataSize()];
                [weakSelf.delegate communicator:weakSelf didReadData:data];
            }
        }
    });
}

- (void)closeWrite {
    _socket->closeWrite();
}


- (void)close {
    _socket->getRunloop()->stop();
}

- (void)dealloc {
    _socket.reset();
}

@end
