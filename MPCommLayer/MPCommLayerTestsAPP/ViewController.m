//
//  ViewController.m
//  MPCommLayerTestsAPP
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) MPUDPSocket *socket;
@property (nonatomic, strong) MPTCPSocket *tcpSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socket = [[MPUDPSocket alloc] initWithLocalPort:14560 delegate:self];
    self.tcpSocket = [[MPTCPSocket alloc] initWithDelegate:self];
    
    [self.socket connect:@"127.0.0.1" port:14561];
    [self.socket write:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.tcpSocket connect:@"127.0.0.1" port:12001];
    
//    __weak typeof(self) weakSelf = self;
//    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        weakSelf.socket = NULL;
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)communicator:(id)aCommunicator didReadData:(NSData *)data {
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"recv: %@", s);
    [aCommunicator write:data];
}

- (void)communicator:(id)aCommunicator handleEvent:(MPCommEvent)event {
    if (event == MPCommEventHasBytesAvailable) {
        [aCommunicator read];
    }
    if (event == MPCommEventOpenCompleted) {
        if ([aCommunicator isEqual:self.tcpSocket]) {
            
            [self.tcpSocket write:[@"hello\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    if (event == MPCommEventErrorOccurred) {
        NSLog(@"error");
    }
    if (event == MPCommEventEndEncountered) {
        if ([aCommunicator isEqual:self.tcpSocket]) {
            
        }
        
    }
}

@end
