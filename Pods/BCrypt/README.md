# BCrypt

[![Version](https://img.shields.io/cocoapods/v/BCrypt.svg?style=flat)](https://cocoapods.org/pods/BCrypt)
[![License](https://img.shields.io/cocoapods/l/BCrypt.svg?style=flat)](https://github.com/aberkunov/PerfectBCrypt/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/BCrypt.svg?style=flat)](https://cocoapods.org/pods/BCrypt)

This is the Perfect-BCrypt module written in Swift and adopted to use in iOS as a CocoaPod dependency. The original module is being used in the Perfect Toolkit, see [PerfectSideRepos/PerfectBCrypt](https://github.com/PerfectSideRepos/PerfectBCrypt) for more details 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```swift
import BCrypt

let password = "mypassword"
do {
    let salt = try BCrypt.Salt()
    let hashed = try BCrypt.Hash(password, salt: salt)
    print("Hashed result is: \(hashed)")
}
catch {
    print("An error occured: \(error)")
}
```

## Requirements

- iOS 10.0+
- Xcode 10.1+
- Swift 4.2+

## Installation

BCrypt is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BCrypt'
```

## Author

Alexander Berkunov, alexander.berkunov@gmail.com

## License

BCrypt is available under the MIT license. See the [LICENSE file](https://github.com/aberkunov/PerfectBCrypt/blob/master/LICENSE) for more info.
