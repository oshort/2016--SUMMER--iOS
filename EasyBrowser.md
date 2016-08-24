Create a simple app that can display webpages and provide basic page navigation.

## Required Features - This is basically a tutorial, so just follow the steps below

### Part 1

* Using Interface Builder and the Object Library (⌥⌘L), add a button and set its label to Open in Safari.
* Add constraints to center the button in the view.
* Using Interface Builder and the Assistant Editor (⌥⌘↩), create a connection from the button
to a controller action called openPageInSafari:
```swift
@IBAction func openPageInSafari(sender: UIButton)
{
    // open http://developer.apple.com 
}
```

* Implement the `openPageInSafari:` method.
```swift
@IBAction func openPageInSafari(sender: UIButton)
{

}
```

* Using the Xcode Documentation and API Reference (⇧⌘0), explore the `UIApplication` class reference and the `openURL:` method.
* Run the app (⌘R), tap the button, and observe how Safari enters the foreground.

### Part 2

* Using Interface Builder, change the button label to Open Page.
* Using the Object Library (⌥⌘L), drag a Web View object onto the center of the interface.
* Set constraints to horizontally center the web view; to pin its bottom space to the bottom layout guide; to pin its top space to the button; and to pin its left and right edges to the container margin.
* Resize the web view to occupy most of the interface, and update the constraints using the menu item Editor > Resolve Auto Layout Issues > Update Constraints (⇧⌘=).
* Using the Assistant Editor (⌥⌘↩), rename the controller method `openPageInSafari:` to `openPage:`.
* Using Interface Builder, Control-click the button, and delete the existing connection from
the button's Touch Up Inside event to the nonexistent `openPageInSafari:` action.
* With the Assistant Editor (⌥⌘↩) open, drag a connection from the hollow connection well
next to the openPage: method to the button.
* With the button selected, open the Connections Inspector (⌥⌘6), and verify the new
connection.
* Using Interface Builder and the Assistant Editor (⌥⌘↩), create an outlet property for the
web view in the ViewController class.
* Discuss the different ways of establishing connections between views and controllers.
* Using the Xcode Documentation and API Reference (⇧ ⌘ 0 ), explore the UIWebView class
reference and the `loadRequest:` method.
* Update the implementation of `openPage:`.
* Run the app (⌘ R ), and tap the button to demonstrate the loading of the page.
* Using Interface Builder, select the web view component, open the Attributes Inspector (⌥⌘4), and check the Scales Page to Fit attribute.
* Run the app (⌘R), tap the button, and observe how the web content fits within the web view.
* ⌥-click the iOS Simulator to simulate two touches to zoom, pan or scroll the web content within the web view.

### Part 3

* Using Interface Builder, delete the existing button.
* Using the Object Library (⌥⌘L), add a Toolbar to the top of the main view.
* Control-drag from the toolbar to the View in the Document Outline to add leading, trailing, and top edge constraints relative to the View.
* Drag the top edge of the web view to the bottom edge of the toolbar, and Control-drag from the web view to the toolbar to create a new vertical space constraint.
* Using the Object Library (⌥⌘L), add a Text Field to the toolbar, placing it to the left of the default Item button.
* Using the Object Library (⌥⌘L), add a Bar Button Item to the right of the default Item button.
* Select each bar button item, and use the Attributes Inspector (⌥⌘4) to modify the Identifier attribute. Choose Rewind for the left button, and Fast Forward for the right button.
* Expand the size of the text field by dragging its right edge.
* Run the app (⌘R), and make sure the menu item Hardware > Keyboard > Connect Hardware Keyboard (⇧⌘K) is unchecked in the Simulator. Tap on the text field, and observe the keyboard appear.
* Using Interface Builder, select the text field, and use the Attributes Inspector (⌥⌘4) to modify the Text Field attributes.
* Select Appears while editing for the Clear Button attribute, URL for the Keyboard Type attribute, and Go for the Return Key attribute.
* Run the app (⌘R), tap on the text field, and observe how the keyboard includes the .com key and a Go key instead of the standard Return key. Begin typing in the text field, and observe the clear button appear within the text field.

### Part 4

* Using Interface Builder and the Document Outline, Control-drag from the Round Style Text Field to the View Controller to set the View Controller as the text field delegate.
* Using the Xcode Documentation and API Reference (⇧⌘0), explore the UITextFieldDelegate protocol reference. Observe how the documentation states that the methods are optional.
* Take a look at the `UITextFieldDelegate` protocol method `textFieldShouldReturn:`.
* In the view controller class, declare the adoption of the `UITextFieldDelegate` protocol.
```swift
class ViewController: UIViewController, UITextFieldDelegate
```

* In the view controller implementation, delete the old `openPage:` method, and add an implementation of `textFieldShouldReturn:`.
```swift
func textFieldShouldReturn(textField: UITextField) -> Bool
{
}
```

* Run the app (⌘R), enter a valid http url (e.g., http://developer.apple.com), tap the Go key,
and observe the web view load the content.

### Part 5

* Run the app (⌘R), open some web content, and click on a few links.
* Notice how the view only displays content, and provides no navigation interface itself.
* Using the Xcode Documentation and API Reference (⇧⌘0), explore the UIWebView class reference.
* Using Interface Builder, select the web view and open the Connections Inspector (⌥⌘6). Observe the Received Actions panel.
* Using Interface Builder, select one of the tool bar buttons, and open the Connections Inspector (⌥⌘6).
* Notice how the tool bar button has only one available action binding, called selector, which represents the name of a method to call when the button is tapped.
* Using Interface Builder, Control-drag from the Rewind button to the web view to bind the selector to the goBack action.
* Using Interface Builder, Control-drag from the Fast Forward button to the web view to bind the selector to the goForward action.
* Run (⌘ R ) the app, view some web content, navigate through a few links, tap the back button, and tap the forward button.
