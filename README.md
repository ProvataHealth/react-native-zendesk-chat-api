
# react-native-zendesk-chat-api

## Getting started

`$ npm install react-native-zendesk-chat-api --save`

### Mostly automatic installation

`$ react-native link react-native-zendesk-chat-api`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-zendesk-chat-api` and add `RNZendeskChatApi.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNZendeskChatApi.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNZendeskChatApiPackage;` to the imports at the top of the file
  - Add `new RNZendeskChatApiPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-zendesk-chat-api'
  	project(':react-native-zendesk-chat-api').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-zendesk-chat-api/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-zendesk-chat-api')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNZendeskChatApi.sln` in `node_modules/react-native-zendesk-chat-api/windows/RNZendeskChatApi.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Zendesk.Chat.Api.RNZendeskChatApi;` to the usings at the top of the file
  - Add `new RNZendeskChatApiPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNZendeskChatApi from 'react-native-zendesk-chat-api';

// TODO: What to do with the module?
RNZendeskChatApi;
```
  