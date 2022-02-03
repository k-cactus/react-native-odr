# React Native iOS ODR integration

## Getting started

If you are using react-native >= 0.60 you just need to do a simple:

```shell
$ yarn add react-native-odr
```

Or if are using npm:

```shell
$ npm install react-native-odr --save
```

Now run a simple: npx pod-install or cd ios && pod install. After that, you should be able to use the library on ios platform.

## Usage

```js
import { download, OdrOptions } from 'react-native-odr';
...
const options: OdrOptions = {
  packageName: 'TestPackageName',
  packageType: 'md', // extension
};

download(options)
  .then((filePath) => console.log(filePath))
  .catch((e) => console.log(e));

```

## Example

See [iOS ODR example project](https://github.com/k-cactus/react-native-odr/tree/main/example 'iOS ODR example project')

## Documentation

[On-Demand Resources Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//apple_ref/doc/uid/TP40015083-CH2-SW1 'On-Demand Resources Guide')
