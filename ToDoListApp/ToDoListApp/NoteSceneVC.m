//
//  NoteModelVC.m
//  ToDoListApp
//
//  Created by zyad Baset on 17/07/2024.
//

#import "NoteSceneVC.h"
#import "NSUserDefaults+CustomNoteUD.h"
@interface NoteSceneVC ()
@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITextView *describtionTxt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation NoteSceneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_callerScene) {
        case 0:[self initVC0];
            break;
        case 1:[self initVC1];
            break;
        case 2:[self initVC2];
            break;
        default:
            break;
    }
    [_prioritySegment addTarget:self action:@selector(changePriorityImage) forControlEvents:UIControlEventValueChanged];
    [self changePriorityImage];
    
    // Do any additional setup after loading the view.
}
-(void)changePriorityImage{
    _imgView.image=[UIImage imageNamed:[@(_prioritySegment.selectedSegmentIndex) stringValue] ];
}

-(void)initVC0{
    [_typeSegment setEnabled:false forSegmentAtIndex:1];
    [_typeSegment setEnabled:false forSegmentAtIndex:2];
    _date.date=[NSDate date];
    _date.minimumDate = [NSDate date];
}
-(void)initVC1{
    if([_note.type  isEqual: @2]){
        [self initVC2];
    }else{
        if([_note.type  isEqual: @1]){
            [_typeSegment setEnabled:false forSegmentAtIndex:0];
        }
        _titleTxt.text=_note.title;
        _describtionTxt.text=_note.describtion;
        _prioritySegment.selectedSegmentIndex=[_note.priority integerValue];
        _typeSegment.selectedSegmentIndex=[_note.type integerValue];
        _date.date=_note.date;
        _date.minimumDate = [NSDate date];
        _btn1.titleLabel.text=@"UpDate";
    }
    
    
}
-(void)initVC2{
    _titleTxt.text=_note.title;
    _describtionTxt.text=_note.describtion;
    _prioritySegment.selectedSegmentIndex=[_note.priority integerValue];
    _typeSegment.selectedSegmentIndex=[_note.type integerValue];
    _date.date=_note.date;
    _titleTxt.enabled=false;
    _describtionTxt.userInteractionEnabled=false;
    _prioritySegment.enabled=false;
    _typeSegment.enabled=false;
    _date.enabled=false;
    _btn1.titleLabel.text=@"Close";
    
}
- (IBAction)addNoteAction:(id)sender {
    
    switch (self.callerScene) {
        case 0:
            if([_titleTxt.text isEqualToString:@""]){
                [self emptyTitleAlert];
            }else{
                [self confirmAddNoteAlert];
            }
            break;
            
        case 1:
            if([_titleTxt.text isEqualToString:@""]){
                [self emptyTitleAlert];}
                else{
                    [self upDateNote ];
                }
            
            break;
        case 2:[self.navigationController popViewControllerAnimated:true];
            break;
        default:
            break;
    }
    
    
}

-(void)upDateNote{
    _note.title=_titleTxt.text;
    _note.describtion=_describtionTxt.text;
    _note.priority=@(_prioritySegment.selectedSegmentIndex);
    _note.type=@(_typeSegment.selectedSegmentIndex);
    _note.date=_date.date;
    [_ud setNoteArr:_arr forKey:@"NoteArray"];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)emptyTitleAlert{
    UIAlertController *titleAlert = [UIAlertController alertControllerWithTitle:@"Embty Title" message:@"you must add title to Note" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
    UIAlertAction *actionGoBack = [UIAlertAction actionWithTitle:@"Go Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tabBarController.navigationController popViewControllerAnimated:true];
    }];
    [titleAlert addAction:actionOk];
    [titleAlert addAction:actionGoBack];
    [self presentViewController:titleAlert animated:true completion:NULL];
}
-(void)confirmAddNoteAlert{
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"Add Note" message:@"Confirmation of adding new note" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:NULL];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_note=[[NoteModel alloc] initWithTitle:self->_titleTxt.text andDescribtion:self->_describtionTxt.text andDate:self->_date.date andPriority:@(self->_prioritySegment.selectedSegmentIndex) andType:@(self->_typeSegment.selectedSegmentIndex)];
        [self->_arr addObject:self->_note];
        [self.ud setNoteArr:self->_arr forKey:@"NoteArray"];
        [self.navigationController popViewControllerAnimated:true];
    }];
    [confirmAlert addAction:actionOk];
    [confirmAlert addAction:actionCancel];
    [self presentViewController:confirmAlert animated:true completion:NULL];
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
