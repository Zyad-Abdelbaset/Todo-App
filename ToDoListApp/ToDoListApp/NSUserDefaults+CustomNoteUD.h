//
//  NSUserDefaults+CustomNoteUD.h
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (CustomNoteUD)
- (void)setNote:(NoteModel *)note forKey:(NSString *)key;
- (NoteModel *)noteForKey:(NSString *)key;
- (NSMutableArray<NoteModel*> *)NoteArrForKey:(NSString *)key;
- (void)setNoteArr:(NSMutableArray<NoteModel*>*)noteArr forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
