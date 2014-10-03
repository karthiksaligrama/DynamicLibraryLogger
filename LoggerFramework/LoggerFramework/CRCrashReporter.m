//
//  CRCrashReporter.m
//  LoggerFramework
//
//  Created by Karthik Saligrama on 9/29/14.
//
//

#import "CRCrashReporter.h"
#import "CRUtilities.h"
#import <UIKit/UIKit.h>
#import <execinfo.h>

@interface CRCrashReporter()<UIAlertViewDelegate>

@end

@implementation CRCrashReporter

static CRCrashReporter *sharedObject;

-(id)init{
    return [CRCrashReporter sharedInstance];
}

-(id)initPrivate{
    self = [super init];
    if(self){
        [CRUtilities registerDefaultsFromSettingsBundle];
    }
    return self;
}

+(id)sharedInstance{
    static dispatch_once_t p =0;
    
    dispatch_once(&p, ^{
        sharedObject = [[CRCrashReporter alloc]initPrivate];
    });
    
    return sharedObject;
}

-(void)registerCrashReporter{
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    BOOL enableCrashReporter = [userDefaults boolForKey:@"CRASH_ENABLED"];
    if(!enableCrashReporter){
        NSLog(@"Warning!!! Crash reporter is not enabled. Application will continue to crash");
        return;
    }
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    
    //check for pending crash reports, if present show them alert dialog to send the data to server
    BOOL isPreviousLaunchCrash = [userDefaults boolForKey:CRApplicationCrashed];
    
    if(isPreviousLaunchCrash){
        NSDictionary *userInfo = [userDefaults objectForKey:CRApplicationCrashLog];
        if(userInfo){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[CRUtilities stringForDefaultLocale:@"CR_ALERT_TITLE"]
                                                         message:[CRUtilities stringForDefaultLocale:@"CR_ALERT_MESSAGE"]
                                                         delegate:self
                                                         cancelButtonTitle:@"Not this time"
                                                         otherButtonTitles:@"Yes", nil];
            [alertView show];
            
        }
    }
    [userDefaults setBool:NO forKey:CRApplicationCrashed];
    [userDefaults synchronize];
}

//function to get the backtrace when a function has crashed.
+(NSArray *)getBackTrace{
    void* bt[1024];
    
    int bt_size;
    char **bt_syms;
    
    bt_size = backtrace(bt, 1024);
    bt_syms = backtrace_symbols(bt, bt_size);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:bt_size];
    
    for(int i=1;i<bt_size;i++){
        [backtrace addObject:[NSString stringWithUTF8String:bt_syms[i]]];
    }
    
    free(bt_syms);
    
    return [backtrace copy];
}

-(void)handleException:(NSException *)exception{
    //save application state
    if(self.delegate && [self.delegate respondsToSelector:@selector(saveApplicationState)]){
        [self.delegate saveApplicationState];
    }
    
    //todo: do your thing where log it in file etc etc.,
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:CRApplicationCrashed];
    [userDefaults setObject:exception.userInfo forKey:CRApplicationCrashLog];
    [userDefaults synchronize];
}

#pragma mark - alert view delegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != [alertView cancelButtonIndex]){
        //TODO: work with the remote report sender class to send the report
    }
}

#pragma mark - C Methods
void UncaughtExceptionHandler(NSException *exception) {
    //TODO: do something here. ex: Log it on server.
    //need to incorporate permission
    NSArray *callStack = [CRCrashReporter getBackTrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:CRAddressKey];
    
    [[CRCrashReporter sharedInstance] performSelectorOnMainThread:@selector(handleException:)
                                                       withObject:[NSException exceptionWithName:[exception name]
                                                                                          reason:[exception reason]
                                                                                        userInfo:userInfo]
                                                    waitUntilDone:YES];
}

void SignalHandler(int signal){
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                       forKey:CRSignalKey];
    
    NSArray *callStack = [CRCrashReporter getBackTrace];
    
    [userInfo setObject:callStack
                 forKey:CRAddressKey];
    
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:CRSignalKey];
    
    NSException *exception = [NSException exceptionWithName:CRExceptionNameKey
                                                     reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal]
                                                   userInfo:userInfo];
    
    [[CRCrashReporter sharedInstance] performSelectorOnMainThread:@selector(handleException:)
                                                       withObject:exception
                                                    waitUntilDone:YES];
}



@end
