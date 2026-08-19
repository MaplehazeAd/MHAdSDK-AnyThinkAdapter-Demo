//
//  ATMHAdSDKNativeDelegate.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKNativeDelegate.h"
#import <MHAdSDK/MHNativeAdModel.h>

static MHNativeAd *_lastNativeAd = nil;
static NSArray<MHNativeAdModel *> *_lastModels = nil;

@implementation ATMHAdSDKNativeDelegate

+ (nullable MHNativeAd *)lastLoadedNativeAd {
    return _lastNativeAd;
}

+ (nullable NSArray<MHNativeAdModel *> *)lastLoadedModels {
    return _lastModels;
}

+ (void)clearCache {
    _lastNativeAd = nil;
    _lastModels = nil;
}

- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels {
    NSLog(@"[ATMH] %@ count=%lu", NSStringFromSelector(_cmd), (unsigned long)nativeAdModels.count);

    if (nativeAdModels.count == 0) {
        NSError *error = [NSError errorWithDomain:@"MHNativeAd"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"No fill"}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
        return;
    }

    // 存储 MHNativeAd + models（同 ToBid 的 sideband 模式）
    _lastNativeAd = nativeAd;
    _lastModels = [nativeAdModels copy];

    // 将 MHNativeAdModel 转换为 ATCustomNetworkNativeAd
    NSMutableArray<ATCustomNetworkNativeAd *> *nativeAdArray = [NSMutableArray arrayWithCapacity:nativeAdModels.count];
    for (MHNativeAdModel *model in nativeAdModels) {
        ATCustomNetworkNativeAd *nativeAdObj = [[ATCustomNetworkNativeAd alloc] init];
        nativeAdObj.title = model.title ?: @"";
        nativeAdObj.mainText = model.description ?: @"";
        nativeAdObj.ctaText = model.actionText ?: @"查看详情";
        nativeAdObj.iconUrl = model.iconURL ?: @"";
        nativeAdObj.imageUrl = model.imageURL ?: @"";
        nativeAdObj.mainImageWidth = (CGFloat)model.imageWidth;
        nativeAdObj.mainImageHeight = (CGFloat)model.imageHeight;
        nativeAdObj.isVideoContents = model.isVideoAd;

        // KVC 取内部属性
        NSString *videoURL = [model valueForKey:@"videoURL"];
        if (videoURL.length > 0) {
            nativeAdObj.videoUrl = videoURL;
        }

        // 多图
        NSArray *internalImages = [model valueForKey:@"images"];
        if ([internalImages isKindOfClass:[NSArray class]] && internalImages.count > 0) {
            NSMutableArray<NSString *> *imageList = [NSMutableArray array];
            for (id img in internalImages) {
                NSString *url = [img valueForKey:@"url"];
                if (url.length > 0) {
                    [imageList addObject:url];
                }
            }
            nativeAdObj.imageList = imageList;
        }

        // 保存原始 model 引用（sideband：Cell 通过 lastLoadedModels 取出直接用）
        nativeAdObj.networkNativeAdProduct = model;

        [nativeAdArray addObject:nativeAdObj];
    }

    for (NSUInteger i = 0; i < nativeAdModels.count; i++) {
        MHNativeAdModel *model = nativeAdModels[i];
        ATCustomNetworkNativeAd *nativeAdObj = nativeAdArray[i];
        
        NSInteger ecpm = model.ecpm;
        NSString *priceStr = [NSString stringWithFormat:@"%ld", (long)ecpm];
        if ([priceStr doubleValue] < 0) { priceStr = @"0"; }
        
        NSDictionary *adExtra = @{
            ATAdSendC2SBidPriceKey: priceStr,
            ATAdSendC2SCurrencyTypeKey: @(ATBiddingCurrencyTypeCNYCents)
        };
        [self.adStatusBridge atOnNativeAdLoadedArray:@[nativeAdObj] adExtra:adExtra];
    }
}

- (void)nativeAdLoadFailed:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage {
    NSLog(@"[ATMH] %@ errorCode=%ld msg=%@", NSStringFromSelector(_cmd), (long)errorCode, errorMessage);
    NSError *error = [NSError errorWithDomain:@"MHNativeAd"
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: errorMessage ?: @"unknown"}];
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)nativeAdDidAppear:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)nativeAdDidClick:(MHNativeAd *)nativeAd
             placementID:(NSString *)placementID
                  adView:(MHNativeAdView *)adView
           nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)nativeAdPlayStart:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdVideoStart:nil];
}

- (void)nativeAdPlayFinish:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                    adView:(MHNativeAdView *)adView
             nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdVideoEnd:nil];
}

- (void)nativeAdDetailViewDidAppear:(MHNativeAd *)nativeAd
                        placementID:(NSString *)placementID
                             adView:(MHNativeAdView *)adView
                      nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdDetailWillShow:nil];
}

- (void)nativeAdDetailViewDidClose:(MHNativeAd *)nativeAd
                       placementID:(NSString *)placementID
                            adView:(MHNativeAdView *)adView
                     nativeAdModel:(MHNativeAdModel *)nativeAdModel {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdDetailClosed:nil];
}

@end
