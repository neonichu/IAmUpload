//
//  IAmUploadTests.m
//  IAmUploadTests
//
//  Created by Boris Bügling on 08/21/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <IAmUpload/BBUPostImageUploader.h>
#import <IAmUpload/BBUS3Uploader.h>
#import <IAmUpload/BBUUploadsImUploader.h>

void _itTestForImageUpload(id self, id<BBUFileUpload> uploader) {
    dispatch_async(dispatch_get_main_queue(), ^{
        expect(uploader).toNot.beNil();
    });

    if (!uploader) {
        return;
    }

    it(@"can upload an image", ^AsyncBlock {
        [uploader uploadImage:[UIImage imageNamed:@"doge.jpeg"] completionHandler:^(NSURL *uploadURL,
                                                                                    NSError *error) {
            expect(uploadURL).toNot.beNil();
            expect(error).to.beNil();

            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:uploadURL]
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data, NSError *connectionError) {
                                       expect(data).toNot.beNil();
                                       expect(connectionError).to.beNil();
                                       expect([UIImage imageWithData:data]).toNot.beNil();

                                       done();
                                   }];
        } progressHandler:nil];
    });
}

SpecBegin(IAmUploadSpecs)

describe(@"BBUPostImageUploader", ^{
    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:30.0];
        setAsyncSpecTimeout(30.0);
    });

    _itTestForImageUpload(self, [BBUPostImageUploader sharedUploader]);
});

describe(@"BBUS3Uploader", ^{
    it(@"determines the correct mime type for JPEGs", ^{
        NSString* fileType = [BBUS3Uploader mimeTypeForFileExtension:@"jpg"];
        expect(fileType).equal(@"image/jpeg");
    });

    it(@"determines the correct mime type for PDFs", ^{
        NSString* fileType = [BBUS3Uploader mimeTypeForFileExtension:@"pdf"];
        expect(fileType).equal(@"application/pdf");
    });

    it(@"determines the correct mime type for DOCX", ^{
        NSString* fileType = [BBUS3Uploader mimeTypeForFileExtension:@"docx"];
        expect(fileType).equal(@"application/vnd.openxmlformats-officedocument.wordprocessingml.document");
    });
});

describe(@"BBUUploadsImUploader", ^{
    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:30.0];
        setAsyncSpecTimeout(30.0);
    });

    _itTestForImageUpload(self, [BBUUploadsImUploader sharedUploader]);
});

SpecEnd
