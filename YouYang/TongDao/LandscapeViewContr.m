//
//  LandscapeViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LandscapeViewContr.h"
#import "SimpleLandscView.h"
@interface LandscapeViewContr ()

@end

@implementation LandscapeViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    contentScrolV.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];

    [super viewDidLoad];
}

#define StartX 140
#define StartY 105
#define Gap 15
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/6;
    if (initAry.count%6)
        page++;
    if (page > 1)
        rightBg.hidden = NO;
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < 18; i++)
    {
        SimpleLandscView *simleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        page = i/6;
        int rowX = (i%6)/2;
        int rowY = i%2;
        [simleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simleLandscView.frame.size.height, simleLandscView.frame.size.width, simleLandscView.frame.size.height)];
        simleLandscView.tag = i + 1;
        [contentScrolV addSubview:simleLandscView];
        [simleLandscView release];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    for (int i = (midPage-2)*6; i < initAry.count && i < (midPage+2)*6; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            SimpleLandscView *simleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            int page = i/6;
            int rowX = (i%6)/2;
            int rowY = i%2;
            [simleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simleLandscView.frame.size.height, simleLandscView.frame.size.width, simleLandscView.frame.size.height)];
            simleLandscView.tag = i + 1;
            [contentScrolV addSubview:simleLandscView];
            [simleLandscView release];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    for (int i = currentPage*6; i < initAry.count && i < (currentPage+1)*6; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            simpleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            int page = i/6;
            int rowX = (i%6)/2;
            int rowY = i%2;
            [simpleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simpleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simpleLandscView.frame.size.height, simpleLandscView.frame.size.width, simpleLandscView.frame.size.height)];
            simpleLandscView.tag = i + 1;
            [contentScrolV addSubview:simpleLandscView];
            [simpleLandscView release];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*6 + 1 || view.tag > (midPage + 2)*6 + 1)
        {
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
            int page = offset/1024;
            [self removeRemainMenuView:page];
            [self rebuildNewMenuView:page];
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
            int page = offset/1024;
            [self removeRemainMenuView:page];
            [self rebuildNewMenuView:page];
            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x + 1024, 0) animated:YES];
            if(offset > contentScrolV.contentSize.width - 1040)
                rightBg.hidden = YES;
        }
        leftBt.hidden = NO;
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
    
}

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
