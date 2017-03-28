# PageRequest

A page request quick request list data

## usage

#### quick request

```
[[PageRequest pageRequestWithIdentifier:NSStringFromClass([self class]) startPage:0 perPage:10    requestBlock:^(NSInteger pageNo, NSInteger perPage, CompleteBlock  _Nonnull completeBlock) {
            //列表请求方法
    } completeBlock:^(BOOL success, NSString * _Nonnull msg, NSArray * _Nonnull requestData) {
            //请求结果回调
 }] requestPage];

```

#### reset data
```
 [PageRequest resetPageWithIdentifier:NSStringFromClass([self class])];
    
```

#### load more data
```
 [PageRequest requestPageWithIdentifier:NSStringFromClass([self class])];

```

