//
//  CRUtilities.h
//  LoggerFramework
//
//  Created by Karthik Saligrama on 10/3/14.
//
//

#import <Foundation/Foundation.h>

@interface CRUtilities : NSObject

+(NSString *)applicationName;

+(NSString *)stringForDefaultLocale:(NSString *)key;

+(void)registerDefaultsFromSettingsBundle;

+(NSString *)getDeviceId;

+(void)crash;

@end
