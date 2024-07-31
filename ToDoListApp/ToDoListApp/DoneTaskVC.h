//
//  DoneTaskVC.h
//  ToDoListApp
//
//  Created by zyad Baset on 18/07/2024.
//

#import <UIKit/UIKit.h>
#import "NSUserDefaults+CustomNoteUD.h"
#import "NoteSceneVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface DoneTaskVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property NSUserDefaults *ud;
@property NSMutableArray<NoteModel*>* noteArr;
@property NSMutableArray<NoteModel*>* inDoneArr;

@end

NS_ASSUME_NONNULL_END
