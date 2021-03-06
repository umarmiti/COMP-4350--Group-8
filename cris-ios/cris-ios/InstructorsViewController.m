//
//  InstructorsViewController.m
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-09.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "InstructorsViewController.h"
#import "InstructorDetailViewController.h"
#import "AppDelegate.h"

@interface InstructorsViewController ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong)  NSMutableArray *instructors;

@end

@implementation InstructorsViewController

@synthesize responseData = _responseData;
@synthesize instructors;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    self.instructors = [NSMutableArray array];//initWithObjects:@"Michael Zapp", @"JOhn Braico", @"C Penner", nil];
    self.responseData = [NSMutableData data];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@instructors/_query", appDel.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://dev-umhofers-env-nmsgwpcvru.elasticbeanstalk.com/instructors/_query?key="]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewDidLoad];
    [self.instructorsTable reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"HELLO HERE");
    //UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *ip = (NSIndexPath *)sender;
    NSString *instructor = [self.instructors objectAtIndex:ip.row];
    InstructorDetailViewController *idv = (InstructorDetailViewController *) segue.destinationViewController;
    idv.instructor = instructor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return instructors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = [instructors objectAtIndex:indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.textColor = [UIColor redColor];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    
    InstructorDetailViewController *idv = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructorDetailViewController"];
    [self performSegueWithIdentifier:@"instructorSegue" sender:indexPath];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [self.responseData length]);
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSArray *jsonInstructors = [res objectForKey:@"instructors"];
   
    // get each instructors attributes and place them into the array of strings
    for (NSDictionary *result in jsonInstructors)
    {
        NSString *instructor = [NSString stringWithFormat:@"%@", [result objectForKey:@"pname"]];
        NSString *courses = [NSString stringWithFormat:@"%@", [result objectForKey:@"courses"]];
        [self.instructors addObject:instructor];
        
    }
    
    
    [self.tableView reloadData];
}


@end
