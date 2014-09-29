//
//  CRAppDelegate.m
//  LoggerExample
//
//  Created by Karthik Saligrama on 8/12/14.
//
//

#import "CRAppDelegate.h"
#import "CRViewController.h"
#import <LoggerFramework/CRLogger.h>

@implementation CRAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    CRLogger *logger = [CRLogger sharedInstance];
    
    NSString *string = [logger getPreviousLogData];
    NSLog(@"Previous Log File");
    NSLog(@"%@",string);
    
    //register fresh logger;
    [logger clearLog];
    [logger registerLogger];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    viewController = [[CRViewController alloc]init];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    NSSetUncaughtExceptionHandler(&uncaughtException);
    struct sigaction signalaction;
    memset(&signalaction, 0, sizeof(signalaction));
    signalaction.sa_handler =&signalHandler;
    sigaction(SIGABRT, &signalaction, NULL);
    return YES;
}

void signalHandler(int s){
    NSLog(@"signal handler %d" , s);
}

void uncaughtException(NSException *exception){
    NSArray *stack = [exception callStackReturnAddresses];
    NSLog(@"Stack trace: %@", stack);
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
