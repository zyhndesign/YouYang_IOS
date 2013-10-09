//
//  LoadZipFileNet.h
//  GYSJ
//
//  Created by sunyong on 13-8-2.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface LoadZipFileNet : NSObject
{
    NSMutableData *backData;
    NSString *zipStr;
    int connectNum;
}
@property(nonatomic, assign)id<NetworkDelegate>delegate;
@property(nonatomic, retain)NSString *md5Str;
@property(nonatomic, retain)NSString *urlStr;

- (void)loadMenuFromUrl:(NSString*)ZipStr;

@end
