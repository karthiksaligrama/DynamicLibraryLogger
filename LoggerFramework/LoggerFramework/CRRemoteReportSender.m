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
    //Todo: setup settings.bundle
    //add suppport for sending the data through multiple channels - mails, http, etc
    //phase 1 lets just send an email of the crash report.
}

+(NSString *) extractTextInformation{
    return nil;
}

@end