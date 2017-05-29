//
//  InstagramTweakTool.h
//  78-huibian
//
//  Created by 于传峰 on 2017/5/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramTweakTool : NSObject
+ (NSString *)mp4filePathWithDataPath:(NSString *)dataPath;
+ (NSString *)md5:(NSString *) input;
+ (NSString *)videoKeyForUrlStr:(NSString *)url;
+ (void)showTitle:(NSString *)title text:(NSString *)text;
@end
