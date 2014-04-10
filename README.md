# Rewritten APIs

### Overview

This is a project to redesign and rewrite the APIs for some of the UIKit classes. It currently includes replacements for:
`UIActionSheet`
`UIAlertView`

These are not recreations of UIKit classes, but are classes that interface with the corresponding original UIKit class. This project started to ease some of my own annoyances with the original APIs. UIKit has a ton of phenomenal APIs, but there are some places where things could be improved. It’s been a lot of fun to practice and experiment with API design.

[Keynote Presentation (HTML)](http://mdznr.com/rcos/talks/goodapidesign)

[Presentation with notes (PDF)](http://mdznr.com/rcos/talks/goodapidesign.pdf)

### Current API

A simple use-case example with the original `UIActionSheet`:

In a method in of a view controller:
```objc
UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Title", nil)
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:nil
													  otherButtonTitles:NSLocalizedString(@"Open", nil), NSLocalizedString(@"Copy", nil), nil];
	[myActionSheet showInView:self.view];
```

The view controller is set as the delegate, and has to implement `actionSheet:clickedButtonAtIndex:`:
```objc
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0: // Open
			[self openActionSheetButtonTapped];
			break;
		case 1: // Copy
			[self copyActionSheetButtonTapped];
			break;
		default:
			break;
	}
}
```

The current API is complicated. The initializer method has four required parameters, one of them being a nil-terminated list. Nil-terminated lists don’t work well with data in data structures like arrays.

It’s misleading. `UIActionSheet` and `UIAlertView` are subclasses of `UIView`, which it may technically be, but that creates a confusing interface. To show either one of these classes, you use `showInView:` or `show`, instead of adding it as a subview of another view. The user should not be lead to believe they have to do this to get it to work. The view’s frame shouldn’t be an exposed part of the API, but it has to be since it is a subclass of `UIView`. Autocomplete in Xcode will suggest `UIView`-related suggestions like `initWithFrame:`, `transform`, and `backgroundColor`, all of which should not be used in these classes.

These classes do not have enough encapsulation. They push responsibility of mapping indices to actions, even though the delegate should not need to worry about a bunch of indices. Things get especially more complicated when using a cancel button and destructive button. Things get even more complicated when action sheets are created dynamically. If certain buttons aren’t always presented, the delegate has to account for the change in index values.

### Rewritten API

The same example as above but using the rewritten API:

```objc
MTZActionSheet *as = [[MTZActionSheet alloc] init];
as.title = @"Title";
as.cancelButtonTitle = NSLocalizedString(@"Cancel", nil)
[as addButtonWithTitle:NSLocalizedString(@"Open", nil) andSelector:@selector(openActionSheetButtonTapped)];
[as addButtonWithTitle:NSLocalizedString(@"Copy", nil) andSelector:@selector(copyActionSheetButtonTapped)];
[as showInView:self.view];
```

The examples used are quite simple, but representative of most uses of the action sheet. Comparatively, this code is much more concise. Concise code isn’t always better as it can often compromise clarity. However, just the opposite is shown here. The change to more concise code actually enhanced clarity.

The connection between button titles and their corresponding actions is much more clear. The code to handle this is no longer spread out across the file, making a mess of complicated code paths. The delegate no longest has to keep track of button indices, making it easier to dynamically populate the action sheet.

The intended use for this class is clarified by making it a `UIView`-backed subclass of `NSObject`. The developer is never mislead into thinking they’re responsible for handling how to display the view. The `show`, `showInView:`, etc. methods are the only available methods having to do with presenting the view. Irrelevant `UIView` properties and methods no longer clutter the API of these classes.
