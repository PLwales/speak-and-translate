//
//  TranslateModel.m
//  Translate
//
//  Created by sihan on 2018/10/31.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "TranslateModel.h"
#import "TranslateDB.h"
#import "ExampleModel.h"

@implementation TranslateModel
- (BOOL)_addToDB {
    TranslateDB * translateDB = [TranslateDB new];
    return [translateDB _addTranslateInfo:self];
}
- (BOOL)_updateToDB {
    TranslateDB * translateDB = [TranslateDB new];
    return [translateDB _updateStatusWithTranslate:self];
}
- (BOOL)_delTranslateWithUUID {
    TranslateDB * translateDB = [TranslateDB new];
    return [translateDB _delTranslateWithUUID:self.UUID];
}
- (TranslateModel *)_getTranslateWithSelf {
    TranslateDB * translateDB = [TranslateDB new];
    TranslateModel * translateModelNew = [translateDB _getTrnaslateWithModel:self];
    if (translateModelNew.UUID) {
        return translateModelNew;
    }
    return nil;
}
- (NSMutableArray *)_getTranslateExample {
    NSMutableArray * arrayNew = [NSMutableArray new];
    if (self.typeTranslateClass == TypeTranslateClassBingDictionary) {
        NSArray * arraySym = self.dictionaryBaseInfo[@"sams"];
        if (arraySym) {
            for (int i = 0; i<arraySym.count; i++) {
                NSDictionary * dicPart = arraySym[i];
                if (dicPart && dicPart.count) {
                    ExampleModel * model = [ExampleModel new];
                    model.translateEN = dicPart[@"eng"];
                    model.translateCN = dicPart[@"chn"];
                    model.playerURL = dicPart[@"mp3Url"];
                    [arrayNew addObject:model];
                }
            }
        }
    } else if (self.typeTranslateClass == TypeTranslateClassJinShanDictionary) {
        NSArray * arraySym = self.arrayExample;
        if (arraySym) {
            for (int i = 0; i<arraySym.count; i++) {
                NSDictionary * dicPart = arraySym[i];
                if (dicPart && dicPart.count) {
                    ExampleModel * model = [ExampleModel new];
                    model.translateEN = dicPart[@"Network_en"];
                    model.translateCN = dicPart[@"Network_cn"];
                    model.playerURL = dicPart[@"tts_mp3"];
                    [arrayNew addObject:model];
                }
            }
        }
    }
    return arrayNew;
}
- (void)_setInfoWithDictionary:(NSDictionary *)dictionary {
    if (self.typeTranslateClass == TypeTranslateClassJinShanDictionary) {
        NSLog(@"%@",dictionary);
        self.dictionaryBaseInfo = dictionary[kStringJinShanBaseInfo];
        self.arrayExample = dictionary[kStringJinShanExample];
        self.detail = [self _getDetail];
        self.translate = [self _getTranslate];
    } else if (self.typeTranslateClass == TypeTranslateClassBingDictionary) {
        self.dictionaryBaseInfo = dictionary;
//        self.arrayExample = dictionary[@"examples"];
        self.detail = [self _getBingDetail];
        self.translate = [self _getBingTranslate];
    }
}
- (NSString *)_getTranslate {
    NSArray * arraySym = self.dictionaryBaseInfo[kStringJinShanSymbols];
    NSDictionary * dictionarySym = [arraySym firstObject];
    if (dictionarySym) {
        NSArray * arraySyParts = dictionarySym[kStringJinShanParts];
        for (int i = 0; i<arraySyParts.count; i++) {
            NSDictionary * dicPart = arraySyParts[i];
            NSArray * arrayContent = dicPart[@"means"];
            if (arrayContent && arrayContent.count) {
                for (int j = 0 ; j<arrayContent.count; j++) {
                    return arrayContent[j];
                }
            }
        }
    }
    return @"";
}
- (NSMutableAttributedString *)_getDetail {
    if (self.typeTranslateClass == TypeTranslateClassBingDictionary) {
        return [self _getBingDetail];
    } else if (self.typeTranslateClass == TypeTranslateClassJinShanDictionary) {
        return [self _getJinShanDetail];
    }
    return nil;
    
}
- (NSString *)_getBingTranslate {
    NSArray * arraySym = self.dictionaryBaseInfo[@"defs"];
    if (arraySym) {
        for (int i = 0; i<arraySym.count; i++) {
            NSDictionary * dicPart = arraySym[i];
            NSString * stringContent = dicPart[@"def"];
            if (stringContent && stringContent.length) {
                return stringContent;
            }
        }
    }
    return @"";
}
- (void)_reloadTranslateExample {
    [self.arrayExamples removeAllObjects];
    NSArray * array = [self _getTranslateExample];
    if (array && array.count) {
        [self.arrayExamples addObjectsFromArray:array];
    }
}
- (NSMutableAttributedString *)_getJinShanDetail {
    NSArray * arraySym = self.dictionaryBaseInfo[kStringJinShanSymbols];
    NSDictionary * dictionarySym = [arraySym firstObject];
    NSMutableAttributedString *stringNew = [[NSMutableAttributedString alloc] init];
    
    if (dictionarySym) {
        NSArray * arraySyParts = dictionarySym[kStringJinShanParts];
        for (int i = 0; i<arraySyParts.count; i++) {
            NSDictionary * dicPart = arraySyParts[i];
            NSString * stringType = dicPart[@"part"];
            NSArray * arrayContent = dicPart[@"means"];
            NSMutableString * stringContent = [NSMutableString new];
            if (arrayContent && arrayContent.count) {
                for (int j = 0 ; j<arrayContent.count; j++) {
                    [stringContent appendFormat:@"%@; ",arrayContent[j]];
                }
            }
            if ((stringContent.length)) {
                if (i!=0) {
                    stringType = [NSString stringWithFormat:@"\n%@",stringType];
                }
                NSRange range = NSMakeRange(stringNew.length,stringType.length);
                NSMutableAttributedString *stringTemp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",stringType,stringContent]];
                [stringNew appendAttributedString:stringTemp];
                [stringNew addAttribute:NSForegroundColorAttributeName value:COLOR_HEX(@"#999999") range:range];
                [stringNew addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
            }
        }
    }
    
    return stringNew;
}
- (NSMutableAttributedString *)_getBingDetail {
    NSArray * arraySym = self.dictionaryBaseInfo[@"defs"];
    NSMutableAttributedString *stringNew = [[NSMutableAttributedString alloc] init];
    
    if (arraySym) {
        for (int i = 0; i<arraySym.count; i++) {
            NSDictionary * dicPart = arraySym[i];
            NSString * stringType = dicPart[@"pos"];
            NSString * stringContent = dicPart[@"def"];
            if ((stringContent.length)) {
                if (i!=0) {
                    stringType = [NSString stringWithFormat:@"\n%@",stringType];
                }
                NSRange range = NSMakeRange(stringNew.length,stringType.length);
                NSMutableAttributedString *stringTemp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",stringType,stringContent]];
                [stringNew appendAttributedString:stringTemp];
                [stringNew addAttribute:NSForegroundColorAttributeName value:COLOR_HEX(@"#999999") range:range];
                [stringNew addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
            }
        }
    }
    
    return stringNew;
}
- (NSMutableArray *)arrayExamples {
    if (!_arrayExamples) {
        _arrayExamples = [NSMutableArray new];
    }
    return _arrayExamples;
}
@end
