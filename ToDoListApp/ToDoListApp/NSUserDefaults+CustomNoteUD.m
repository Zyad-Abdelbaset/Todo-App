//
//  NSUserDefaults+CustomNoteUD.m
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import "NSUserDefaults+CustomNoteUD.h"

@implementation NSUserDefaults (CustomNoteUD)

- (nonnull NSMutableArray<NoteModel *> *)NoteArrForKey:(nonnull NSString *)key {
    NSData *encodedNotesArray = [self objectForKey:key];
        if (encodedNotesArray) {
            printf("EncodedNotesArr is true");
            NSError *error = nil;
            NSMutableArray<NoteModel*>*notesArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[[NSMutableArray class], [NoteModel class]]] fromData:encodedNotesArray error:&error];
            if (error) {
                NSLog(@"Failed to decode Note array: %@", error);
                return nil;
            }
            printf("\nWE return array sucess");
            return notesArray;
        }
      printf(" not EncodedNotesArr is false");
        return nil;
}

- (void)setNoteArr:(nonnull NSMutableArray<NoteModel *> *)noteArr forKey:(nonnull NSString *)key {
    NSError *error = nil;
        NSData *encodedNotes = [NSKeyedArchiver archivedDataWithRootObject:noteArr requiringSecureCoding:YES error:&error];
        if (error) {
            NSLog(@"Failed to encode NoteArray: %@", error);
        } else {
            [self setObject:encodedNotes forKey:key];
            NSLog(@"Good to encode Note: \n");
        }
}

- (nonnull NoteModel *)noteForKey:(nonnull NSString *)key {
    NSData *encodedNote = [self objectForKey:@"Note"];
    
        if (encodedNote) {
            NSError *error = nil;
            NoteModel *note = [NSKeyedUnarchiver unarchivedObjectOfClass:[NoteModel class] fromData:encodedNote error:&error];
            if (error) {
                NSLog(@"Failed to noteForKey Note: %@", error);
                return nil;
            }
            return note;
        }
        return nil;
}

- (void)setNote:(nonnull NoteModel *)note forKey:(nonnull NSString *)key {
    NSError *error = nil;
        NSData *encodedNote = [NSKeyedArchiver archivedDataWithRootObject:note requiringSecureCoding:YES error:&error];
        if (error) {
            NSLog(@"Failed to setNote : %@", error);
        } else {
            [self setObject:encodedNote forKey:@"Note"];
        }
}




@end
