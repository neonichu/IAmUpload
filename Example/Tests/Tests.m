//
//  IAmUploadTests.m
//  IAmUploadTests
//
//  Created by Boris Bügling on 08/21/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <IAmUpload/BBUUploadsImUploader.h>

SpecBegin(IAmUploadSpecs)

describe(@"BBUUploadsImUploader", ^{
    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:30.0];
        setAsyncSpecTimeout(30.0);
    });

    it(@"can upload an image", ^AsyncBlock {
        [[BBUUploadsImUploader sharedUploader] uploadImage:[UIImage imageNamed:@"doge.jpeg"] completionHandler:^(NSURL *uploadURL, NSError *error) {
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
        }];
    });
});

SpecEnd
