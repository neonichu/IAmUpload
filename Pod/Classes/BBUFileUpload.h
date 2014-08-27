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
typedef void(^BBUProgressHandler)(NSUInteger bytesWritten,
                                  long long totalBytesWritten,
                                  long long totalBytesExpectedToWrite);

@protocol BBUFileUpload <NSObject>

-(void)uploadFileWithData:(NSData*)data
        completionHandler:(BBUFileUploadHandler)handler
          progressHandler:(BBUProgressHandler)progressHandler;

#if TARGET_OS_IPHONE
-(void)uploadImage:(UIImage*)image
#else
-(void)uploadImage:(NSImage*)image
#endif
 completionHandler:(BBUFileUploadHandler)handler
   progressHandler:(BBUProgressHandler)progressHandler;

@end
