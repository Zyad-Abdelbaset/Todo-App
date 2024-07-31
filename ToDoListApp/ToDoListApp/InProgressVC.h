//
//  InProgressVC.h
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import <UIKit/UIKit.h>
#import "NSUserDefaults+CustomNoteUD.h"
#import "NoteSceneVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface InProgressVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property NSUserDefaults *ud;
@property NSMutableArray<NoteModel*>* noteArr;//all array
@property NSMutableArray<NoteModel*>* inProgressArr;//progress arr

@end

NS_ASSUME_NONNULL_END
