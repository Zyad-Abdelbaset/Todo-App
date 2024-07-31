//
//  NoteModel.h
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteModel : NSObject <NSCoding,NSSecureCoding>
@property NSString * title;
@property NSString* describtion;
@property NSNumber* priority;
@property NSNumber* type;
@property NSDate * date;
-(instancetype) initWithTitle:(NSString*)title andDescribtion:(NSString*)describtion andDate:(NSDate*)date andPriority:(NSNumber*)priority andType:(NSNumber*)type;
-(void) encodeWithCoder:(NSCoder*)coder;
@end

NS_ASSUME_NONNULL_END
