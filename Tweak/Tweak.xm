#import "Tweak.h"

static NSDictionary *replacement = @{
    @"jailbreak": @"jelbrek",
    @"coolstar": @"kewlster",
    @"when": @"wen",
    @"soon": @"son",
    @"ios": @"iso",
    @"announcement": @"annocement",
    @"official": @"offshul",
    @"like": @"laik",
    @"get": @"git",
    @"chimera": @"kamara",
    @"cydia": @"sidia",
    @"iphone": @"eyefon",
    @"boot": @"butt",
    @"saurik": @"suavrik",
    @"todesco": @"tabasco",
    @"luca": @"lake",
    @"tihmstar": @"thimster",
    @"siguza": @"sgutza",
    @"yalu": @"yala",
    @"sileo": @"selio",
    @"zebra": @"zombro",
    @"help": @"halp",
    @"release": @"reles",
    @"request": @"reqst",
    @"twitter": @"tweter",
    @"safari": @"firefox",
    @"news": @"new",
    @"apple": @"appl",
    @"woman": @"loli",
    @"tim": @"tom",
    @"porn": @"hentai"
};

static NSDictionary *loli = @{
    @"oo": @"ew",
    @"no": @"nu",
    @"ea": @"e",
    @"ch": @"k",
    @"al": @"ul",
    @"ou": @"oo",
    @"the": @"da",
    @"th": @"t",
    @"x": @"ks"
};

static NSString *mode = nil;

NSString *jelbrekify (NSString *text) {
    NSString *temp = [text copy];
    NSString *lowercase = [temp lowercaseString];
    if (replacement) {
        for (NSString *key in replacement) {
             if([replacement valueForKey:key] != nil) {
            lowercase = [lowercase stringByReplacingOccurrencesOfString:key withString:replacement[key]];
             }
        }
    }

    if (loli) {
        for (NSString *hentai in loli) {
             if([loli valueForKey:hentai] != nil) {
            lowercase = [lowercase stringByReplacingOccurrencesOfString:hentai withString:loli[hentai]];
             }
        }
    }
    return [@"" stringByAppendingString: lowercase];
}

%group SelectJelbrek

%hook UICalloutBar

%property (nonatomic, retain) UIMenuItem *slcJelbrekItem;

-(id)initWithFrame:(CGRect)arg1 {
    UICalloutBar *orig = %orig;

    self.slcJelbrekItem = [[UIMenuItem alloc] initWithTitle:@"Jelbrek" action:@selector(slcJelbrek:)];

    return orig;
}

-(void)updateAvailableButtons {
    %orig;

    if (!self.extraItems) {
        self.extraItems = @[];
    }

    bool display = false;
    NSArray *currentSystemButtons = MSHookIvar<NSArray *>(self, "m_currentSystemButtons");

    for (UICalloutBarButton *btn in currentSystemButtons) {
        if (btn.action == @selector(cut:)) {
            display = true;
        }
    }

    NSMutableArray *items = [self.extraItems mutableCopy];

    if (display) {
        if (![items containsObject:self.slcJelbrekItem]) {
            [items addObject:self.slcJelbrekItem];
        }
    } else {
        [items removeObject:self.slcJelbrekItem];
    }

    self.extraItems = items;

    %orig;
}

%end

%hook UIResponder

%new
-(void)slcJelbrek:(UIResponder *)sender {
    NSString *originalText = [[UIPasteboard generalPasteboard].string copy];
    [[UIApplication sharedApplication] sendAction:@selector(cut:) to:nil from:self forEvent:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *selectedText = [[UIPasteboard generalPasteboard].string copy];

        if (selectedText) {
            [[UIPasteboard generalPasteboard] setString:jelbrekify(selectedText)];
            [[UIApplication sharedApplication] sendAction:@selector(paste:) to:nil from:self forEvent:nil];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (originalText) {
                [[UIPasteboard generalPasteboard] setString:originalText];
            } else {
                [[UIPasteboard generalPasteboard] setString:@""];
            }
        });
    });
}

%end

%end


%ctor {
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
    bool shouldLoad = NO;
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if (!isFileProvider && isApplication && !skip) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;

    %init(SelectJelbrek);
}
