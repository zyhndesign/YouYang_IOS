//
//  HumanityViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HumanityViewContr : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    
    IBOutlet UIImageView *animaImageViewOne;
    IBOutlet UIImageView *animaImageViewTwo;
    IBOutlet UIImageView *animaImageViewThr;
    
    IBOutlet UIButton *leftBt;
    IBOutlet UIButton *rightBg;
    
    UILabel *progressLb;
    
    NSArray *initAry;
    
    int pageLenght;
}
- (void)loadSubview:(NSArray*)ary;
- (IBAction)skipPage:(UIButton*)sender;

@end
