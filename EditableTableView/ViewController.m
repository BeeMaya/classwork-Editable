#import "ViewController.h"

@interface ViewController ()  <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *data;                   //добав изменяем массив,куда будут складываться данные
@property (weak, nonatomic) IBOutlet UITextField *textField;            //добавляем текстовое поле
@property (weak, nonatomic) IBOutlet UITableView *tableView;           //добавляем экран для оборажения рядов
@property (weak, nonatomic) IBOutlet UIButton *addButton;             //добав кнопку для добавления рядов
@property (weak, nonatomic) IBOutlet UIButton *editButton;           // добавляем кнопку для редактирования
@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
       self.data = [NSMutableArray array];                       //создаем и инициализируем изменяемый массив, в который будут загружаться данные
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];  //регистрируем класс для создания ячеек

    //self.tableView.editing = YES;                                //старое - делаем табличку изменяемой
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {      //создаем метод, кот. возвращает на экран кол-во ячеек нашего массива(command+N - implement metod)
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];          //создаем ячейку с идентификатором
     cell.textLabel.text = self.data [(NSUInteger) indexPath.row];                                            //кладем в текст текстового поля ячейки - данные из массива о порядковом номере ряда
     return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {   //теперь мы можем редактировать все ячейки (дз -если индекс больше 2, то YES)
    return YES;                                                                                           //для нерекдактируемых ячеек - return NO
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {   //вызываем метод для удаления ячеек в режиме редактирования

    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:(NSUInteger)indexPath.row];                    //в режиме редактирования удаляем данную ячейку из массива

        self.editButton.enabled = (self.data.count >0);                //делаем кнопку EDIT включенной, если кол-во строк массива больше 0 (т.е. пока нет ни одной строки, кнопка не работает)

        if (self.data.count ==0) {
            self.editButton.selected = NO;             //пока нет ни одной строки, кнопка ЭДИТ неактивна
            self.tableView.editing = NO;
        }

        [tableView beginUpdates];                                                                          //предупреждает  о начале/конце каких то действий с рядами (в частности об удалении ряда из Экрана TableView)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }

}


- (IBAction)onAddRowTapped:(id)sender {                //добавляем  действие при нажатии кнопки "+"

        NSUInteger currentIndex = self.data.count;
        NSString *str = self.textField.text;                                             // создаем строку, в кот. кладем содержимое ткстового поля
       //старое  [NSString stringWithFormat:@"Data for row %d", currentIndex];

        self.textField.text = nil;                                                        // очищаем текстовое поле после добавления строки (нажатия "+")
        self.addButton.enabled = NO;   //(self.textField.text.length >0);                  // кнопка "+" не работает, пока пусто в текстовом поле
        [self.data addObject:str];                                            // вызываем метод добавления строк в наш массив

        self.editButton.enabled = (self.data.count >0);               //кнопка ЭДИТ не  работает,  пока не добавлена ни одна строка

        //[self.tableView reloadData];                      старое - перегружаем всю таблицу, чтобы появлялись данные при ТАПе, но этот метод долгий

        [self.tableView beginUpdates];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];          //не помню :)

        [self.tableView endUpdates];
}


- (IBAction)textChanged:(id)sender {                                     //добавляем  действие для  кнопки "+"
    self.addButton.enabled = self.textField.text.length >0;                   //если длина текстового поля больше 0 (не пусто), то кнопка "+" работает
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];                           //при нажатии на РЕТУРН (DONE) прячется клавиатура      - но у меня почему то не прячется :)
    return NO;
}


- (IBAction)onEdit:(id)sender {
    self.editButton.selected =! self.editButton.selected;            //кнопка меняет состояние (инвертируется на обратное ) выделена-невыделена
    self.tableView.editing = self.editButton.selected;                                //делаем табличку изменяемой,если кнопка ЭДИТ включена
}

@end
