//
//  ImageViewShowContr.h
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "ActionView.h"
@class ProImageLoadNet;

@interface ImageViewShowContr : UIViewController<NetworkDelegate>
{
    
    IBOutlet UIImageView  *imageView;
	IBOutlet UIScrollView *scrllview;
    CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;
    
    NSString *urlStr;
	ActionView *myActivew;
    ProImageLoadNet *imageLoadNet;
}

- (id)initwithURL:(NSString*)URLStr;
@end
