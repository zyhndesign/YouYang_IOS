//
//  ProImageLoadNet.m
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ProImageLoadNet.h"

@implementation ProImageLoadNet
@synthesize delegate;

- (id)initWithDict:(NSDictionary*)infoDict
{
    self = [super init];
    if (self) {
        _infoDict = infoDict;
    }
    return self;
}

- (void)loadImageFromUrl:(NSString*)imageURLStr
{
    imageUrl = [imageURLStr retain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        backData = [[NSMutableData data] retain];
    }
    else
    {
        backData = nil;
        [delegate didReceiveErrorCode:nil];
    }
    [request release];
    [connectNet release];
}

- (void)reloadUrlData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        if (backData)
        {
            [backData release];
        }
        backData = [[NSMutableData data] retain];
    }
    else
    {
        backData = nil;
    }
    [request release];
    [connectNet release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connectNum == 3)
    {
        [delegate didReceiveErrorCode:error];
    }
    else
    {
        connectNum++;
        [self reloadUrlData];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    return nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    if(_infoDict == nil)
    {
        [delegate didReciveImage:[UIImage imageWithData:backData]];
        return;
    }
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@", [_infoDict objectForKey:@"id"], proImgeFormat]];
    [backData writeToFile:pathProFile atomically:YES];
    if (delegate && [delegate respondsToSelector:@selector(didReciveImage:)])
    {
        [delegate didReciveImage:[UIImage imageWithData:backData]];
    }
}

- (void)dealloc
{
    if (backData)
        [backData release];
    [imageUrl release];
    [super dealloc];
}


@end
