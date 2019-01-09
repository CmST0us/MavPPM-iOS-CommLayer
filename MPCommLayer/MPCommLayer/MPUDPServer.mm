//
//  MPUDPServer.m
//  MPCommLayer
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import <libSocketKit/UDPServer.hpp>
#import "MPUDPServer.h"

using namespace std;
struct MPUDPServer_Delegate : public socketkit::CommunicatorServiceDelegate {
    MPUDPServer_Delegate() {
        this->context = NULL;
    };
    
    MPUDPServer_Delegate(void *context) {
        this->context = context;
    };
    
    void *context;
    
    virtual void serviceDidReadData(socketkit::SocketAddress address, uchar *data, int len, std::shared_ptr<socketkit::CommunicatorService> service) {
        @autoreleasepool {
            if (this->context == NULL) {
                return;
            }
            MPUDPServer *ctx = (__bridge MPUDPServer *)this->context;
            NSString *addressString = [[NSString alloc] initWithCString:address.getIpPortPairString().c_str() encoding:NSUTF8StringEncoding];
            NSURL *remoteURL = [NSURL URLWithString:addressString];
            NSData *d = [[NSData alloc] initWithBytes:(const void *)data length:len];
            if (ctx.delegate != NULL &&
                [ctx.delegate respondsToSelector:@selector(service:didReadData:fromRemote:)]) {
                [ctx.delegate service:ctx didReadData:d fromRemote:remoteURL];
            }
        }
    };
    
};

@implementation MPUDPServer {
    socketkit::UDPServer *_server;
    std::shared_ptr<MPUDPServer_Delegate> _warp_delegate;
}

- (instancetype)init {
    return [self initWithListenPort:0];
}

- (instancetype)initWithListenPort:(uint16_t)port {
    self = [super init];
    if (self) {
        _server = new socketkit::UDPServer(port);
        if (_server == nullptr) {
            return NULL;
        }
        void *ctxSelf = (__bridge void *)self;
        _warp_delegate = make_shared<MPUDPServer_Delegate>(ctxSelf);
        weak_ptr<MPUDPServer_Delegate> wp(_warp_delegate);
        _server->mDelegate = wp;
    }
    return self;
}

- (void)setRemoteClientAddress:(NSString *)address port:(uint16_t)port {
    string s = [address cStringUsingEncoding:NSUTF8StringEncoding];
    socketkit::SocketAddress clientRemoteAddress(s, port);
    clientRemoteAddress.startResolveHost();
    _server->mClientAddress = clientRemoteAddress;
}

- (BOOL)start {
    return _server->start();
}

- (BOOL)pause {
    return _server->pause();
}

- (BOOL)resume {
    return _server->resume();
}

- (BOOL)close {
    return _server->close();
}

- (BOOL)writeData:(NSData *)data {
    return _server->writeData((const uchar *)[data bytes], (int)[data length]);
}

- (void)dealloc {
    [self close];
    delete _server;
}

@end
