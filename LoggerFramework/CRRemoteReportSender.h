//
//  CRRemoteReportSender.h
//  LoggerFramework
//
//  Created by Karthik Saligrama on 9/29/14.
//
//

#import <Foundation/Foundation.h>

@protocol CRRemoteReportSenderDelegate;

@interface CRRemoteReportSender : NSObject

+(void)sendReportWithUserInfo:(NSDictionary *)userInfo;

+(void)sendReportWithException:(NSException *)exception;

@property(nonatomic,weak) id<CRRemoteReportSenderDelegate> delegate;

@end


@protocol CRRemoteReportSenderDelegate <NSObject>

@optional
-(void)reportIsBeingSent;

-(void)reportIsSent;

@end
