//
//  DoneTaskVC.m
//  ToDoListApp
//
//  Created by zyad Baset on 18/07/2024.
//

#import "DoneTaskVC.h"

@interface DoneTaskVC ()
@property (weak, nonatomic) IBOutlet UITableView *inDoneTableView;
@property bool isSorted;
@property NSMutableArray* low;
@property NSMutableArray* med;
@property NSMutableArray* hi;
@end

@implementation DoneTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _inDoneTableView.delegate=self;
    _inDoneTableView.dataSource=self;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self filterButton];
    self.tabBarController.navigationController.title=@"In Progress";
    self.ud = [NSUserDefaults standardUserDefaults];
    _noteArr = [_ud NoteArrForKey:@"NoteArray"];
    if(_noteArr.count==0){
        _noteArr=[NSMutableArray new];
    }
    [self creatingInDoneArr];
    _inDoneTableView.hidden=false;
    if(_inDoneArr.count==0){
        _inDoneArr=[NSMutableArray new];
        _inDoneTableView.hidden=true;
    }
    _low=[[NSMutableArray alloc] init];
    _med=[NSMutableArray new];
    _hi=[NSMutableArray new];
    [self indexForeverySection];
    [_inDoneTableView reloadData];
}

-(void)filterButton{
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(filterBtnAction)];
    [self.tabBarController.navigationItem setRightBarButtonItem: filterBtn animated:YES];
}
-(void)filterBtnAction{
    _isSorted= _isSorted ? false : true;
    [_inDoneTableView reloadData];
}
-(void)creatingInDoneArr{
    _inDoneArr=[NSMutableArray new];
    for(NoteModel * note in _noteArr){
        if([@2 isEqualToNumber:note.type]){
            [_inDoneArr addObject:note];
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [_inDoneTableView dequeueReusableCellWithIdentifier:@"cell"];
    int x =0;
    if(!_isSorted){
        cell.textLabel.text=_inDoneArr[indexPath.row].title;
        cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",[_inDoneArr objectAtIndex:indexPath.row].priority] ];
    }else{
        switch (indexPath.section) {
            case 0:
                x=[[_low objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inDoneArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inDoneArr[x].priority] ];
                break;
            case 1:
                x=[[_med objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inDoneArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inDoneArr[x].priority] ];
                break;
                
            case 2:
                x=[[_hi objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inDoneArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inDoneArr[x].priority] ];
                break;
        }

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteSceneVC * NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NoteSceneVC"];
    
    int x=0;
    if(!_isSorted){
        NVC.note=_inDoneArr[indexPath.row];
    }else{
        switch (indexPath.section) {
            case 0:
                x=[[_low objectAtIndex:indexPath.row] intValue];
                NVC.note=_inDoneArr[x];
                break;
                
            case 1:
                x=[[_med objectAtIndex:indexPath.row] intValue];
                NVC.note=_inDoneArr[x];
                break;
            case 2:
                x=[[_hi objectAtIndex:indexPath.row] intValue];
                NVC.note=_inDoneArr[x];
                break;
                
            default:
                break;
        }
    }
    NVC.arr=_noteArr;
    NVC.callerScene=2;
    NVC.ud=self.ud;
    [self.navigationController pushViewController:NVC animated:true];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count=0;
    
    if(_isSorted){
        count = [self countOfRowinSec:section];
    }else{
        count=(int)_inDoneArr.count;
    }
    
    return count;
}
-(int)countOfRowinSec:(NSInteger)sec{
    int num = 0;
    for(NoteModel * note in _inDoneArr){
        if([note.priority isEqualToNumber:@(sec) ]){
            num++;
        }
    }
    return num;
}

-(void)indexForeverySection{
    for(int i=0;i<_inDoneArr.count;i++){
        switch ([_inDoneArr[i].priority intValue]) {
            case 0:
                [_low addObject:@(i)];
                break;
            case 1:
                [_med addObject:@(i)];
                break;
            case 2:
                [_hi addObject:@(i)];
                break;
            default:
                break;
        }
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction* delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSInteger index= [self->_noteArr indexOfObject:self->_inDoneArr[indexPath.row]];
        [self->_noteArr removeObjectAtIndex:index];
        [self->_inDoneArr removeObjectAtIndex:indexPath.row];
        [self->_inDoneTableView beginUpdates];
        [self.inDoneTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.inDoneTableView endUpdates];
        [self.ud setNoteArr:self.noteArr forKey:@"NoteArray"];
        completionHandler(true);
    }];
    delete.image=[UIImage systemImageNamed:@"trash.fill"];
    
    UIContextualAction* deleteWhenSorting = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //[self->_toDoArr removeObjectAtIndex:indexPath.row];
         int x=0;
        switch (indexPath.section) {
            case 0:
                x=[[self->_low objectAtIndex:indexPath.row] intValue];
                [self.low removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                x=[[self->_med objectAtIndex:indexPath.row] intValue];
                [self.med removeObjectAtIndex:indexPath.row];
                break;
            case 2:
                x=[[self->_hi objectAtIndex:indexPath.row] intValue];
                [self.hi removeObjectAtIndex:indexPath.row];
                break;
            default:break;
        }
        NSInteger index= [self->_noteArr indexOfObject:self->_inDoneArr[x]];
        [self->_noteArr removeObjectAtIndex:index];
        [self->_inDoneArr removeObjectAtIndex:x];
        [self->_inDoneTableView beginUpdates];
        [self.inDoneTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.inDoneTableView endUpdates];
        [self.ud setNoteArr:self.noteArr forKey:@"NoteArray"];
       // [self->_inDoneTableView reloadData];
        [self viewWillAppear:true];
        completionHandler(true);
    }];
    deleteWhenSorting.image=[UIImage systemImageNamed:@"trash"];
    UISwipeActionsConfiguration * config;
    if(!_isSorted){
        config= [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    }else{
        config= [UISwipeActionsConfiguration configurationWithActions:@[deleteWhenSorting]];
    }
    return config;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* header = [NSString new];
    switch ((int)section) {
        case 0:
            header= _isSorted ? @"Low" : @"";
            break;
        case 1:
            header= @"medium";
            break;
        case 2:
            header= @"hight";
            break;
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(_isSorted){
        return 3;
    }else{
        return 1;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
