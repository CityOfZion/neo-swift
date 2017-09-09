# SwiftBaseX

Base encoding / decoding of any given alphabet using bitcoin style leading zero compression.

This is an rewrite of the multi base codec library [base-x](https://github.com/cryptocoinjs/base-x) from javascript to Swift.

## Installation

### Carthage

Add the following to your `Cartfile`

```ruby
github "uport-project/SwiftBaseX"
```

## Usage

To encode a `Data` object we include the `hexEncodedString()` and `base58EncodedString()` methods as an extension

```swift
import SwiftBaseX

let data: Data = ....
let encoded:String = data.hexEncodedString()
```

For cases where you need a full hex string without leading zero compression we've also included the following variation.

```swift
let encoded:String = data.fullHexEncodedString()
```

Hex strings are commonly prefixed with `0x` in the crypto world. `0x` prefixes are automatically stripped when decoding. To automatically add `0x` during hex encoding pass in `true` to either `hexEncodedString()` or `fullHexEncodedString()`.

For `String` we include the `decodeHex()` and `decodeBase58()` methods as an extension.

```swift
import SwiftBaseX

let decoded: Data = "Cn8eVZg".decodeBase58()
```
For cases where you need to decode a full hex string without leading zero compression we've also included the following variation.

```swift
let encoded:String = data.decodeFullHex()
```

