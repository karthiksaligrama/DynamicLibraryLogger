//
//  CRRemoteReportSender.m
//  LoggerFramework
//
//  Created by Karthik Saligrama on 9/29/14.
//
//

#import "CRRemoteReportSender.h"

@implementation CRRemoteReportSender

+(void)sendReportWithException:(NSException *)exception{
    NSDictionary *userInfo = [exception userInfo];
    [[CRRemoteReportSender class]sendReportWithUserInfo:userInfo];
}

+(void)sendReportWithUserInfo:(NSDictionary *)userInfo{
    
}

+(NSString *) extractTextInformation{
    return nil;
}

@end