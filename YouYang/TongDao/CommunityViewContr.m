//
//  CommunityViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "CommunityViewContr.h"
#import "SimpleHumanityView.h"

@interface CommunityViewContr ()

@end

@implementation CommunityViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#define StartX 72
#define StartY 155
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/4;
    if (initAry.count%4)
        page++;
    if (page > 1)
        rightBg.hidden = NO;
    [contentScrolV setContentSize:CGSizeMake(page*1024, contentScrolV.frame.size.height)];
    
    for (int i = 0; i < page; i++)
    {
        UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(StartX + i*1024, StartY - 2, 880, 1)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [contentScrolV addSubview:topLine];
        [topLine release];
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(StartX + i*1024, StartY + 401, 880, 1)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [contentScrolV addSubview:bottomLine];
        [bottomLine release];
    }
    
    for (int i = 0; i < initAry.count; i++)
    {
        page = i/4;
        if ((i+1)%4 && i!=(initAry.count-1))
        {
            UILabel *midLb = [[UILabel alloc] initWithFrame:CGRectMake(page*1024 + StartX + (i%4)*220 -1, StartY + 15, 1, 400 - 30)];
            midLb.backgroundColor = [UIColor lightGrayColor];
            [contentScrolV addSubview:midLb];
            [midLb release];
        }
    }
    for (int i = 0; i < initAry.count && i < 18; i++)
    {
        page = i/4;
        SimpleHumanityView *simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
        simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
        simpleHimanView.tag = i + 1;
        [contentScrolV addSubview:simpleHimanView];
        [simpleHimanView release];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    for (int i = (midPage-2)*4; i < initAry.count && i < (midPage+2)*4; i++)
    {
        if (i < 0)
            continue;
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/4;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
            [simpleHimanView release];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    for (int i = currentPage*4; i < initAry.count && i < (currentPage+1)*4; i++)
    {
        if (i < 0)
            continue;
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/4;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
            [simpleHimanView release];
            
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*4 + 1 || view.tag > (midPage + 2)*4 + 1)
        {
            NSLog(@"%d-->remove:%p",(view.tag-1)/6, view);
            [view removeFromSuperview];
        }
    }
}



- (void)dealloc
{
    [initAry release];
    [super dealloc];
}

- (IBAction)skipPage:(UIButton*)sender
{
    if (sender == leftBt)
    {
        if (contentScrolV.contentOffset.x >= 1024)
        {
            float offset = contentScrolV.contentOffset.x - 1024;
            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x - 1024, 0) animated:YES];
            if(offset < 1000)
                leftBt.hidden = YES;
        }
        rightBg.hidden = NO;
    }
    else
    {
        if (contentScrolV.contentOffset.x <= contentScrolV.contentSize.width - 1024)
        {
            float offset = contentScrolV.contentOffset.x + 1024;
            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x + 1024, 0) animated:YES];
            if(offset > contentScrolV.contentSize.width - 1040)
                rightBg.hidden = YES;
        }
        leftBt.hidden = NO;
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (scrollView.contentSize.width == 1024)
        {
            leftBt.hidden  = YES;
            rightBg.hidden = YES;
            return;
        }
        if (scrollView.contentOffset.x < 1024 - 100)
            leftBt.hidden = YES;
        else
            leftBt.hidden = NO;
        
        if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
            rightBg.hidden = YES;
        else
            rightBg.hidden = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
    if (scrollView.contentSize.width == 1024)
    {
        leftBt.hidden  = YES;
        rightBg.hidden = YES;
        return;
    }
    if (scrollView.contentOffset.x < 1024 - 100)
        leftBt.hidden = YES;
    else
        leftBt.hidden = NO;
    
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
        rightBg.hidden = YES;
    else
        rightBg.hidden = NO;
}


@end
