//
//  ObjectMapper.m
//  JSObjCDemo
//
//  Created by confidence on 10/03/2013.
//  Copyright (c) 2013 confidenceJuice. All rights reserved.
//

#import "KVMapper.h"
#import "KVMap.h"

@implementation KVMapper





+(NSDictionary *)KVMapsForKeys:(NSArray *)keys defaultKeyTransformer:(NSString *(^)(NSString *))defaultKeyTransformationBlock{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        KVMap *kvMap=[[KVMap alloc] init];
        kvMap.keyTransformationBlock=defaultKeyTransformationBlock;
        [dict setValue:kvMap forKey:key];
    }
    return dict;
}




+(NSDictionary *)mappedKey:(NSString *)key andValue:(id)value withMapping:(KVMap *)objectMap{
    NSString *mappedKey=objectMap.keyTransformationBlock ?objectMap.keyTransformationBlock(key): key;
    id mappedValue=objectMap.valueTransformationBlock ?objectMap.valueTransformationBlock(value): value;
    
    NSDictionary *dict=@{mappedKey : mappedValue};
    
    return dict;
}


+(NSDictionary *)mappedDictionaryWithDictionary:(NSDictionary *)externalDict ObjectMap:(NSDictionary *)objectMapsDict{
    
    NSMutableDictionary *mappedDict=[NSMutableDictionary dictionary];
    
    [externalDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //create the new key-value paor
        NSDictionary *mappedKVPair=[self mappedKey:key andValue:obj withMapping:objectMapsDict[key]];
        // remove the old value (must be done first since if there is a value change but no keychange we can remove the kv entry we wanted)
        //[mappedDict removeObjectForKey:key];
        // add the new value
        [mappedDict addEntriesFromDictionary:mappedKVPair];
        
    }];
    
    return mappedDict;
}

@end
