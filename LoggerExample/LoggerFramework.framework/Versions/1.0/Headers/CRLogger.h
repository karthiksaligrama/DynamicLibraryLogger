//
//  CRLogger.h
//  LoggerExample
//
//  Created on 8/12/14.
//

@interface CRLogger : NSObject

//Logger is a singleton object
+(id)sharedInstance;

//Register the logger to listen to loading and unloading of binary images
-(void)registerLogger;

//fetch the log data from the previous launches
//If you have not called clear log, then you will get the log data dump
//since the last time clear log was called
-(NSString *)getPreviousLogData;

//to clear all the log information
-(BOOL)clearLog;

@end
