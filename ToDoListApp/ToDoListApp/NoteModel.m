//
//  NoteModel.m
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import "NoteModel.h"
#import "NSUserDefaults+CustomNoteUD.h"
@implementation NoteModel
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.describtion forKey:@"describtion"];
    [coder encodeObject:self.priority forKey:@"priority"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.date forKey:@"date"];
}



- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
        if (self) {
            _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
            _describtion = [coder decodeObjectOfClass:[NSString class] forKey:@"describtion"];
            _priority = [coder decodeObjectOfClass:[NSNumber class] forKey:@"priority"];
            _type = [coder decodeObjectOfClass:[NSNumber class] forKey:@"type"];
            _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
        }
        return self;
}
+(BOOL)supportsSecureCoding{
    return TRUE;
}

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title andDescribtion:(nonnull NSString *)describtion andDate:(nonnull NSDate *)date andPriority:(nonnull NSNumber *)priority andType:(nonnull NSNumber *)type {
    self=[super init];
    self.title=title;
    self.describtion=describtion;
    self.date=date;
    self.priority=priority;
    self.type=@0;
    return self;
}

@end
