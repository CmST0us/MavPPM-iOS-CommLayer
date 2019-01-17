//
//  MPCommManager.h
//  MPCommLayer
//
//  Created by CmST0us on 2019/1/17.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPCommManager : NSObject
+ (void)initCommLayer;
+ (void)releaseCommLayer;
@end

NS_ASSUME_NONNULL_END
