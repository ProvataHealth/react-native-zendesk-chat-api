
# NOT CURRENTLY MAINTAINED
I was pulled off working on this and have not had time to finalize it for community use.
That said to get it working you will need to add `RNZDCChatAPIModule.h` `RNZDCChatAPIModule.m` and `Util.h` and `Util.m` into your ios project
Then you can use `ZendeskClient` in your javascript.


# react-native-zendesk-chat-api


## Usage
```javascript
import { ZendeskClient } from 'react-native-zendesk-chat-api';

class MyChatComponent extends Component {
    ...
    componentDidMount() {
        this._client = new ZendeskClient({
            accountKey: 'your_account_key',
            userInfo: {
                name: user.getFullName(),
                email: user.getEmail()
            },
            onConnect: this.handleConnect,
            onDisconnect: this.handleDisconnect,
            onChatEvent: this.handleChatEvent,
            onAgentEvent: this.handleAgentEvent
        });
    }
    
    startChat() {
        this._client.startChat();
    }
    
    onConnect() {
        this.setState({ connected: true });
    }
    
    onDisconnect() {
        this.setState({ connected: false });
    }
    
    onChatEvent(event) {
        this.setState({ messages: this.state.messages.addMessage(event.message)})
    }
    
    ...
}
```

You can also use `RNZendeskChatApi` alone if you want to deal directly with the Native Module
  