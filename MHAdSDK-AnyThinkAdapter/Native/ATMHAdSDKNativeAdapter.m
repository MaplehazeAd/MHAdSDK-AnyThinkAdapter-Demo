//
//  ATMHAdSDKNativeAdapter.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKNativeAdapter.h"
#import "ATMHAdSDKNativeDelegate.h"
#import <MHAdSDK/MHNativeAd.h>

@interface ATMHAdSDKNativeAdapter ()

@property (nonatomic, strong) ATMHAdSDKNativeDelegate *nativeDelegate;
@property (nonatomic, strong) MHNativeAd *nativeAd;

@end

@implementation ATMHAdSDKNativeAdapter

@synthesize adStatusBridge = _adStatusBridge;

- (ATMHAdSDKNativeDelegate *)nativeDelegate {
    if (!_nativeDelegate) {
        _nativeDelegate = [[ATMHAdSDKNativeDelegate alloc] init];
        _nativeDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _nativeDelegate;
}

- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    NSDictionary * serverContentDic = argument.serverContentDic;
    NSString *placementID = serverContentDic[@"slot_id"];
    if (!placementID.length) {
        placementID = argument.serverContentDic[@"placement_id"];
    }

    self.nativeAd = [[MHNativeAd alloc] initWithPlacementID:placementID];

    // 静音配置
    NSString *muteStr = argument.localInfoDic[@"MHIsMuted"];
    if (muteStr) {
        self.nativeAd.isMuted = [muteStr boolValue];
    } else {
        self.nativeAd.isMuted = YES;
    }

    // 自动播放配置
    NSString *autoPlayStr = argument.localInfoDic[@"MHAutoPlayMobileNetwork"];
    if (autoPlayStr) {
        [self.nativeAd updateAutoPlay:[autoPlayStr boolValue]];
    } else {
        [self.nativeAd updateAutoPlay:NO];
    }

    self.nativeAd.delegate = self.nativeDelegate;

    NSNumber *loadCount = argument.localInfoDic[@"loadCount"];
    NSInteger count = loadCount ? [loadCount integerValue] : 1;
    if (count > 1) {
        [self.nativeAd loadAdWithCount:MIN(count, 3)];
    } else {
        [self.nativeAd loadAd];
    }
}

@end
