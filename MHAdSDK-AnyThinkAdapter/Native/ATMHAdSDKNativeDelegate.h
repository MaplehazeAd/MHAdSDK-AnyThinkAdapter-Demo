//
//  ATMHAdSDKNativeDelegate.h
//  MHAdSDK-TopOnAdapter
//

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <MHAdSDK/MHNativeAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATMHAdSDKNativeDelegate : NSObject <MHNativeAdDelegete>

@property (nonatomic, strong) ATNativeAdStatusBridge *adStatusBridge;

/// 最近一次加载的 MHNativeAd 对象（用于 showInViews: 曝光注册）
+ (nullable MHNativeAd *)lastLoadedNativeAd;

/// 最近一次加载的 MHNativeAdModel 数组
+ (nullable NSArray<MHNativeAdModel *> *)lastLoadedModels;

/// 清空缓存
+ (void)clearCache;

@end

NS_ASSUME_NONNULL_END
