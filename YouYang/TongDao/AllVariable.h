//
//  AllVariable.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#ifndef TongDao_AllVariable_h
#define TongDao_AllVariable_h
#import "QueueZipHandle.h"
#import "QueueProHanle.h"

@class ViewController;
@class SCGIFImageView;
@class ActionView;
ViewController *RootViewContr;
UIScrollView *AllScrollView;
__strong ActionView *AllActiveView;
int AllOnlyShowPresentOne;  // 只能同时展开一个详细内容
SCGIFImageView* gifImageView;
UIImageView *playMusicImageV;
#endif