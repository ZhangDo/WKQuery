//
//  Query.m
//  Query
//
//  Created by walker on 2018/10/26.
//  Copyright © 2018 walker. All rights reserved.
//

#import "Query.h"
#import "Query+Field.h"

@interface Query ()
@property (nonatomic, strong) NSMutableDictionary *setField;
@property (nonatomic, copy) NSString *modelID;

@end

@implementation Query
/// 单例
+ (instancetype)sharedCenter {
    static Query *query;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        query = [[self alloc] init];
    });
    return query;
}
- (Query * (^)(NSString * modelID, NSDictionary *userDic))create{
    WK_weak_Self;
    self.filter =  [@[] mutableCopy];
    return ^Query*(NSString *modelID,NSDictionary *userDic) {//user:object
        WK_strong_Self;
        strongSelf.modelID = modelID;
        strongSelf.queryDic = [userDic mutableCopy];
        [strongSelf.queryDic setObject:self.modelID forKey:@"modelID"];
        return self;
    };
}

- (Query * (^)(NSString * _Nonnull))group {
    WK_weak_Self;
    return ^Query*(NSString *name) {//user:object
        WK_strong_Self;
        self.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name forKey:@"name"];
        [strongSelf.setField setObject:@"0" forKey:@"colID"];
        [strongSelf.setField setObject:@"G" forKey:@"link"];
        [strongSelf.setField setObject:@false forKey:@"part"];
        [strongSelf.setField setObject:@"0" forKey:@"sorting"];
        [strongSelf.filter addObject:strongSelf.setField];
        [strongSelf.queryDic setObject:strongSelf.filter forKey:@"filters"];
        return self;
    };
}
- (Query * (^)(NSString *name, NSInteger sort))sort_group {
    WK_weak_Self;
    return ^Query*(NSString *name, NSInteger sort) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name forKey:@"name"];
        [strongSelf.setField setObject:@"0" forKey:@"colID"];
        [strongSelf.setField setObject:@"G" forKey:@"link"];
        [strongSelf.setField setObject:@false forKey:@"part"];
        [strongSelf.setField setObject:@(sort) forKey:@"sorting"];
        [strongSelf.filter addObject:strongSelf.setField];
        [strongSelf.queryDic setObject:strongSelf.filter forKey:@"filters"];
        return self;
    };
}

- (Query * (^)(NSInteger client))client {
    WK_weak_Self;
    return ^Query*(NSInteger client) {
        WK_strong_Self;
        [strongSelf.queryDic setObject:@(client) forKey:@"client"];
        return self;
    };
}

- (Query * (^)(NSInteger length))length {
    WK_weak_Self;
    return ^Query*(NSInteger length) {
        WK_strong_Self;
        [strongSelf.queryDic setObject:@(length) forKey:@"length"];
        return self;
    };
}



- (Query * (^)(NSString * _Nonnull , NSInteger sort))group1 {
//    WK_weak_Self;
    return ^Query*(NSString *name, NSInteger sort) {//user:object
//        WK_strong_Self;
        return self;
    };
}

- (Query * (^)(NSString * name))where {
   WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        if (strongSelf.filter.count != 0) {
            @throw [NSException exceptionWithName:@"WHERE" reason:@"Where 仅能调用一次" userInfo:nil];
        }
        [strongSelf addFieldWithName:name link:@""];
        return self;
    };
}

- (Query * (^)(NSString * name))w_and {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        if (strongSelf.filter.count == 0) {
            @throw [NSException exceptionWithName:@"AND" reason:@"必须先设置Where" userInfo:nil];
        }
        [strongSelf addFieldWithName:name link:@"AND"];
        return self;
    };
}
- (Query * (^)(NSString * name))del {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        if (strongSelf.filter.count == 0) {
            @throw [NSException exceptionWithName:@"del" reason:@"必须先设置Where" userInfo:nil];
        }
        [strongSelf addFieldWithName:name link:@"$del"];
        return self;
    };
}

- (Query * (^)(NSString * name))w_or {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        if (strongSelf.filter.count == 0) {
            @throw [NSException exceptionWithName:@"or" reason:@"必须先设置Where" userInfo:nil];
        }
        [strongSelf addFieldWithName:name link:@"OR"];
        return self;
    };
}

- (Query * (^)(NSString *name,NSString *link))addField {
    WK_weak_Self;
    return ^Query*(NSString *name,NSString *link) {
        WK_strong_Self;
        strongSelf.name = name;
        strongSelf.link = link;
        return self;
    };
}


- (Query * (^)(void))count {
    WK_weak_Self;
    return ^Query*(void) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:@"$COUNT" forKey:@"name"];
        [strongSelf.setField setObject:@"$COUNT" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
    
}
- (Query * (^)(NSString *name))avg {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$AVG" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
}

- (Query * (^)(NSString *name))sum {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$SUM" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
}

- (Query * (^)(NSString *name))max {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$MAX" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
}

- (Query * (^)(NSString *name))min {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$MIN" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
}
- (Query * (^)(NSString *name))countDistinct {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$COUNT DISTINCT" forKey:@"link"];
        [strongSelf mixData];
        return self;
    };
}
#pragma mark ----- 更新
- (Query * (^)(NSString * name))upsert {
    WK_weak_Self;
    return ^Query*(NSString *name) {
        WK_strong_Self;
        if (strongSelf.filter.count == 0) {
            @throw [NSException exceptionWithName:@"upsert" reason:@"必须先设置Where" userInfo:nil];
        }
        [strongSelf addFieldWithName:name link:@"$upsert"];
        return self;
    };
}
#pragma mark ----- 插入
- (Query * (^)(NSString * name, id data))insert {
    WK_weak_Self;
    return ^Query*(NSString *name, id data) {
        WK_strong_Self;
        strongSelf.setField = [@{} mutableCopy];
        [strongSelf.setField setObject:name?:@"" forKey:@"name"];
        [strongSelf.setField setObject:@"$insert" forKey:@"link"];
        [strongSelf.setField setObject:data forKey:@"objVal"];
        [strongSelf mixData];
        return self;
    };
}

- (void)mixData {
    [self.setField setObject:@"0" forKey:@"colID"];
    [self.setField setObject:@false forKey:@"part"];
    [self.setField setObject:@"0" forKey:@"sorting"];
    [self.filter addObject:self.setField];
    [self.queryDic setObject:self.filter forKey:@"filters"];
}

- (void)addFieldWithName:(NSString *)name link:(NSString *)link {
    self.name = name;
    self.link = link;
}

@end
