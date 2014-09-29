//
//  CRCrashReporter.m
//  LoggerFramework
//
//  Created by Karthik Saligrama on 9/29/14.
//
//

#import "CRCrashReporter.h"
#import <execinfo.h>

@implementation CRCrashReporter

NSString *const CRSignalKey = @"CRSignalKey";
NSString *const CRAddressKey = @"CRAddressKey";
NSString *const CRExceptionNameKey = @"CRExceptionNameKey";

static CRCrashReporter *sharedObject;

-(id)init{
    return [CRCrashReporter sharedInstance];
}

-(id)initPrivate{
    self = [super init];
    if(self){
        
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
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    
    //check for pending crash reports, if present show them alert dialog to send the data to server
    
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
