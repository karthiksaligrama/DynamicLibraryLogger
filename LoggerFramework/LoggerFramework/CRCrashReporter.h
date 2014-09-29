//
//  CRCrashReporter.h
//  LoggerFramework
//
//  Created by Karthik Saligrama on 9/29/14.
//
//

#import <Foundation/Foundation.h>

@protocol CRCrashreporterDelegate;

@interface CRCrashReporter : NSObject

+(id)sharedInstance;

-(void)registerCrashReporter;


@property(nonatomic,weak) id<CRCrashreporterDelegate> delegate;


@end

@protocol CRCrashreporterDelegate <NSObject>

-(void)saveApplicationState;

@end
