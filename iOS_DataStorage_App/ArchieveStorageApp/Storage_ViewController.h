

#import <UIKit/UIKit.h>

@interface Storage_ViewController : UIViewController
    
    @property (weak, nonatomic) IBOutlet UITextField *author;
    @property (weak, nonatomic) IBOutlet UITextField *book;
    @property (weak, nonatomic) IBOutlet UITextField *desc;
    @property (strong, nonatomic) NSString *dataFilePath;

@end
