//
//  Query.h
//  Query
//
//  Created by walker on 2018/10/26.
//  Copyright © 2018 walker. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define WK_weak_Self __weak typeof(self) weakSelf = self
#define WK_strong_Self __strong typeof((weakSelf)) strongSelf = (weakSelf)
#define QUERY [Query sharedCenter]
@interface Query : NSObject
@property (nonatomic, copy) NSString *user;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *filter;

@property (nonatomic, strong) NSMutableDictionary *queryDic;
+ (instancetype)sharedCenter;
/**创建一个查询组件
 * id    模型ID
 *
 */
- (Query * (^)(NSString * modelID, NSDictionary *userDic))create;

- (Query * (^)(NSString *name))group;
- (Query * (^)(NSString *name, NSInteger sort))sort_group;
- (Query * (^)(NSInteger client))client;
- (Query * (^)(NSString *name , NSInteger sort))group1;

/**第一个条件，没有链接符
 *  name
 *
 */
- (Query * (^)(NSString * name))where;

/**设置And链接条件，该方法之后必须设置表达（equal、lgt）式或者排序（sort）方法的调用
 * 列别名
 *
 *
 */
- (Query * (^)(NSString * name))w_and;
- (Query * (^)(NSString * name))del;
- (Query * (^)(NSString * name))w_or;
- (Query * (^)(void))count;
- (Query * (^)(NSString *name))avg;
- (Query * (^)(NSString *name))sum;
- (Query * (^)(NSString *name))max;
- (Query * (^)(NSString *name))min;
- (Query * (^)(NSString *name))countDistinct;
- (Query * (^)(NSMutableArray * array))IN;


- (Query * (^)(NSString * name))upsert;//更新
- (Query * (^)(NSString * name, id data))insert;//插入

/***设置查询条件**/
- (Query * (^)(NSInteger sort))sort;
- (Query * (^)(NSInteger length))length;


@end

NS_ASSUME_NONNULL_END
