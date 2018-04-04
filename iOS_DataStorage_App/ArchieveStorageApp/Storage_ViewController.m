

#import "Storage_ViewController.h"

@interface Storage_ViewController ()

@end

@implementation Storage_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveToFile:(id)sender {
    
    
    NSString *string = [NSString stringWithFormat: @"%@ %@ %@", _author.text, _book.text, _desc.text];
    
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:@"testfile.txt"];
    [string writeToFile:path atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",path);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Saved to File"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (IBAction)saveToArchiever:(id)sender {
  

    NSMutableArray *infoArray;
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the data file
    _dataFilePath = [[NSString alloc] initWithString: [docsDir
                                                       stringByAppendingPathComponent: @"data.archive"]];
    
    NSLog(@"_dataFilePath %@", _dataFilePath);
    
    infoArray = [[NSMutableArray alloc] init];
    [infoArray addObject:_author.text];
    [infoArray addObject:_book.text];
    [infoArray addObject:_desc.text];
    [NSKeyedArchiver archiveRootObject:
     infoArray toFile:_dataFilePath];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Saved to Archiver"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    
    

    
}


@end
