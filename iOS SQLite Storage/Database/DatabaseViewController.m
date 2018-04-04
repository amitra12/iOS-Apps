

#import "DatabaseViewController.h"

@interface DatabaseViewController ()

@end

@implementation DatabaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];

    // Build the path to the database file
    _databasePath = [[NSString alloc]
       initWithString: [docsDir stringByAppendingPathComponent:
       @"contacts.db"]];

    
    NSLog(@"\nDBPath %@\n", docsDir);

    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
       const char *dbpath = [_databasePath UTF8String];

       if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
       {
            char *errMsg;
            const char *sql_stmt =
           "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, LOCATION TEXT, ADDRESS TEXT, PHONE TEXT, EMAIL TEXT)";

            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                 _status.text = @"Failed to create table";
            }
            sqlite3_close(_contactDB);
        } else {
                 _status.text = @"Failed to open/create database";
        }
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveData:(id)sender {
     sqlite3_stmt    *statement;
     const char *dbpath = [_databasePath UTF8String];

     if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
     {

           NSString *insertSQL = [NSString stringWithFormat:
             @"INSERT INTO CONTACTS (name, location, address, phone, email) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
             _name.text, _location.text, _address.text, _phone.text, _email.text];

           const char *insert_stmt = [insertSQL UTF8String];
           sqlite3_prepare_v2(_contactDB, insert_stmt,
             -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                 _status.text = @"Contact added";
                 _name.text = @"";
                _location.text = @"";
                 _address.text = @"";
                 _phone.text = @"";
                _email.text = @"";
            } else {
                 _status.text = @"Failed to add contact";
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
    }

}

- (IBAction)cancel:(id)sender {
    _status.text = @"";
    _name.text = @"";
    _location.text = @"";
    _address.text = @"";
    _phone.text = @"";
    _email.text = @"";

}


@end
