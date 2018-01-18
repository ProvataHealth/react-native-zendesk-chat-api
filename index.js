import { NativeModules } from 'react-native';
const { RNZendeskChatApi } = NativeModules;

export { default as ZendeskClient } from './ZendeskClient';
export default RNZendeskChatApi;

