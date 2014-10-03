//
//  CRUtilities.m
//  LoggerFramework
//
//  Created by Karthik Saligrama on 10/3/14.
//
//

#import "CRUtilities.h"

@implementation CRUtilities

+(NSString *)applicationName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+(NSString *)stringForDefaultLocale:(NSString *)key{
    return NSLocalizedString(key, @nil);
}


@end