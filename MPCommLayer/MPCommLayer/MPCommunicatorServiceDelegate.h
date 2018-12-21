//
//  MPCommunicatorServiceDelegate.h
//  MPCommLayer
//
//  Created by CmST0us on 2018/12/21.
//  Copyright © 2018 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPCommunicatorServiceDelegate <NSObject>
- (void)service:(id)service didReadData:(NSData *)data fromRemote:(NSURL *)remote;
@end

NS_ASSUME_NONNULL_END
