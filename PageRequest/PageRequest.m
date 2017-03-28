//
//  PageRequest.m
//  PageRequest
//
//  Created by chenao on 17/3/28.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "PageRequest.h"
#import <objc/runtime.h>
static dispatch_semaphore_t lock;
@interface PageRequest ()
@property (nonatomic, assign) NSInteger startPage;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger perPage;
@property (nonatomic, copy) RequestBlock requestBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
@end

@implementation PageRequest
+ (instancetype)pageRequestWithIdentifier:(NSString *)identifier
                                startPage:(NSInteger)startPage
                                  perPage:(NSInteger)perPage
                             requestBlock:(RequestBlock)requestBlock
                            completeBlock:(CompleteBlock)completeBlock {
    
    PageRequest *pageRequest = [PageRequest pageRequestWithIdentifier:identifier];
    
    if (!pageRequest) {
        pageRequest = [[PageRequest alloc]initPageRequestWithIdentifier:identifier startPage:startPage perPage:perPage requestBlock:requestBlock completeBlock:completeBlock];
        [[PageRequest pageRequestCacheDic] setObject:pageRequest forKey:identifier];
    }else {
        pageRequest.startPage = startPage;
        pageRequest.page = startPage;
        pageRequest.perPage = perPage;
        pageRequest.requestBlock = requestBlock;
        pageRequest.completeBlock = completeBlock;
    }
    
    return pageRequest;
}

+ (instancetype)pageRequestWithIdentifier:(NSString *)identifier {
    NSAssert(identifier, @"PageRequset identifier Can't be nil");
    PageRequest *pageRequest = [[PageRequest pageRequestCacheDic] objectForKey:identifier];
    return pageRequest;
}

+ (NSMutableDictionary *)pageRequestCacheDic {
    NSMutableDictionary *pageRequestDic = objc_getAssociatedObject(self, _cmd);
    if (!pageRequestDic) {
        pageRequestDic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, pageRequestDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pageRequestDic;
}

+ (BOOL)removeAllPageRequest {
    NSMutableDictionary *pageRequestCacheDic = [PageRequest pageRequestCacheDic];
    if (pageRequestCacheDic.count > 0) {
        [pageRequestCacheDic removeAllObjects];
        return YES;
    }
    return NO;
}

- (instancetype)initPageRequestWithIdentifier:(NSString *)identifier
                      startPage:(NSInteger)startPage
                        perPage:(NSInteger)perPage
                   requestBlock:(RequestBlock)requestBlock
                                completeBlock:(CompleteBlock)completeBlock {
    self = [super init];
    if (!self) {
        return nil;
    }
    lock = dispatch_semaphore_create(1);
    _startPage = startPage;
    _page = startPage;
    _perPage = perPage;
    _requestBlock = requestBlock;
    _completeBlock = completeBlock;
    return self;
}

+ (BOOL)requestPageWithIdentifier:(NSString *)identifier {
    PageRequest *pageRequset = [PageRequest pageRequestWithIdentifier:identifier];
    if (pageRequset) {
        [pageRequset requestPage];
        return YES;
    }
    return NO;
}

+ (BOOL)resetPageWithIdentifier:(NSString *)identifier {
    PageRequest *pageRequest = [PageRequest pageRequestWithIdentifier:identifier];
    if (pageRequest) {
        [pageRequest resetPage];
        return YES;
    }
    return NO;
}

- (BOOL)resetPage {
    _page = _startPage;
   return [self requestPage];
}

- (BOOL)requestPage {
    if (dispatch_semaphore_wait(lock, DISPATCH_TIME_NOW) != 0) {
        return NO;
    }
    _requestBlock(_page,_perPage,^(BOOL success,NSString *msg,NSArray *requestData){
        dispatch_semaphore_signal(lock);
        if (success) {
            _page ++;
        }
        _completeBlock ? _completeBlock(success,msg,requestData) : nil;
    
    });
    return YES;
}

@end
