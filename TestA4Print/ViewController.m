//
//  ViewController.m
//  TestA4Print
//
//  Created by Diogo Carneiro on 30/05/16.
//  Copyright © 2016 AppNinja. All rights reserved.
//

#import "ViewController.h"
#import "PDFView.h"
#import "CardModel.h"

@implementation UIView (fadeIn)

- (void)fadeIn{
	self.alpha = 0;
	self.hidden = NO;
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDuration:0.25];
	self.alpha = 1;
	[UIView commitAnimations];
	
	
}

- (void)fadeOut{
	self.alpha = 1;
	self.hidden = NO;
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDuration:0.25];
	self.alpha = 0;
	[UIView commitAnimations];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSString *configPath = [[NSBundle mainBundle] pathForResource:@"configfile" ofType:nil];
	NSData *data = [[NSFileManager defaultManager] contentsAtPath:configPath];
	NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	NSArray *trelloPanelsURLs = [config valueForKeyPath:@"trello.panels.url"];
	
	trelloLists = @[trelloPanelsURLs[0], trelloPanelsURLs[1]];
}

- (void)viewDidAppear:(BOOL)animated{
	
	[self updateList];

}

- (IBAction)updateList{
	
	[_illustrationView setHidden:YES];
	
	if ([_boardSegmentedControl selectedSegmentIndex] == 0) {
		[_squarePostitSwitch setOn:YES];
	}else{
		[_squarePostitSwitch setOn:NO];
	}
	
	[SVProgressHUD show];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager GET:[trelloLists objectAtIndex:[_boardSegmentedControl selectedSegmentIndex]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		
		cards = [[NSMutableArray alloc] init];
		
		for (NSDictionary *cardJson in (NSArray *)responseObject) {
			CardModel *card = [[CardModel alloc] init];
			
			card.idShort = [[cardJson objectForKey:@"idShort"] intValue];
			card.name = [cardJson objectForKey:@"name"];
			
			for (NSString *label in [cardJson objectForKey:@"labels"]) {
				
				if ([[(NSDictionary *)label objectForKey:@"idBoard"] isEqualToString:@"5106998ef2748a9c56005d13"]) {
					if ([[(NSDictionary *)label objectForKey:@"id"] isEqualToString:@"545af0d674d650d56768beb5"]) {
						card.cardType = CardTypeIos;
					}else if ([[(NSDictionary *)label objectForKey:@"id"] isEqualToString:@"545af0d674d650d56768beb0"]) {
						card.cardType = CardTypeAndroid;
					}
				}
				
				if ([[(NSDictionary *)label objectForKey:@"id"] isEqualToString:@"576aa8b484e677fd363b21cb"] || [[(NSDictionary *)label objectForKey:@"id"] isEqualToString:@"576aaac284e677fd363b2c5b"]) {
					card.detailingCard = YES;
				}
			}
			
			[cards addObject:card];
		}
		
//		[self printPDF];
		
//		[SVProgressHUD dismiss];
		
		[SVProgressHUD showSuccessWithStatus:@"Pronto para impressão"];
		
		_illustrationViewFail.hidden = YES;
		_illustrationViewArrow.alpha = .5;
		[_illustrationView fadeIn];
	} failure:^(NSURLSessionTask *operation, NSError *error) {
		NSLog(@"Error: %@", error);
		
		_illustrationViewFail.hidden = NO;
		[_illustrationView fadeIn];
		_illustrationView.alpha = .4;
//		[_illustrationView fadeIn];
		
		[SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeNone];
		
	}];
	
	//5106da60863ddb8556002a7b
}

