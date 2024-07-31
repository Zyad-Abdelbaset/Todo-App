//
//  ToDoVS.m
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import "ToDoVC.h"
#import "NSUserDefaults+CustomNoteUD.h"
#import "NoteSceneVC.h"
@interface ToDoVC ()
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property NSUserDefaults * ud;
@property NSMutableArray<NoteModel*>* arrNote;//all array
@property NSMutableArray<NoteModel*>* toDoArr;//todo arr
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
//@property Boolean sectioned;
@property NSMutableArray<NoteModel*>* filteredarr;//filterd arr
@property Boolean isFiltered;
@end

@implementation ToDoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_searchtxt setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _searchtxt.delegate=self;
    self.tabBarController.title=@"Todo Notes";
    _toDoTableView.delegate=self;
    _toDoTableView.dataSource=self;
    // Create a bar button item
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self addBarButton];
    self.isFiltered = NO;
    _ud=[NSUserDefaults standardUserDefaults];
    _arrNote = [_ud NoteArrForKey:@"NoteArray"];
    if(_arrNote.count==0){
        _arrNote=[NSMutableArray new];
    }
    [self creatingToDoArr];
    _toDoTableView.hidden=false;
    if(_toDoArr.count==0){
        
        _toDoTableView.hidden=true;
    }
    self.filteredarr = _toDoArr;
    [self.toDoTableView reloadData];
}

-(void)creatingToDoArr{
    _toDoArr=[NSMutableArray new];
    for(NoteModel * note in _arrNote){
        if([@0 isEqualToNumber:note.type]){
            [_toDoArr addObject:note];
        }
    }
}
-(void)addBarButton{
    UIBarButtonItem *addNoteBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus.app"] style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    [self.tabBarController.navigationItem setRightBarButtonItem: addNoteBtn animated:YES];
}
-(void)addNote{
    NoteSceneVC* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteSceneVC"];
    nextVC.callerScene=0;
    nextVC.arr=_arrNote;
    nextVC.ud=self.ud;
    [self.tabBarController.navigationController pushViewController:nextVC animated:true];
}
//-(void)filterButton{
//    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
//    [self.tabBarController.navigationItem setRightBarButtonItem: filterBtn animated:YES];
//}

#pragma mark - Navigation

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    UITableViewCell * cell = [_toDoTableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(_isFiltered){
        cell.textLabel.text = [_filteredarr objectAtIndex:indexPath.row].title;
        cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",[_filteredarr objectAtIndex:indexPath.row].priority] ];
    }else{
        cell.textLabel.text = [_toDoArr objectAtIndex:indexPath.row].title;
        cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",[_toDoArr objectAtIndex:indexPath.row].priority] ];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    if(_isFiltered){
        return _filteredarr.count;
    }else{
        return _toDoArr.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteSceneVC* vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteSceneVC"];
    NSInteger index;
    if(_isFiltered){
        index= [_arrNote indexOfObject:_filteredarr[indexPath.row]];
        vc2.note = [_arrNote objectAtIndex:index];
    }else{
        
        index= [_arrNote indexOfObject:_toDoArr[indexPath.row]];
        vc2.note = [_arrNote objectAtIndex:index];
    }
    vc2.arr=_arrNote;
    vc2.callerScene=1;
    vc2.ud=self.ud;
    [self.navigationController pushViewController:vc2 animated:true];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction* delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //[self->_toDoArr removeObjectAtIndex:indexPath.row];
        NSInteger index= [self->_arrNote indexOfObject:self->_toDoArr[indexPath.row]];
        [self->_arrNote removeObjectAtIndex:index];
        [self->_toDoArr removeObjectAtIndex:indexPath.row];
        [self->_toDoTableView beginUpdates];
        [self.toDoTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.toDoTableView endUpdates];
        [self.ud setNoteArr:self.arrNote forKey:@"NoteArray"];
        completionHandler(true);
    }];
    delete.image=[UIImage systemImageNamed:@"trash.fill"];
    
    
    UISwipeActionsConfiguration * config;
    if(!_isFiltered){
        config= [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    }
    return config;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
            self.isFiltered = NO;
            self.filteredarr = [NSMutableArray arrayWithArray:self.toDoArr];
        } else {
            self.isFiltered = YES;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[c] %@", searchText];
            self.filteredarr = [NSMutableArray arrayWithArray:[self.toDoArr filteredArrayUsingPredicate:predicate]];
        }
        [self.toDoTableView reloadData];
}


@end
