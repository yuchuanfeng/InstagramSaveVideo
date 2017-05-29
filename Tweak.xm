/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

#import "Headers/InstagramHeader.h"
#import "Headers/InstagramTweakTool.h"
#import "Headers/YQAssetOperator.h"

// %hook IGDiskCache
// - (id)cachePathForKey:(id)arg1 {
// 	id result = %orig;
// 	NSLog(@"cachePathForKey==name:%@=key:%@\n path:%@", [self name], arg1, result);
// 	return result;
// }

// - (NSData *)dataForKey:(id)arg1 {
// 	NSData* result = %orig;
// 	NSLog(@"dataForKey==name:%@=key:%@\n dataSize:%lu", [self name], arg1, [result length]);
// 	return result;
// }
// %end


%hook IGFeedItemMediaCell
- (instancetype)initWithFrame:(CGRect)frame {
	self = %orig;
	UILongPressGestureRecognizer* longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [self addGestureRecognizer:longPressG];
	return self;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(saveMedia)) {
        return YES;
    }
    if (action == @selector(saveMediaUrl)) {
        return YES;
    }
    return NO;//隐藏系统默认的菜单项
}

%new
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longPress {
	if (longPress.state == UIGestureRecognizerStateBegan)
    {
	    [self becomeFirstResponder];
	    UIMenuController* menuVC = [UIMenuController sharedMenuController];
	    [menuVC setTargetRect:[self bounds] inView:(UIView*)self];
	    UIMenuItem* saveVideoItem = [[UIMenuItem alloc] initWithTitle:@"save" action:@selector(saveMedia)];
	    UIMenuItem* saveVideoUrlItem = [[UIMenuItem alloc] initWithTitle:@"copyUrl" action:@selector(saveMediaUrl)];
	    
	    menuVC.menuItems = @[saveVideoItem, saveVideoUrlItem];
	    
	    [menuVC setMenuVisible:YES animated:YES];
    }
    
}

%new
- (void)saveMedia {
	NSLog(@"saveVideo=====");
	IGFeedItem* item = objc_msgSend(self,@selector(post));
	if(item.mediaType == 1){
		IGFeedPhotoView* photoView = [self photoView];
		IGImageProgressView* photoImageView = [photoView photoImageView];
		UIImageView* imageView = [photoImageView photoImageView];
		UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}else if(item.mediaType == 2){
		IGVideo* video = [item video];
		NSArray* videoVersions = [video videoVersions];
		IGStreamingVideoCache* videoCache = [%c(IGStreamingVideoCache) sharedCache];
		IGDiskCache* diskCache = [videoCache valueForKeyPath:@"_diskCache"];
		for(NSDictionary* urlDict in videoVersions) {
			NSString* urlStr = [urlDict objectForKey:@"url"];
			NSString* key = [InstagramTweakTool videoKeyForUrlStr:urlStr];
			BOOL result = [diskCache containsDataForKey:key];
			if(result){
				NSString* videoDataPath = [diskCache cachePathForKey:key];

				NSString* filePath = [InstagramTweakTool mp4filePathWithDataPath:videoDataPath];
			    	
				YQAssetOperator* _assetOperator = [[YQAssetOperator alloc] initWithFolderName:@"InstagramVideo"];
				[_assetOperator saveVideoPath:filePath];				    	
				    
			    NSLog(@"fromePath%@\ntoPath:%@", videoDataPath, filePath);

			    
				break;
			}
		}
	}
}

%new
- (void)saveMediaUrl {
	NSLog(@"saveMediaUrl=====");
	
	NSString* urlStr = [self mediaUrlStr];
    UIPasteboard* pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = urlStr;
    
    [InstagramTweakTool showTitle:@"Copy url success !" text:urlStr];
}

%new
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	if(!error) {
		[InstagramTweakTool showTitle:@"Save image success" text:nil];
	}else {
		[InstagramTweakTool showTitle:@"Save image error !" text:error.description];
	}
}


%new
- (NSString *)mediaUrlStr {
 	IGFeedItem* item = objc_msgSend(self,@selector(post));
	NSString* urlStr = nil;
	if(item.mediaType == 1){
		IGPhoto* photo = [item photo];
		NSArray* imageVersions = [photo imageVersions];
		IGTypedURL* url = [imageVersions lastObject];
		urlStr = [(NSURL*)[url url] absoluteString];
	}else if(item.mediaType == 2){
		IGVideo* video = [item video];
		NSArray* videoVersions = [video videoVersions];
		NSDictionary* urlDict = [videoVersions firstObject];
		urlStr = [urlDict objectForKey:@"url"];
	}

	return urlStr;
 }



%end