- (NSData*)generatePDFWithCards{
	NSMutableData * pdfData=[NSMutableData data];
 
//	[[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil];
 
	// by default, the UIKit will create a 612x792 page size (8.5 x 11 inches)
	// if you pass in CGRectZero for the size
	UIGraphicsBeginPDFContextToData(pdfData, CGRectZero,nil);
	CGContextRef pdfContext=UIGraphicsGetCurrentContext();
	
	
	NSMutableArray *arrayOfArrays = [NSMutableArray array];
	int batchSize = 6;
	
	for(int j = 0; j < [cards count]; j += batchSize) {
		
		NSArray *subarray = [cards subarrayWithRange:NSMakeRange(j, MIN(batchSize, [cards count] - j))];
		[arrayOfArrays addObject:subarray];
	}
 
	
	for (NSArray *subarrays in arrayOfArrays) {
		// repeat the code between the lines for each pdf page you want to output
		// ======================================================================
		UIGraphicsBeginPDFPage();
		
		// add code to update the UI elements in the first page here
		
		// use the currently being outputed view's layer here
		
		PDFView *pdfView;
		
		if ([_squarePostitSwitch isOn]) {
			pdfView = (PDFView *)[[[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil] objectAtIndex:1];
		}else{
			pdfView = (PDFView *)[[[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil] objectAtIndex:0];
		}
		
		int i = 0;
		for (CardModel *card in subarrays) {
			
			CardView *cardView = [[pdfView cardViews] objectAtIndex:i];
			[[cardView cardTitleLabel] setText:card.name];
			[[cardView cardTitleLabel] setFont:[UIFont systemFontOfSize:15]];
			[[cardView cardIdLabel] setText:[NSString stringWithFormat:@"%d", card.idShort]];
			[cardView setBackgroundColor:[UIColor clearColor]];
			[[cardView cardIdLabel] setHidden:card.detailingCard];
			
			if (card.cardType == CardTypeIos || card.cardType == CardTypeAndroid) {
				UIImageView *osLogo  = [[UIImageView alloc] initWithFrame:CGRectMake(cardView.frame.size.width - 36 , [cardView cardIdLabel].frame.origin.y, 22, 22)];
				if (card.cardType == CardTypeIos) {
					[osLogo setImage:[UIImage imageNamed:@"apple"]];
				}else if(card.cardType == CardTypeAndroid){
					[osLogo setImage:[UIImage imageNamed:@"android"]];
				}
				[cardView addSubview:osLogo];
			}
			
			if (_printBordersSwitch.on) {
				[cardView layer].borderColor = [[UIColor grayColor] CGColor];
				[cardView layer].borderWidth = 1;
			}else{
				[cardView layer].borderColor = [[UIColor clearColor] CGColor];
				[cardView layer].borderWidth = 0;
			}
			
			
			cardView.hidden = NO;
			
			i++;
		}
		
		[[pdfView layer] renderInContext:pdfContext];
		
		// end repeat code
		// ======================================================================
	}
 
	// finally end the PDF context.
	UIGraphicsEndPDFContext();
 
	// and return the PDF data.
	return pdfData;
}

- (IBAction)printPDF {
	
	UIPrintInteractionController *printer=[UIPrintInteractionController sharedPrintController];
	UIPrintInfo *info = [UIPrintInfo printInfo];
	info.orientation = UIPrintInfoOrientationPortrait;
	info.outputType = UIPrintInfoOutputGeneral;
	info.jobName=@"CadabraCorp.pdf";
	info.duplex=UIPrintInfoDuplexLongEdge;
	printer.printInfo = info;
	printer.showsPageRange=YES;
	printer.printingItem=[self generatePDFWithCards];
	
	UIPrintInteractionCompletionHandler completionHandler =
	^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
		if (!completed && error)
			NSLog(@"FAILED! error = %@",[error localizedDescription]);
	};
	[printer presentAnimated:YES completionHandler:completionHandler];
}

-(IBAction)share{
	NSArray *activityItems;
	
	activityItems = @[[self generatePDFWithCards]];
	
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	
//	activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
//	
//	};
	
	[self presentViewController:activityController animated:YES completion:nil];
}

-(IBAction)nextSegment{
	[_boardSegmentedControl setSelectedSegmentIndex:1];
	[self updateList];
}

-(IBAction)previousSegment{
	[_boardSegmentedControl setSelectedSegmentIndex:0];
	[self updateList];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
