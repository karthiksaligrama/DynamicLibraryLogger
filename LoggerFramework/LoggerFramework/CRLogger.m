//
//  CRLogger.m
//  LoggerExample
//
//  Created by Karthik Saligrama on 8/12/14.
//
//

#import "CRLogger.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>

@implementation CRLogger

static CRLogger *sharedObject;

NSOperationQueue *queue;
NSFileHandle *logFileHandle;
NSString *filePath;


-(id)init{
    return [CRLogger sharedInstance];
}

-(id)initPrivate{
    self = [super init];
    if(self){
        queue = [[NSOperationQueue alloc]init];
        queue.maxConcurrentOperationCount=1;
    }
    return self;
}

+(id)sharedInstance{
    static dispatch_once_t p =0;
    
    dispatch_once(&p, ^{
        sharedObject = [[CRLogger alloc]initPrivate];
    });
    
    return sharedObject;
}

//This code will return the log data
//when the application was previously launched
-(NSString *)getPreviousLogData{
    if(!filePath)
        [self initializeFilePath];
    
    NSString *previousInstanceLog = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return previousInstanceLog;
}

//This code will register the logger to log
//the dynamic libraries when the application
//is loaded or unloaded
-(void)registerLogger{
    _dyld_register_func_for_add_image(&imageAdded);
    _dyld_register_func_for_remove_image(&imageRemoved);
}

#pragma mark - callbacks for image loading and unloading (dyld)
static void imageAdded(const struct mach_header *mac_h,intptr_t s){
    recordImageLoadAndUnload(mac_h, YES);
}

static void imageRemoved(const struct mach_header *mac_h, intptr_t s){
    recordImageLoadAndUnload(mac_h, NO);
}

static void recordImageLoadAndUnload(const struct mach_header *mac_h,bool loaded){
    Dl_info lib_image_info;
    int result =dladdr(mac_h, &lib_image_info);
    
    if(result != 0){
        const char *name = lib_image_info.dli_fname;
        const intptr_t address = (intptr_t)lib_image_info.dli_fbase;
        NSString *loadedString = loaded?LOADED:UNLOADED;
        
        [queue addOperationWithBlock:^(){
            NSString *logString = [NSString stringWithFormat:@"%@ %@: 0x%02lx  %s \n",loadedString,[[NSDate alloc] init],address,name];
            [[CRLogger sharedInstance] persistLogInfo:logString];
        }];
    }
}

#pragma mark - File IO Operation related Methods
-(void)persistLogInfo:(NSString *)logString{
    if(!filePath)
        [self initializeFilePath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath])
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    
    if(!logFileHandle)
        logFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    [logFileHandle seekToEndOfFile];
    [logFileHandle writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
}

//this is done so that file path is initialized only once,
-(void)initializeFilePath{
    NSArray *arrayPaths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [arrayPaths objectAtIndex:0];
    filePath = [docDir stringByAppendingString:LOG_FILE_NAME];
}

-(BOOL)clearLog{
    NSArray *arrayPaths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [arrayPaths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingString:LOG_FILE_NAME];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error;
    if([fm fileExistsAtPath:filePath] && [fm isDeletableFileAtPath:filePath])
        [fm removeItemAtPath:filePath error:&error];
    
    if(error)
        return false;
    
    return true;
}


//close the fileHandle before the dealloc is called.
//this way we dont have a file io leak
-(void)dealloc{
    [logFileHandle closeFile];
    logFileHandle = nil;
}

@end
