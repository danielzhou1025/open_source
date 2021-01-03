//
//  NSData+Utils.h
//  objc_utils
//
//  Created by daniel on 2021/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Utils)

/**
 * SetNot of NSData+IB class
 *
 * This method create a NOT of the NSData
 *
 * @return a NSData
 *
 */
+ (NSData *)setNot:(NSData *)str;

/**
 * hexString of NSData+IB class
 *
 * This method create convert NSData to hexadecimal string
 *
 * @return a NSString
 *
 */
+ (NSString *)hexString:(NSData *)str;

/**
 * reverseData of NSData+IB class
 *
 * This method reverse the bytes inside the NSData.
 *
 * @return a NSString
 *
 */
+ (NSData *)reverseData:(NSData *)str;


/**
 * convertDataToString of NSData+IB class
 *
 * This method convert the bytes inside the NSData.
 *
 * @return a NSString
 *
 */
+ (NSString *)convertToString:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
