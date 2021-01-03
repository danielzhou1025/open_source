//
//  NSData+Utils.m
//  objc_utils
//
//  Created by daniel on 2021/1/3.
//

#import "NSData+Utils.h"

@implementation NSData (Utils)

+ (NSData *)setNot:(NSData *)str {
    
    NSUInteger len = [str length];
    
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [str bytes], len);
    
    uint8_t *bytes = malloc(sizeof(*bytes) * len);
    
    unsigned i;
    for (i = 0; i < len; i++)
    {
        bytes[i] = ~byteData[i];
    }
    
    NSData *notData = [NSData dataWithBytes:bytes length:len];
    
    free(bytes);
    free(byteData);
    
    return notData;
}

+ (NSString *)hexString:(NSData *)str{
    const unsigned char *dataBuffer = (const unsigned char *)[str bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength = [str length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int indicator = 0; indicator < dataLength; indicator++) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx",(unsigned long)dataBuffer[indicator]]];
    }
    return [NSString stringWithString:hexString];
}


+ (NSData *)reverseData:(NSData *)str {
    const char *bytes = [str bytes];
    int idx = (int)[str length] - 1;
    char *reversedBytes = calloc(sizeof(char),[str length]);
    for (int i = 0; i < [str length]; i++) {
        reversedBytes[idx--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:[str length]];
    free(reversedBytes);
    return reversedData;
}


+ (NSString *)convertToString:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = [[NSString alloc] initWithData:[self utf8Data:data] encoding:NSUTF8StringEncoding];
    }
    string = [string stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"�" withString:@""];
    return string;
}

/*
 解决NSData转化成string，返回nil的问题
 http://sozhidao.com/articles/405
 */
+ (NSData *)utf8Data:(NSData *)data {
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:data.length];
    
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = data.bytes;
    
    long dataLength = (long) data.length;
    
    while (index < dataLength) {
        uint8_t len = 0;
        uint8_t firstChar = bytes[index];
        
        // 1st Byte
        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
            len = 1;
        }
        // 2nd Byte
        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
            if (index + 1 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                if (0x80 <= secondChar && secondChar <= 0xBF) {
                    len = 2;
                }
            }
        }
        // 3rd Byte
        else if ((firstChar & 0xF0) == 0xE0) {
            if (index + 2 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                
                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                }
            }
        }
        // 4th Byte
        else if ((firstChar & 0xF8) == 0xF0) {
            if (index + 3 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                uint8_t fourthChar = bytes[index + 3];
                
                if (firstChar == 0xF0) {
                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if (firstChar == 0xF3) {
                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                }
            }
        }
        // 5th Byte
        else if ((firstChar & 0xFC) == 0xF8) {
            len = 0;
        }
        // 6th Byte
        else if ((firstChar & 0xFE) == 0xFC) {
            len = 0;
        }
        
        if (len == 0) {
            index++;
            [resData appendData:replacement];
        } else {
            [resData appendBytes:bytes + index length:len];
            index += len;
        }
    }
    
    return resData;
}


@end
