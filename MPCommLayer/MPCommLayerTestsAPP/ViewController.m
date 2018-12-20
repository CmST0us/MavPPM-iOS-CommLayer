//
//  ViewController.m
//  MPCommLayerTestsAPP
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import "ViewController.h"
#import <MPCommLayer/MPUDPConnection.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MPUDPConnection *c = [[MPUDPConnection alloc] initWithRemoteHostName:@"127.0.0.1" port:12001];
    [c start];
    NSString *str = @"hello";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [c writeData:data];
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end
