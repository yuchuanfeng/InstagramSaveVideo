#import <UIKit/UIKit.h>

@interface InstagramHeader : NSObject

@end

#pragma mark - data
@interface IGImageProgressView : UIView
@property(readonly, nonatomic) UIImageView *photoImageView;
@end
@interface IGFeedPhotoView : UIView
- (IGImageProgressView*)photoImageView;
@end


@interface IGDiskCache : NSObject
- (NSString *)cachePathForKey:(id)arg1;
- (BOOL)containsDataForKey:(id)arg1;
- (NSData *)dataForKey:(id)arg1;
@property(readonly, copy, nonatomic) NSString *name;
@end

@interface IGImageService : NSObject
{
    IGDiskCache *_diskCache;
}
+ (id)sharedService;
@end

@interface IGStreamingVideoCache : NSObject
{
    IGDiskCache *_diskCache;
}
+ (id)sharedCache;
@end


@interface IGURLCache : NSURLCache
+ (NSString *)cacheKeyForURL:(id)arg1;
@property(readonly, nonatomic) IGDiskCache *dataCache;
@end

#pragma  mark - url
@interface IGFeedItemMediaCell : UIView
- (NSString *)mediaUrlStr;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@property(readonly, nonatomic) IGFeedPhotoView *photoView;
@end

@interface IGTypedURL : NSObject
@property(readonly, nonatomic) NSURL *url;
@property(readonly, nonatomic) double height;
@property(readonly, nonatomic) double width;
@end

@interface IGPhoto : NSObject
@property(retain, nonatomic) NSArray *imageVersions;
@end
@interface IGVideo : NSObject
@property(retain, nonatomic) NSArray *videoVersions;
@property(readonly, nonatomic) NSSet *allVideoURLs;
@end

@interface IGFeedItem : NSObject
@property(readonly) long long mediaType;
@property(readonly) IGPhoto *photo;
@property(readonly) IGVideo *video;
@end
