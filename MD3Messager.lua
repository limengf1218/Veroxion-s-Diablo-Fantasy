MD3Messager = {};
self = MD3Messager;

MD3MessageTypes = {
    OrbEditorOrbDataSelectionChanged = 1,
    OrbEditorFillSelectionChanged = 2,
    OrbDataModelUpdated = 3,
    FillDataModelUpdated = 4,
    AnimationDataModelUpdated = 5,
    ValueLabelDataModelUpdated = 6,
    ColorDataModelUpdated = 7,
    OrbViewerOrbDataSet = 8,
    FillAnimationTextureSelectionChanged = 9,
    FillAnimationTextureDataSelectionChanged = 10,
    FillAnimationTextureDataSelectionUpdated = 11,
    SavePreviewedChangesRequested = 12,
    OrbDataSwapAndSaveRequested = 13,
    OrbViewerActiveOrbViewModelChanged = 14,
    FontSelectionChanged = 15,
    OffsetValueChanged = 16,
    ValueLabelSelectionChanged = 17,
    TriggerSelectionChanged = 18,
    TriggerArgumentSelectionChanged = 19;
};

self.Subscriptions = {};
self.isReadyToSendMessages = false;
self.preReadyMessageQueue = { };

function self:Subscribe(messageType, callback)
    if(messageType == nil or callback == nil) then
        print("Unable to route message.  Either messageType or callback were nil.");
        return;
    end
    if(self.Subscriptions[messageType] == nil) then
        self.Subscriptions[messageType] = {};
    end
    --generate identifiers for the message callback 
    --also means the same function can't subscribe to a message twice, which shouldn't be too big of a problem.
    --we could handle this by incrementing the SUID if there's more than one occurrance, but...I'm lazy.
    local tableId = MD3Utils:GetTableUID(self.Subscriptions[messageType]);
    local callbackId = MD3Utils:GetTableUID(callback);
    local subscriptionUniqueId = tableId .. "_" .. callbackId;
    self.Subscriptions[messageType][subscriptionUniqueId] = callback;
    
    return subscriptionUniqueId;
end

function self:Unsubscribe(messageType, id)
    if(self.Subscriptions[messageType] == nil) then
        return;
    end

    if(self.Subscriptions[messageType][id] ~= nil) then
        self.Subscriptions[messageType][id] = nil;
    end
end

function self:SendMessage(messageType, context)
    --store these in a queue if we're not ready to send messages
    if(not self.isReadyToSendMessages) then
        table.insert(self.preReadyMessageQueue, {
            messageType,
            context
        });
    end
    if(self.Subscriptions[messageType] == nil) then
        return;
    end

    MD3Utils:ForEachSortedElementDo(self.Subscriptions[messageType], function(key, callback)
        callback(context);
    end);
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent(MD3Constants.Events.AddonLoaded)
function eventFrame:OnEvent(event, argument1)
    --when everything is done loading, hide the UI Root.
    if event == MD3Constants.Events.AddonLoaded then
        if(not MD3Messager.isReadyToSendMessages) then
            MD3Utils:ForEachSortedElementDo(MD3Utils.preReadyMessageQueue, function(_, messageItem)
                self:SendMessage(messageItem.messageType, messageItem.context);
            end);
            MD3Messager.preReadyMessageQueue = { };
            MD3Messager.isReadyToSendMessages = true;
            eventFrame:UnregisterEvent(MD3Constants.Events.AddonLoaded);
        end
    end
end