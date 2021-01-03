//
//  NSString+Utils.h
//  objc_utils
//
//  Created by daniel on 2021/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)

+ (BOOL)isNullOrEmpty:(NSString *)str;

+ (NSData *)stringToData:(NSString *)str;

+ (NSData *)hexToBinary:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
