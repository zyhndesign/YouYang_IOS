//
//  SimpleTrationView.h
//  TongDao
//
//  Created by sunyong on 13-9-27.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"

@interface SimpleTrationView : UIView<NetworkDelegate>
{
    UIImageView *proImageV;
    UIImageView *bgImageV;
    UILabel *titleLb;
    UILabel *midLineLb;
    UITextView *detailTextV;
    NSDictionary *_infoDict;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict;
@end
