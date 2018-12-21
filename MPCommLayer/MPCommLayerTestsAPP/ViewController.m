//
//  ViewController.m
//  MPCommLayerTestsAPP
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import "ViewController.h"
#import <MPCommLayer/MPUDPServer.h>

@interface ViewController ()
@property (nonatomic, strong) MPUDPServer *server;
@property (nonatomic, assign) BOOL isFindRemoteClientAddress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.server = [[MPUDPServer alloc] initWithListenPort:12001];
    self.server.delegate = self;
    [self.server start];
    
    self.isFindRemoteClientAddress = NO;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)service:(id)service didReadData:(NSData *)data fromRemote:(NSURL *)remote {
    if (self.isFindRemoteClientAddress == NO) {
        NSString *clientString = [remote absoluteString];
        NSString *clientIpString = [clientString componentsSeparatedByString:@":"][0];
        NSString *clientPortString = [clientString componentsSeparatedByString:@":"][1];
        [self.server setRemoteClientAddress:clientIpString port:[clientPortString intValue]];
        self.isFindRemoteClientAddress = YES;
    }
    
    
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"\nRECV: %@\nFROM: %@", s, [remote absoluteString]);
}

@end
