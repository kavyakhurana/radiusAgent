# radiusAgent

The entire xcode porject lies in the master branch.

## Architecture

I have implemented this code using VIPER architecture in swift. 
It has the view, which includes the table view. The view is more or less dumb, not making any decisions, simply handling user interactions.
The presenter handles view related logic, acting as the data source for the table view, providing cell data and number of rows and sections.
The interactor handles heavier logic, like making the API call. The interactor would trigger the router actions incase this was a multi screen app.
The router builds other viper modules and routes to different screens.
The entity holds the model.

In addition to that, I have a tabkle view cell and header.


## Third party libraries:

I am using RxSwift to communicate between the interactor and presenter, and the presenter and the view controller. I am using PublishSubjects for this.

The entire module id generally built inside a builder but since this is a single screen app, i am building the presenter, interactor and router inside the viewDidLoad method of the viewController.

## Video

https://github.com/kavyakhurana/radiusAgent/assets/86793033/6d69966c-3c18-4337-8b38-7523b488920e



