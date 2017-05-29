//
//  InstagramTweakTool.m
//  78-huibian
//
//  Created by 于传峰 on 2017/5/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "InstagramTweakTool.h"
#import<CommonCrypto/CommonDigest.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

@implementation InstagramTweakTool

+ (NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)videoKeyForUrlStr:(NSString *)url {
    NSString* key;
    key =  [self md5:url];
    key = [key stringByAppendingString:@".stream"];
    return key;
}

+ (NSString *)mp4filePathWithDataPath:(NSString *)dataPath {
    NSString* filePath = [dataPath copy];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    NSString* saveFolderName = @"SavedVideoFile";
    NSString* lastComponent = [[filePath componentsSeparatedByString:@"/"] lastObject];
    NSString* mp4path = [cachePath stringByAppendingPathComponent:saveFolderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:mp4path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        [fileManager createDirectoryAtPath:mp4path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    mp4path = [mp4path stringByAppendingPathComponent:lastComponent];
    mp4path = [mp4path stringByAppendingString:@".mp4"];
    NSLog(@"mp4path=%@", mp4path);
    
    NSError * error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:mp4path error:&error ];
    if (error){
        NSLog(@"cut失败：%@",[error localizedDescription]);
    }
    
    return mp4path;
    
}

+ (void)showTitle:(NSString *)title text:(NSString *)text {
    
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:nil]];
    [[InstagramTweakTool getRootVC] presentViewController:alertVC animated:YES completion:nil];
}


+ (UIViewController *)getRootVC {
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow* window = [delegate window];
    return window.rootViewController;
    
//    UIResponder* nextR;
//    nextR = [view nextResponder];
//    while (!nextR || ![nextR isKindOfClass:[UIViewController class]] )
//    {
//        nextR = [nextR nextResponder];
//        if (!nextR)
//        {
//            break;
//        }
//    }
//    
//    UIViewController* controller = (UIViewController *)nextR;
//    
//    return controller;
}
@end
