//
//  MPTCPAcceptor.m
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/15.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <libSocketKit/TCPAcceptor.hpp>

#import "MPTCPAcceptor.h"
#import "MPTCPSocket.h"

using namespace socketkit;

@interface MPTCPAcceptor () {
    std::unique_ptr<TCPAcceptor> _acceptor;
}

@end

@implementation MPTCPAcceptor

- (instancetype)init {
    return [self initWithDelegate:NULL];
}

- (instancetype)initWithDelegate:(id<MPCommTCPAcceptorDelegate>)delegate {
    self = [super init];
    if (self) {
        _acceptor = std::unique_ptr<TCPAcceptor>(new TCPAcceptor());
        self.delegate = delegate;
        _acceptor->getRunloop()->run();
    }
    return self;
}

- (void)setDelegate:(id<MPCommTCPAcceptorDelegate>)delegate {
    __weak typeof(self) weakSelf = self;
    auto eh = [weakSelf](TCPAcceptor *acceptor, TCPAcceptorEvent event) {
        switch (event) {
            case socketkit::TCPAcceptorEvent::CanAccept: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(acceptor:handleEvent:)]) {
                    [weakSelf.delegate acceptor:weakSelf handleEvent:MPCommTCPAcceptorEventCanAccept];
                }
            }
                break;
            case socketkit::TCPAcceptorEvent::Error: {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(acceptor:handleEvent:)]) {
                    [weakSelf.delegate acceptor:weakSelf handleEvent:MPCommTCPAcceptorEventError];
                }
            }
            default:
                break;
        }
    };
    _acceptor->mEventHandler = eh;
}


- (void)bindToPort:(short)aPort {
    std::shared_ptr<Endpoint> ep = std::make_shared<Endpoint>("0.0.0.0", aPort);
    _acceptor->bind(ep);
}

- (void)listen:(int)backlog {
    _acceptor->listen(backlog);
}

- (void)accept {
    __weak typeof(self) weakSelf = self;
    auto acceptHandle = [weakSelf](TCPAcceptor *acceptor, std::shared_ptr<TCPSocket> socket) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(acceptor:didAcceptSocket:)]) {
            NSString *domainString = [[NSString alloc] initWithCString:socket->connectingEndpoint()->getEndpointDomain().c_str() encoding:NSUTF8StringEncoding];
            
            MPTCPSocket *s = [[MPTCPSocket alloc] initWithSocketFd:socket->getSocketFd() endpointDomain:domainString endpointPort:socket->connectingEndpoint()->getEndpointPort()];
            
            [weakSelf.delegate acceptor:weakSelf didAcceptSocket:s];
        }
    };
    _acceptor->accept(acceptHandle);
}

@end
