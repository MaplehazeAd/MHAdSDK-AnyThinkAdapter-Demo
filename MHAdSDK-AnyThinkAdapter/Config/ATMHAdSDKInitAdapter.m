//
//  ATMHAdSDKInitAdapter.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKInitAdapter.h"
#import <MHAdSDK/MHAdSDK.h>

static NSString *const kATMHAdapterVersion = @"1.0.0";

@implementation ATMHAdSDKInitAdapter

- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument {
    NSDictionary *serverInfo = adInitArgument.serverContentDic;

    // 从 serverInfo 取 MHAdSDK 的 appID
    NSString *appID = serverInfo[@"appID"];
    if (!appID.length) {
        appID = serverInfo[@"app_id"];
    }

    MHAdConfiguration *config = [MHAdConfiguration sharedConfig];
    if (appID.length) {
        config.appID = appID;
    }

    // 个性化推荐
    config.personalizedState = adInitArgument.personalizedAdState;

    // 执行 MHAdSDK 注册
    [[MHAdManager sharedManager] registerApp];

    // MHAdSDK 没有明确的初始化成功/失败回调，直接通知成功
    [self notificationNetworkInitSuccess];
}

+ (nullable NSString *)sdkVersion {
    return [[MHAdManager sharedManager] version];
}

+ (nullable NSString *)adapterVersion {
    return kATMHAdapterVersion;
}

@end
