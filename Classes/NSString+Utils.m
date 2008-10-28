//
//  NSString+Utils.m
//  Dough
//
//  Created by Ryan Joseph on 10/22/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "NSString+Utils.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSStringPlusRyansUtils)
- (NSString*) SHA1AsHex;
{		
	NSString* retVal = nil;
	
	unsigned char* sha1out = (unsigned char*)malloc(CC_SHA1_DIGEST_LENGTH);
	if (sha1out)
	{
		sha1out = CC_SHA1((const void*)[self cStringUsingEncoding:NSASCIIStringEncoding],
						  (CC_LONG)[self lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
						  sha1out);
		
		NSMutableString* shaAsHex = [NSMutableString string];
		uint8_t count = 0;
		for (; count < CC_SHA1_DIGEST_LENGTH; sha1out++, count++)
		{
			[shaAsHex appendFormat:@"%02x", *sha1out];
		}
		
		retVal = (NSString*)shaAsHex;
	}
	
	return retVal;
}


//borrowed from http://mesh.typepad.com/blog/2007/10/url-encoding-wi.html
//simple API that encodes reserved characters according to:
//RFC 3986
//http://tools.ietf.org/html/rfc3986
- (NSString *) URLEncode;
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [self mutableCopy];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *out = [NSString stringWithString: temp];
	
    return out;
}
@end
