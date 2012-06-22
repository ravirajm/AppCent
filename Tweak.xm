static BOOL enabled;

static void pref() {
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/be.rud0lf77.appcent.plist"];
	enabled = [prefs objectForKey:@"enabled"] == nil ? YES : [[prefs objectForKey:@"enabled"] boolValue];
	[prefs release];
}

%hook SBDownloadingIcon
- (id)displayName {
	NSString *displayName_;
	if (enabled) {
	displayName_ = [NSString stringWithFormat:@"%d%%", (int)([self progress]*100)];
	} else {
	displayName_ = %orig;
	}
	return displayName_;
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)pref, CFSTR("be.rud0lf77.appcent.prefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	pref();
	[pool drain];
}
