//
//  BBUS3Uploader.m
//  image-uploader
//
//  Created by Boris Bügling on 03/09/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#import "BBUS3Uploader.h"
#import "Utilities.h"

@interface BBUS3Uploader ()

@property (nonatomic) NSURL* baseURL;

@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* key;
@property (nonatomic, copy) NSString* secret;

@end

#pragma mark -

@implementation BBUS3Uploader

+(NSString *)computeHMACWithString:(NSString *)data secret:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [HMAC base64EncodedStringWithOptions:0];
}

+(NSString*)mimeTypeForFileExtension:(NSString*)fileExtension {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);

    if (!mimeType) {
        return @"application/octet-stream";
    }

    return CFBridgingRelease(mimeType);
}

+(NSString*)rfc2822date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark -

-(instancetype)initWithBucket:(NSString*)bucket key:(NSString*)key secret:(NSString*)secret {
    self = [super init];
    if (self) {
        self.bucket = bucket;
        self.key = key;
        self.secret = secret;

        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.s3.amazonaws.com",
                                             self.bucket]];
    }
    return self;
}

-(void)uploadFileWithData:(NSData *)data
            fileExtension:(NSString*)fileExtension
        completionHandler:(BBUFileUploadHandler)handler
          progressHandler:(BBUProgressHandler)progressHandler {
    [self uploadFileWithData:data filename:nil fileExtension:fileExtension completionHandler:handler progressHandler:progressHandler];
}

-(void)uploadFileWithData:(NSData *)data
                 filename:(NSString *)fileName
            fileExtension:(NSString*)fileExtension
        completionHandler:(BBUFileUploadHandler)handler
          progressHandler:(BBUProgressHandler)progressHandler {
    NSParameterAssert(data);
    NSParameterAssert(handler);

    NSString* contentType = [[self class] mimeTypeForFileExtension:fileExtension];

    if (!fileName) {
        fileName = [[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:fileExtension];
    }
    else if (fileExtension) {
        fileName = [fileName stringByAppendingPathExtension:fileExtension];
    }

    if (self.path) {
        fileName = [self.path stringByAppendingPathComponent:fileName];
    }

    NSURL* fileURL = [self.baseURL URLByAppendingPathComponent:fileName];
    NSString* resourceName = [NSString stringWithFormat:@"/%@/%@", self.bucket, fileName];
    NSString* dateString = [[self class] rfc2822date];
    NSString* stringToSign = [NSString stringWithFormat:@"PUT\n\n%@\n%@\nx-amz-acl:public-read\n%@",
                              contentType, dateString, resourceName];
    NSString* signature = [[self class] computeHMACWithString:stringToSign secret:self.secret];
    NSString* authorization = [NSString stringWithFormat:@"AWS %@:%@", self.key, signature];

    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{ @"Host": self.baseURL.host,
                                                    @"Date": dateString,
                                                    @"Content-Type": contentType,
                                                    @"x-amz-acl": @"public-read",
                                                    @"Authorization": authorization };
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:fileURL];
    request.HTTPMethod = @"PUT";

    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *r, NSError *error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)r;

        if (response.statusCode >= 200 && response.statusCode < 300) {
            handler(fileURL, nil);
            return;
        }

        if (error) {
            handler(nil, error);
        } else {
            handler(nil, [NSError errorWithDomain:@"com.amazon.s3" code:response.statusCode userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"Expected HTTP status 200-299.", nil) }]);
        }
    }];

    [task resume];
}

-(void)uploadFileWithData:(NSData *)data
        completionHandler:(BBUFileUploadHandler)handler
          progressHandler:(BBUProgressHandler)progressHandler {
    [self uploadFileWithData:data
               fileExtension:@"jpg"
           completionHandler:handler
             progressHandler:progressHandler];
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
