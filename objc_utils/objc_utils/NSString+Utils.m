//
//  NSString+Utils.m
//  objc_utils
//
//  Created by daniel on 2021/1/3.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (BOOL)isNullOrEmpty:(NSString *)str {
    return ((str == nil)
            ||(str == (id)[NSNull null])
            ||([@"" isEqualToString:str])
            ||([[str stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
            ||([str isEqualToString:@"(null)"])
            ||([str respondsToSelector:@selector(length)] && [(NSData *) str length] == 0)
            ||([str respondsToSelector:@selector(count)] && [(NSArray *) str count] == 0)
            ||([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
            );
}

+ (NSData *)stringToData:(NSString *)str {
    const char *chars = [str UTF8String];
    NSUInteger i = 0;
    NSUInteger len = str.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:(len/2)];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+ (NSString *)hexToBinary:(NSString *)str {
    NSMutableString *retnString = [NSMutableString string];
    
    for (int i = 0; i < [str length]; i++) {
        char c = [[str lowercaseString] characterAtIndex:i];
        
        switch (c) {
            case '0': [retnString appendString:@"0000"]; break;
            case '1': [retnString appendString:@"0001"]; break;
            case '2': [retnString appendString:@"0010"]; break;
            case '3': [retnString appendString:@"0011"]; break;
            case '4': [retnString appendString:@"0100"]; break;
            case '5': [retnString appendString:@"0101"]; break;
            case '6': [retnString appendString:@"0110"]; break;
            case '7': [retnString appendString:@"0111"]; break;
            case '8': [retnString appendString:@"1000"]; break;
            case '9': [retnString appendString:@"1001"]; break;
            case 'a': [retnString appendString:@"1010"]; break;
            case 'b': [retnString appendString:@"1011"]; break;
            case 'c': [retnString appendString:@"1100"]; break;
            case 'd': [retnString appendString:@"1101"]; break;
            case 'e': [retnString appendString:@"1110"]; break;
            case 'f': [retnString appendString:@"1111"]; break;
            default:
                break;
        }
    }
    return retnString;
}

@end
