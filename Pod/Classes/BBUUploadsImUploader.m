//
//  BBUUploadsImUploader.m
//  Pods
//
//  Created by Boris Bügling on 21/08/14.
//
//

#import <AFNetworking/AFNetworking.h>

#import "BBUUploadsImUploader.h"
#import "Utilities.h"

@interface BBUUploadsImUploader ()

@property (nonatomic) AFHTTPRequestOperationManager* manager;

@end

#pragma mark -

@implementation BBUUploadsImUploader

+(instancetype)sharedUploader {
    static dispatch_once_t once;
    static BBUUploadsImUploader *sharedUploader;
    dispatch_once(&once, ^ {
        sharedUploader = [BBUUploadsImUploader new];
    });
    return sharedUploader;
}

#pragma mark -

-(id)init {
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"http://uploads.im"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void)uploadFileWithData:(NSData *)data
        completionHandler:(BBUFileUploadHandler)handler
          progressHandler:(BBUProgressHandler)progressHandler {
    NSParameterAssert(data);
    NSParameterAssert(handler);

    NSString* URLString = [self.manager.baseURL URLByAppendingPathComponent:@"api"].absoluteString;

    NSError* error;
    NSURLRequest* request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"upload"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
    } error:&error];

    AFHTTPRequestOperation* operation = [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL* uploadUrl = [NSURL URLWithString:responseObject[@"data"][@"img_url"]];
        handler(uploadUrl, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];

    if (progressHandler) {
        [operation setUploadProgressBlock:progressHandler];
    }

    [self.manager.operationQueue addOperation:operation];
}

#if TARGET_OS_IPHONE
-(void)uploadImage:(UIImage *)image
#else
-(void)uploadImage:(NSImage *)image
#endif
 completionHandler:(BBUFileUploadHandler)handler
   progressHandler:(BBUProgressHandler)progressHandler {
    NSData *data = bbu_convert_image_to_data(image);
    [self uploadFileWithData:data completionHandler:handler progressHandler:progressHandler];
}

@end
