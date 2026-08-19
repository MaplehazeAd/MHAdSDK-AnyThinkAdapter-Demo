//
//  ATMHAdSDKRewardedVideoDelegate.h
//  MHAdSDK-TopOnAdapter
//

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <MHAdSDK/MHRewardedVideoAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATMHAdSDKRewardedVideoDelegate : NSObject <MHRewardedVideoAdDelegete>

@property (nonatomic, strong) ATRewardedAdStatusBridge *adStatusBridge;

@end

NS_ASSUME_NONNULL_END
