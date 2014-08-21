//
//  BBUFileUpload.h
//  Pods
//
//  Created by Boris Bügling on 21/08/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^BBUFileUploadHandler)(NSURL* uploadURL, NSError* error);

@protocol BBUFileUpload <NSObject>

-(void)uploadFileWithData:(NSData*)data completionHandler:(BBUFileUploadHandler)handler;
-(void)uploadImage:(UIImage*)image completionHandler:(BBUFileUploadHandler)handler;

@end
