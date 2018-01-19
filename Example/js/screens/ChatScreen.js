import React, { Component } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, TextInput, ScrollView } from 'react-native';


class ChatScreen extends Component {

    constructor(props) {
        super(props);
        this.onConnect = this.onConnect.bind(this);
        this.onDisconnect = this.onDisconnect.bind(this);
        this.onMessage = this.onMessage.bind(this);
        this.toggleChat = this.toggleChat.bind(this);
        this.connectToChat = this.connectToChat.bind(this);
        this.updateMessageText = this.updateMessageText.bind(this);
        this.sendMessage = this.sendMessage.bind(this);
        this.setInputRef = this.setInputRef.bind(this);
        this.state = {
            connected: false
        };
    }

    componentDidMount() {
        this.client = new ZendeskClient({
            accountKey: 'SEPvDUVGvKrsVylSMoHTHcNVJkhcW7ve',
            userInfo: {
                name: 'iOS User',
                email: 'andrew.grewell@provatahealth.com'
            },
            onConnect: this.onConnect,
            onDisconnect: this.onDisconnect
        });
    }

    componentWillUnmount() {
        this.client.endChat();
    }

    onConnect() {
        console.log('Zendesk Chat Connected');
        this.setState({ connected: true });
    }

    onDisconnect() {
        console.log('Zendesk Chat Disconnect');
        this.setState({ connected: false });
    }

    onMessage(message) {
        console.log('Zendesk Chat Message: ', message);
    }

    toggleChat() {
        if (this.state.connected) {
            this.client.endChat();
        }
        else {
            this.client.startChat();
        }
    }

    connectToChat() {
        this.client.startChat();
    }

    updateMessageText(messageText) {
        this.setState({ messageText });
    }

    sendMessage() {
        let message = this.state.messageText && this.state.messageText.trim();
        if (this.state.connected && message && message.length) {
            console.log('Send message: ', message);
            this.inputRef.clear();
            this.setState({ messageText: '' });
            this.client.sendMessage(message);
        }
    }

    setInputRef(component) {
        this.inputRef = component;
    }

    render() {
        return (
            <View style={styles.container}>
                <Button onPress={this.toggleChat}>
                    {this.state.connected ? 'End Chat' : 'Start Chat' }
                </Button>
                <ChatLog/>
                <ChatMessageInput inputRef={this.setInputRef}
                                  updateMessageText={this.updateMessageText}
                                  sendMessage={this.sendMessage}/>
            </View>
        );
    }
}

const ChatLog = (props) => (
    <View style={styles.chatLogContainer}>
        <ScrollView>
            <Text>ChatLog</Text>
        </ScrollView>
    </View>
);

const ChatMessageInput = ({ inputRef, sendMessage, updateMessageText }) => (
    <View style={styles.messageInputContainer}>
        <TextInput style={styles.messageInput}
                   blurOnSubmit
                   onChangeText={updateMessageText}
                   ref={inputRef}/>
        <Button style={styles.messageButton} onPress={sendMessage}>
            Send
        </Button>
    </View>
);

const Button = ({ onPress, children, style }) => (
    <TouchableOpacity onPress={onPress}>
        <View style={[styles.connectButton, style]}>
            <Text style={styles.lightText}>
                {children}
            </Text>
        </View>
    </TouchableOpacity>
);


const BLUE = 'rgb(23, 167, 224)';

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center'
    },
    connectButton: {
        maxWidth: 200,
        marginVertical: 20,
        alignItems: 'center',
        backgroundColor: BLUE,
        paddingVertical: 15,
        paddingHorizontal: 25,
        borderRadius: 5
    },
    chatLogContainer: {
        flex: 1,
        alignSelf: 'stretch',
        padding: 10,
        borderTopColor: BLUE,
        borderTopWidth: 1,
        backgroundColor: 'white'
    },
    lightText: {
        color: 'white',
        fontWeight: 'bold'
    },
    messageInputContainer: {
        backgroundColor: 'rgba(233, 233, 233, 0.5)',
        borderTopColor: BLUE,
        borderTopWidth: 1,
        alignSelf: 'stretch',
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 20
    },
    messageInput: {
        backgroundColor: 'white',
        flex: 1,
        minHeight: 50,
        paddingHorizontal: 10,
        paddingVertical: 15,
        borderRadius: 5,
        marginRight: 20
    },
    messageButton: {
        alignSelf: 'flex-end'
    }
});


export default ChatScreen;