//
//  CustomReceiptVerificatior.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-17.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "CustomReceiptVerificatior.h"
#import "ASIFormDataRequest.h"



static NSString *RMErroDomainStoreLocalReceiptVerificator = @"RMStoreLocalReceiptVerificator";

@interface NSData(rm_base64)

- (NSString *)rm_stringByBase64Encoding;

@end

@implementation NSData(rm_base64)

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//static const short _base64DecodingTable[256] = {
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
//    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
//    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
//    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
//    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
//    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
//    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
//};


- (NSString *)rm_stringByBase64Encoding
{ // From: http://stackoverflow.com/a/4727124/143378
    const unsigned char * objRawData = [self bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    NSInteger intLength = [self length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
}

@end

@implementation CustomReceiptVerificatior

- (void)verifyReceiptOfTransaction:(SKPaymentTransaction*)transaction
                           success:(void (^)())successBlock
                           failure:(void (^)(NSError *error))failureBlock
{
    NSString *receipt = [transaction.transactionReceipt rm_stringByBase64Encoding];
    
    if (receipt == nil)
    {
        if (failureBlock != nil)
        {
            NSError *error = [NSError errorWithDomain:RMErroDomainStoreLocalReceiptVerificator code:0 userInfo:nil];
            failureBlock(error);
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://currency.51wnl.com/APIS/VerificationApplePurchase"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:receipt forKey:@"receiptData"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [request startSynchronous];
        NSString *statusCode = request.responseString;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([statusCode isEqualToString:@"0"])
            {
                if (successBlock != nil)
                {
                    successBlock();
                }
            }
            else
            {
                DLog(@"Verification Failed With Code %@", statusCode);
                NSError *serverError = [NSError errorWithDomain:RMErroDomainStoreLocalReceiptVerificator code:statusCode userInfo:nil];
                if (failureBlock != nil)
                {
                    failureBlock(serverError);
                }
            }
        });
    });

}

@end
