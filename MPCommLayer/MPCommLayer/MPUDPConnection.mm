//
//  MPUDPConnection.m
//  MPCommLayer
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import <libSocketKit/UDPConnection.hpp>

#import "MPUDPConnection.h"

using namespace std;


struct MPUDPConnection_Delegate : public ts::CommunicatorServiceDelegate {
    MPUDPConnection_Delegate() {
        this->context = NULL;
    };
    
    MPUDPConnection_Delegate(void *context) {
        this->context = context;
    };
    
    void *context;
    
    virtual void serviceDidReadData(ts::SocketAddress address, uchar *data, int len, std::shared_ptr<ts::CommunicatorService> service) {
        ::printf("[IN]Connect: %s\n", (const char *)data);
        if (this->context == NULL) {
            return;
        }
        MPUDPConnection *ctx = (__bridge MPUDPConnection *)this->context;
        
    };
    
};

@implementation MPUDPConnection {
    ts::UDPConnection *_connection;
    std::shared_ptr<MPUDPConnection_Delegate> _delegate;
}

- (instancetype)initWithRemoteHostName:(NSString *)hostname port:(uint16_t)port {
    self = [super init];
    if (self) {
        std::string hostnameString([hostname cStringUsingEncoding:NSUTF8StringEncoding]);
        _connection = new ts::UDPConnection(hostnameString, port);
        if (_connection == nullptr) {
            return NULL;
        }
        void *ctxSelf = (__bridge void *)self;
        _delegate = make_shared<MPUDPConnection_Delegate>(ctxSelf);
        weak_ptr<MPUDPConnection_Delegate> wp(_delegate);
        _connection->mDelegate = wp;
    }
    return self;
}

- (BOOL)start {
    return _connection->start();
}

- (BOOL)pause {
    return _connection->pause();
}

- (BOOL)resume {
    return _connection->resume();
}

- (BOOL)close {
    return _connection->close();
}

- (BOOL)writeData:(NSData *)data {
    return _connection->writeData((const uchar *)[data bytes], (int)[data length]);
}

- (void)dealloc {
    [self close];
    delete _connection;
}

@end
