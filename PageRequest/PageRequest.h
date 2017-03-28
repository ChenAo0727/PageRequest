//
//  PageRequest.h
//  PageRequest
//
//  Created by chenao on 17/3/28.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompleteBlock)(BOOL success,NSString *msg,NSArray *requestData);
typedef void (^RequestBlock)(NSInteger pageNo,NSInteger perPage,CompleteBlock completeBlock);

@interface PageRequest : NSObject

@property (nonatomic, assign,readonly) NSInteger page;

+ (instancetype)pageRequestWithIdentifier:(NSString *)identifier
                                startPage:(NSInteger)startPage
                                  perPage:(NSInteger)perPage
                             requestBlock:(RequestBlock)requestBlock
                            completeBlock:(CompleteBlock)completeBlock;

+ (BOOL)resetPageWithIdentifier:(NSString *)identifier;
+ (BOOL)requestPageWithIdentifier:(NSString *)identifier;

+ (NSMutableDictionary *)pageRequestCacheDic;
+ (BOOL)removeAllPageRequest;

- (BOOL)resetPage;
- (BOOL)requestPage;
@end

NS_ASSUME_NONNULL_END
