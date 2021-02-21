![](meta/repo-banner.png)
[![](meta/repo-banner-bottom.png)][lionheart-url]

[![CI Status][ci-badge]][travis-repo-url]
[![Version][version-badge]][cocoapods-repo-url]
[![License][license-badge]][cocoapods-repo-url]
[![Platform][platform-badge]][cocoapods-repo-url]
[![Swift][swift-badge]][swift-url]

Fully customizable, circular progress bar written in Swift.

<img src="animation.gif" height="150" width="150" />

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. You can also view the example app at [Appetize.io][appetize-url].

### Usage

At the top of your file, make sure to import "ConcentricProgressRingView"

```swift
import ConcentricProgressRingView
```

Then, instantiate ConcentricProgressRingView in your view controller:

```swift
func viewDidLoad() {
    super.viewDidLoad()

    let fgColor1 = UIColor.yellow
    let bgColor1 = UIColor.darkGray
    let fgColor2 = UIColor.green
    let bgColor2 = UIColor.darkGray

    let rings = [
        ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 18),
        ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 18),
    ]

    let margin: CGFloat = 2
    let radius: CGFloat = 80
    let progressRingView = ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings)

    view.addSubview(progressRingView)
}
```

![](example1.png)

You can customize the width, margin, and radius, along with the number of rings. Here's another example with 6 progress rings, with a smaller bar width, larger margin between rings, and a larger radius:

```swift
let rings = [
    ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 10),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 10),
    ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 10),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 10),
    ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 10),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 10),
]

let margin: CGFloat = 10
let radius: CGFloat = 120
let progressRingView = ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings)
```

<img src="example2.png" width="194" />

Repeating widths can get a bit tedious, so you can omit them---but you'll still need to provide default values to the initializer. If you don't, the compiler will warn you that there's a problem. The initializer can throw if you provide invalid parameters, so you'll need to handle that.

```swift
let rings = [
    ProgressRing(color: fgColor1, backgroundColor: bgColor1),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2),
    ProgressRing(color: fgColor1, backgroundColor: bgColor1),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2),
    ProgressRing(color: fgColor1, backgroundColor: bgColor1),
    ProgressRing(color: fgColor2, backgroundColor: bgColor2),
]

let margin: CGFloat = 10
let radius: CGFloat = 120
let width: CGFloat = 8
let progressRingView = try? ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings, defaultColor: nil, defaultWidth: width)
```

Rings can have varying widths, colors, and background colors.

```swift
let rings = [
    ProgressRing(color: UIColor(.RGB(160, 255, 0)), backgroundColor: UIColor(.RGB(44, 66, 4)), width: 40),
    ProgressRing(color: UIColor(.RGB(255, 211, 0)), backgroundColor: UIColor(.RGB(85, 78, 0)), width: 20),
    ProgressRing(color: UIColor(.RGB(255, 28, 93))),
]
let progressRingView = try! ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings, defaultWidth: 30)
```

<img src="example3.png" width="267" />

#### Updating Progress

To animate a progress update, use `setProgress`.

```swift
ring.arcs[1].setProgress(0.5, duration: 2)
```

You can also use subscripts to access the individual arcs.

```swift
ring[1].setProgress(0.5, duration: 2)
```

If you just want to change the progress, just set the progress on the ring, and it'll change immediately.

```swift
ring[1].progress = 0.5
```

If you'd like to update multiple rings simulataneously, you can iterate over `ConcentricProgressRingView` since it conforms to `SequenceType`.

```swift
for ring in progressRingView {
    ring.progress = 0.5
}
```

## Requirements

## Installation

ConcentricProgressRingView is available through [CocoaPods][cocoapods-url]. To install
it, simply add the following line to your Podfile:

```ruby
pod "ConcentricProgressRingView"
```

## TODO

* [x] Swift 3
* [ ] Documentation
* [x] Tests

## Author

Dan Loewenherz, dan@lionheartsw.com

## License

ConcentricProgressRingView is available under the Apache 2.0 license. See the [LICENSE](LICENSE) file for more info.

<!-- Images -->

[ci-badge]: https://img.shields.io/travis/lionheart/ConcentricProgressRingView.svg?style=flat
[version-badge]: https://img.shields.io/cocoapods/v/ConcentricProgressRingView.svg?style=flat
[license-badge]: https://img.shields.io/cocoapods/l/ConcentricProgressRingView.svg?style=flat
[platform-badge]: https://img.shields.io/cocoapods/p/ConcentricProgressRingView.svg?style=flat
[downloads-badge]: https://img.shields.io/cocoapods/dt/ConcentricProgressRingView.svg?style=flat
[downloads-monthly-badge]: https://img.shields.io/cocoapods/dm/ConcentricProgressRingView.svg?style=flat
[swift-badge]: http://img.shields.io/badge/swift-4-blue.svg?style=flat

<!-- Links -->

[lionheart-url]: https://lionheartsw.com/
[cocoapods-url]: http://cocoapods.org
[cocoapods-repo-url]: http://cocoapods.org/pods/ConcentricProgressRingView
[appetize-url]: https://appetize.io/app/xw49k81xufbqkmwdhpebkpyn58?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3&deviceColor=black
[travis-repo-url]: https://travis-ci.org/lionheart/ConcentricProgressRingView
[swift-url]: https://swift.org

