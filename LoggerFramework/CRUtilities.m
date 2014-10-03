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

@end
