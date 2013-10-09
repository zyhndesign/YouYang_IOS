//
//  ImageViewShowContr.m
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ImageViewShowContr.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ViewController.h"

@interface ImageViewShowContr ()

@end

@implementation ImageViewShowContr

- (id)initwithURL:(NSString*)URLStr
{
    if ((self = [super init]))
    {
        URLStr = [URLStr stringByReplacingOccurrencesOfString:@"*_*" withString:@"/"];
        NSArray *tempAryOne = [URLStr componentsSeparatedByString:@"show_image"];
        if (tempAryOne.count < 2)
            return self;
        URLStr = [tempAryOne objectAtIndex:0];
        if (tempAryOne.count < 2)
            return self;

        URLStr = [NSString stringWithFormat:@"%@wp-content/uploads%@", URLStr, [tempAryOne objectAtIndex:1]];
        urlStr = [URLStr retain];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [scrllview setMaximumZoomScale:8];
    [scrllview setMinimumZoomScale:0.2];
    [imageView setCenter:CGPointMake(512, 339)];
    
    [scrllview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    myActivew = [[ActiveView alloc] initWithFrame:CGRectZero];
    myActivew.center = CGPointMake(512, 370);
    [myActivew startActive];
    [self.view addSubview:myActivew];
    
    imageLoadNet = [[ProImageLoadNet alloc] initWithDict:nil];
    imageLoadNet.delegate = self;
    [imageLoadNet loadImageFromUrl:urlStr];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [scrllview removeObserver:self forKeyPath:@"contentSize" context:nil];
    [imageLoadNet release];
    [urlStr       release];
    [myActivew release];
    
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    
    [scrllview removeFromSuperview];
    [scrllview release];
    scrllview = nil;
    
    [super dealloc];
}

- (IBAction)backPress:(id)sender
{
    [imageLoadNet setDelegate:nil];
    [myActivew stopActive];
    [myActivew removeFromSuperview];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [self.view setFrame:CGRectMake(0, 768, self.view.frame.size.width, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                         [self.view removeFromSuperview];
                         [self release];
                     }];
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"contentSize"])
    {
        if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, 339)];
        else if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width >= 1024)
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, 339)];
        else if (scrllview.contentSize.height >= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, scrllview.contentSize.height/2)];
        else
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, scrllview.contentSize.height/2)];
	}
}

#pragma mark imageLoadDelegate

- (void)didReciveImage:(UIImage *)backImage
{
    [myActivew stopActive];
    [myActivew removeFromSuperview];
    [imageView setImage:backImage];
    float W = CGImageGetWidth(backImage.CGImage);
    float H = CGImageGetHeight(backImage.CGImage);
    [imageView setFrame:CGRectMake(0, 0, W, H)];
    [imageView setCenter:CGPointMake(512, 339)];
    [scrllview setContentSize:CGSizeMake(W, H)];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    [myActivew stopActive];
    [myActivew removeFromSuperview];
    [imageView setImage:[UIImage imageNamed:@"404-1.png"]];
}

@end
