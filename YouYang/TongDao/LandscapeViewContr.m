//
//  LandscapeViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LandscapeViewContr.h"
#import "SimpleLandscView.h"
#import "AllVariable.h"

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
    [super viewDidLoad];
}

#define StartX 122
#define StartY 264
#define Gap 30
#define PageSize 3
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/PageSize;
    if (initAry.count%PageSize)
        page++;

    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        page = i/PageSize;
        int row = i%PageSize;
        SimpleLandscView *simpleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        [simpleLandscView setFrame:CGRectMake(1024*page + StartX + row*simpleLandscView.frame.size.width + row*Gap, StartY, simpleLandscView.frame.size.width, simpleLandscView.frame.size.height)];
        simpleLandscView.tag = i + 1;
        [contentScrolV addSubview:simpleLandscView];
        [simpleLandscView release];
    }
    
}
- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for (int i = (midPage-2)*PageSize; i < initAry.count && i < (midPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            SimpleLandscView *simpleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleLandscView setFrame:CGRectMake(1024*page + StartX + row*simpleLandscView.frame.size.width + row*Gap, StartY, simpleLandscView.frame.size.width, simpleLandscView.frame.size.height)];
            simpleLandscView.tag = i + 1;
            [contentScrolV addSubview:simpleLandscView];
            [simpleLandscView release];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for (int i = (currentPage-2)*PageSize; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            SimpleLandscView *simpleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleLandscView setFrame:CGRectMake(1024*page + StartX + row*simpleLandscView.frame.size.width + row*Gap, StartY, simpleLandscView.frame.size.width, simpleLandscView.frame.size.height)];
            simpleLandscView.tag = i + 1;
            [contentScrolV addSubview:simpleLandscView];
            [simpleLandscView release];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*PageSize + 1 || view.tag > (midPage + 3)*PageSize + 1)
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

#pragma mark - scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];

}

@end
