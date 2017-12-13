
# react-native-gps-location

## Getting started

`$ npm install react-native-gps-location --save`

### Mostly automatic installation

`$ react-native link react-native-gps-location`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-gps-location` and add `RNGpsLocation.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNGpsLocation.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNGpsLocationPackage;` to the imports at the top of the file
  - Add `new RNGpsLocationPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-gps-location'
  	project(':react-native-gps-location').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-gps-location/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-gps-location')
  	```


## Usage
```javascript
import RNGpsLocation from 'react-native-gps-location';

// TODO: What to do with the module?
RNGpsLocation;
```
  