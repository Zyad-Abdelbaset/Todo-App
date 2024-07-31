//
//  InProgressVC.m
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import "InProgressVC.h"

@interface InProgressVC ()
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;
@property bool isSorted;
@property NSMutableArray* low; //filterd low
@property NSMutableArray* med; //fillterd med
@property NSMutableArray* hi; //filterd hi

@end

@implementation InProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _inProgressTableView.delegate=self;
    _inProgressTableView.dataSource=self;
    
    
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
    [self creatingInprogArr];
    _inProgressTableView.hidden=false;
    if(_inProgressArr.count==0){
        _inProgressArr=[NSMutableArray new];
        _inProgressTableView.hidden=true;
    }
    _low=[[NSMutableArray alloc] init];
    _med=[NSMutableArray new];
    _hi=[NSMutableArray new];
    [self indexForeverySection];
    [_inProgressTableView reloadData];
}
-(void)filterButton{
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(filterBtnAction)];
    [self.tabBarController.navigationItem setRightBarButtonItem: filterBtn animated:YES];
}

-(void)filterBtnAction{
    _isSorted= _isSorted ? false : true;
    [_inProgressTableView reloadData];
}


-(void)creatingInprogArr{
    _inProgressArr=[NSMutableArray new];
    for(NoteModel * note in _noteArr){
        if([@1 isEqualToNumber:note.type]){
            [_inProgressArr addObject:note];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    _isSorted=false;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [_inProgressTableView dequeueReusableCellWithIdentifier:@"cell"];
    int x =0;
    if(!_isSorted){
        cell.textLabel.text=_inProgressArr[indexPath.row].title;
        cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",[_inProgressArr objectAtIndex:indexPath.row].priority] ];
    }else{
        switch (indexPath.section) {
            case 0:
                x=[[_low objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inProgressArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inProgressArr[x].priority] ];
                break;
            case 1:
                x=[[_med objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inProgressArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inProgressArr[x].priority] ];
                break;
                
            case 2:
                x=[[_hi objectAtIndex:indexPath.row] intValue];
                cell.textLabel.text=_inProgressArr[x].title;
                cell.imageView.image=[UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@",_inProgressArr[x].priority] ];
                break;
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteSceneVC * NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NoteSceneVC"];
    int x=0;
    if(!_isSorted){
        NVC.note=_inProgressArr[indexPath.row];
    }else{
        switch (indexPath.section) {
            case 0:
                x=[[_low objectAtIndex:indexPath.row] intValue];
                NVC.note=_inProgressArr[x];
                break;
                
            case 1:
                x=[[_med objectAtIndex:indexPath.row] intValue];
                NVC.note=_inProgressArr[x];
                break;
            case 2:
                x=[[_hi objectAtIndex:indexPath.row] intValue];
                NVC.note=_inProgressArr[x];
                break;
                
            default:
                break;
        }
    }
    NVC.arr=_noteArr;
    NVC.callerScene=1;
    NVC.ud=self.ud;
    
    [self.navigationController pushViewController:NVC animated:true];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    int count=0;
    
    if(_isSorted){
        count = [self countOfRowinSec:section];
    }else{
        count=(int)_inProgressArr.count;
    }
    
    return count;
}

-(int)countOfRowinSec:(NSInteger)sec{
    int num = 0;
    for(NoteModel * note in _inProgressArr){
        if([note.priority isEqualToNumber:@(sec) ]){
            
            num++;
    
        }
    }
    return num;
}

-(void)indexForeverySection{
    for(int i=0;i<_inProgressArr.count;i++){
        switch ([_inProgressArr[i].priority intValue]) {
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
        //[self->_toDoArr removeObjectAtIndex:indexPath.row];
        NSInteger index= [self->_noteArr indexOfObject:self->_inProgressArr[indexPath.row]];
        [self->_noteArr removeObjectAtIndex:index];
        [self->_inProgressArr removeObjectAtIndex:indexPath.row];
        [self->_inProgressTableView beginUpdates];
        [self.inProgressTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.inProgressTableView endUpdates];
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
        NSInteger index= [self->_noteArr indexOfObject:self->_inProgressArr[x]];
        [self->_noteArr removeObjectAtIndex:index];
        [self->_inProgressArr removeObjectAtIndex:x];
        [self->_inProgressTableView beginUpdates];
        [self.inProgressTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.inProgressTableView endUpdates];
        [self.ud setNoteArr:self.noteArr forKey:@"NoteArray"];
       // [self->_inProgressTableView reloadData];
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

@end
