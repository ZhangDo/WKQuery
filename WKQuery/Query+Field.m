//
//  Query+Field.m
//  BDTLogistics
//
//  Created by walker on 2018/11/9.
//  Copyright © 2018 walker.zhang. All rights reserved.
//

#import "Query+Field.h"
#import "objc/Runtime.h"
@implementation Query (Field)
static char *colIDKey        = "colIDKey";
static char *linkKey         = "linkKey";
static char *nameKey         = "nameKey";
static char *sortingDKey     = "sortingKey";
static char *exprKey         = "exprKey";
static char *objValKey       = "objValKey";
static char *partKey         = "partKey";
static char *filterDicKey    = "filterDicKey";
- (NSString *)colID {
    return objc_getAssociatedObject(self, colIDKey);
}
- (void)setColID:(NSString *)colID {
    objc_setAssociatedObject(self, colIDKey, colID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (NSString *)link {
    return objc_getAssociatedObject(self, linkKey);
}

- (void)setLink:(NSString *)link {
    objc_setAssociatedObject(self, linkKey, link, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}
- (NSString *)name {
    return objc_getAssociatedObject(self, nameKey);
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, nameKey, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (NSString *)sorting {
    return objc_getAssociatedObject(self, sortingDKey);
}

- (void)setSorting:(NSString *)sorting {
    objc_setAssociatedObject(self, sortingDKey, sorting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (NSString *)expr {
    return objc_getAssociatedObject(self, exprKey);
}

- (void)setExpr:(NSString *)expr {
    objc_setAssociatedObject(self, exprKey, expr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (id)objVal {
    return objc_getAssociatedObject(self, objValKey);
}

- (void)setObjVal:(id)objVal {
    objc_setAssociatedObject(self, objValKey, objVal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (BOOL)part {
    return [objc_getAssociatedObject(self, partKey) boolValue];
}

- (void)setPart:(BOOL)part {
    objc_setAssociatedObject(self, partKey, @(part), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setFilter];
}

- (NSMutableDictionary *)filterDic {
    return objc_getAssociatedObject(self, filterDicKey);
}

- (void)setFilterDic:(NSMutableDictionary *)filterDic {
    objc_setAssociatedObject(self, filterDicKey, filterDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFilter {

    self.filterDic = [@{@"colID":@([self.colID integerValue])?:@(0),
                        @"expr":self.expr?:@"",
                        @"link":self.link?:@"",
                        @"name":self.name?:@"",
                        @"objVal":self.objVal?:@(0),
                        @"part":@(self.part),
                        @"sorting":self.sorting?:@(0),
                        } mutableCopy];
}

- (Query * (^)(id objVal, BOOL flag))equal {
    WK_weak_Self;
    return ^Query*(id objVal, BOOL flag) {
        WK_strong_Self;
        strongSelf.expr = flag ? @"=" : @"!=";
        if ([objVal isKindOfClass:[NSDictionary class]]) {
            strongSelf.objVal = objVal;
        } else if([objVal isKindOfClass:[NSString class]]) {
            if ([objVal isEqualToString:@"0"]) {
                strongSelf.objVal = @(0);
            } else {
                strongSelf.objVal = objVal;
            }
        } else {
            strongSelf.objVal = objVal;
        }
        
       [strongSelf fixData];
        return self;
    };
}

- (Query * (^)(id objVal, NSInteger flag))like {
    WK_weak_Self;
    return ^Query*(id objVal, NSInteger flag) {
        WK_strong_Self;
        if (flag < 0) {
            strongSelf.expr = @"$LIKE%";
        } else if (flag == 0) {
            strongSelf.expr = @"$LIKE";
        } else {
            strongSelf.expr = @"$%LIKE";
        }
        
        if ([objVal isKindOfClass:[NSDictionary class]]) {
            strongSelf.objVal = objVal;
        } else if([objVal isKindOfClass:[NSString class]]) {
            if ([objVal isEqualToString:@"0"]) {
                strongSelf.objVal = @(0);
            } else {
                strongSelf.objVal = objVal;
            }
        } else {
            strongSelf.objVal = objVal;
        }
       [strongSelf fixData];
        return self;
    };
}

/***设置查询条件**/
- (Query * (^)(NSInteger sort))sort {
    WK_weak_Self;
    return ^Query*(NSInteger sort) {
        WK_strong_Self;
        strongSelf.sorting = @(sort);
        [strongSelf setFilter];
        [strongSelf.filterDic removeObjectsForKeys:@[@"expr",@"objVal"]];
        [strongSelf.filter addObject:self.filterDic];
        [strongSelf.queryDic setObject:self.filter forKey:@"filters"];
        return self;
    };
}

- (Query * (^)(void))isNull {
    WK_weak_Self;
    return ^Query*() {
        WK_strong_Self;
        strongSelf.expr     = @"IS";
        strongSelf.objVal   = @" NULL";
        [strongSelf fixData];
        return self;
    };
}

- (Query * (^)(void))isNotNull {
    WK_weak_Self;
    return ^Query*() {
        WK_strong_Self;
        strongSelf.expr    = @"IS";
        strongSelf.objVal  = @"NOT NULL";
        [strongSelf fixData];
        return self;
    };
}
- (Query * (^)(NSString *value))lgt {
    WK_weak_Self;
    return ^Query*(NSString *value) {
        WK_strong_Self;
        strongSelf.expr   = @">=";
        strongSelf.objVal = value;
        [strongSelf fixData];
        return self;
    };
}
- (Query * (^)(NSString *value))rgt {
    WK_weak_Self;
    return ^Query*(NSString *value) {
        WK_strong_Self;
        strongSelf.expr   = @"<=";
        strongSelf.objVal = value;
        [strongSelf fixData];
        return self;
    };
}

- (Query * (^)(NSInteger value))w_in {
    WK_weak_Self;
    return ^Query*(NSInteger value) {
        WK_strong_Self;
        strongSelf.expr   = @"IN";
        strongSelf.objVal = @(value);
        [strongSelf fixData];
        return self;
    };
}

- (Query * (^)(id objVal))setValue {
    WK_weak_Self;
    return ^Query*(id objVal) {
        WK_strong_Self;
        strongSelf.objVal = objVal;
        [strongSelf fixData];
        return self;
    };
}
#pragma mark ---
- (void)fixData {
    [self setFilter];
    [self.filter addObject:self.filterDic];
    [self.queryDic setObject:self.filter forKey:@"filters"];
}


@end
