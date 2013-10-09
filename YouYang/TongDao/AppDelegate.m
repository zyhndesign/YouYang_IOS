//
//  AppDelegate.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LocalSQL.h"
#import "AllVariable.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (ios7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *docProImagePath = [path stringByAppendingPathComponent:@"ProImage"];
    BOOL doct = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:docProImagePath isDirectory:&doct])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docProImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [LocalSQL openDataBase];
    [LocalSQL createLocalTable];
    [LocalSQL closeDataBase];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    RootViewContr = self.viewController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForegroundMode" object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
