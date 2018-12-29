//
//  Query+Field.h
//  BDTLogistics
//
//  Created by walker on 2018/11/9.
//  Copyright © 2018 walker.zhang. All rights reserved.
//

#import "Query.h"

NS_ASSUME_NONNULL_BEGIN

@interface Query (Field)
/**
 * 列ID
 */
@property (nonatomic,copy) NSString *colID;
/**
 * 连接符等，聚合运算时，标识聚合运算符
 */
@property (nonatomic,copy) NSString *link;
/**
 * 列别名
 */
@property (nonatomic,copy) NSString *name;
/**
 * 排序方式
 */
@property (nonatomic,copy) NSString *sorting;
/**
 * 表达式
 */
@property (nonatomic,copy) NSString *expr;
/**
 * 表达式匹配的值，根据不同的表达式传入不同的数据类型
 */
@property (nonatomic) id objVal;
@property (nonatomic,assign) BOOL part;


//@property (nonatomic, assign)

@property (nonatomic, strong) NSMutableDictionary *filterDic;
/**等于或不等于表达式
 *  obj
 * flag true标识等于 false标识不等于
 *
 */
- (Query * (^)(id objVal, BOOL flag))equal;
/**
 * obj
 * flag -1 前匹配，0全匹配，1后匹配
 *
 */
- (Query * (^)(id objVal, NSInteger flag))like;

/**
 <#Description#>
 */
- (Query * (^)(void))isNull;

/**
 <#Description#>
 */
- (Query * (^)(void))isNotNull;

/**
 <#Description#>
 */
- (Query * (^)(NSString *value))lgt;

/**
 <#Description#>
 */
- (Query * (^)(NSString *value))rgt;

/**
 <#Description#>
 */
- (Query * (^)(NSInteger value))w_in;


/**
 修改赋值
 */
- (Query * (^)(id objVal))setValue;


@end

NS_ASSUME_NONNULL_END
