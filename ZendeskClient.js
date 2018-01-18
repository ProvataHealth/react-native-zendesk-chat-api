import { NativeEventEmitter, NativeModules } from 'react-native';
const { RNZendeskChatApi } = NativeModules;


class ZendeskClient {

    constructor(config) {
        this._onConnect = config.onConnect;
        this._onDisconnect = config.onDisconnect;
        this._onConnectionEvent = config.onConnectionEvent;
        this._onChatEvent = config.onChatEvent;
        // TODO implement all events
        // see https://developer.zendesk.com/embeddables/docs/ios-chat-sdk/sessionapi for events
        this._onAgentEvent = config.onAgentEvent;
        RNZendeskChatApi.init({ accountKey: config.accountKey, userInfo: config.userInfo });
    }

    _active = false;
    _eventEmitter;
    _eventListeners = new Map();

    connected = false;

    startChat() {
        if (!this._active) {
            this._active = true;
            this._addListeners();
            RNZendeskChatApi.startChat();
        }
    }

    endChat() {
        this._removeListeners();
        RNZendeskChatApi.endChat();
    }

    sendMessage(message) {
        if (this.connected) {
            RNZendeskChatApi.sendMessage(message);
        }
    }

    _handleConnectionEvents(eventName) {
        if (!this._active) {
            return;
        }
        this._onConnectionEvent && this._onConnectionEvent(eventName);
        if (this._onConnect || this._onDisconnect) {
            switch (eventName) {
                // simplify the Zendesk API connection events for basic usage
                // a more robust UI would want more granular updates
                case  RNZendeskChatApi.connectionStatusConnected:
                    this.connected = true;
                    this._onConnect && this._onConnect();
                    break;
                case RNZendeskChatApi.connectionStatusClosed:
                case RNZendeskChatApi.connectionStatusDisconnected:
                case RNZendeskChatApi.connectionStatusUninitialized:
                case RNZendeskChatApi.connectionStatusConnecting:
                case RNZendeskChatApi.connectionStatusNoConnection:
                    if (this.connected) {
                        this._onDisconnect && this._onDisconnect();
                        this.connected = false;
                        this._active = false;
                    }
            }
        }
    }

    _handleChatEvents(event) {
        if (!this._active) {
            return;
        }
        this._onChatEvent && this._onChatEvent(event);
    }

    _handleAgentEvents(event) {
        if (!this._active) {
            return;
        }
        this._onAgentEvent && this._onAgentEvent(event);
    }

    _addListeners() {
        if (!this._eventEmitter) {
            this._eventEmitter = new NativeEventEmitter(RNZendeskChatApi);
        }
        const applyHandlerForEvents = (eventName, handler) => {
            if (this._eventListeners[eventName]) {
                this._eventListeners[eventName].remove()
            }
            this._eventListeners[eventName] = this._eventEmitter.addListener(eventName, handler);
        };
        applyHandlerForEvents(RNZendeskChatApi.connectionUpdate, (evt) => this._handleConnectionEvents(evt));
        applyHandlerForEvents(RNZendeskChatApi.chatUpdate, (evt) => this._handleChatEvents(evt));
        applyHandlerForEvents(RNZendeskChatApi.agentUpdate, (evt) => this._handleAgentEvents(evt));
    }

    _removeListeners() {
        this._eventListeners.forEach((listener) => listener.remove());
        this._eventListeners = new Map();
    }
}

export default ZendeskClient;