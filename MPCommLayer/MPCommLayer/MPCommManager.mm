//
//  MPCommManager.m
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/17.
//  Copyright © 2019 eric3u. All rights reserved.
//
#import <libSocketKit/SocketKit.hpp>

#import "MPCommManager.h"

@implementation MPCommManager

+ (void)initCommLayer {
    socketkit::initialize();
}

+ (void)releaseCommLayer {
    socketkit::release();
}

@end
