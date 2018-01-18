using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Zendesk.Chat.Api.RNZendeskChatApi
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNZendeskChatApiModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNZendeskChatApiModule"/>.
        /// </summary>
        internal RNZendeskChatApiModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNZendeskChatApi";
            }
        }
    }
}
