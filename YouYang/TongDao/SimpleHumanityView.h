//
//  SimpleHumanityView.h
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"

@interface SimpleHumanityView : UIView<NetworkDelegate>
{
    UIImageView *proImageV;
    UILabel *titleLb;
    UILabel *midLineLb;
    UILabel *timeLb;
    UITextView *detailTextV;
    
    int Mode;
    NSDictionary *_infoDict;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict mode:(int)mode;

@end
