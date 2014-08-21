//
//  BBUFileUpload.h
//  Pods
//
//  Created by Boris Bügling on 21/08/14.
//
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

typedef void(^BBUFileUploadHandler)(NSURL* uploadURL, NSError* error);

@protocol BBUFileUpload <NSObject>

-(void)uploadFileWithData:(NSData*)data completionHandler:(BBUFileUploadHandler)handler;

#if TARGET_OS_IPHONE
-(void)uploadImage:(UIImage*)image completionHandler:(BBUFileUploadHandler)handler;
#else
-(void)uploadImage:(NSImage*)image completionHandler:(BBUFileUploadHandler)handler;
#endif

@end
