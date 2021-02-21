//
//  ProviderDelegate.swift
//  MHCare
//
//  Created by 허진욱 on 2021/02/07.
//

import AVFoundation
import CallKit

class ProviderDelegate: NSObject {
    // 1.
    private let callManager: CallManager
    private let provider: CXProvider
  
    init(callManager: CallManager) {
        self.callManager = callManager
        // 2.
        provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
    
        super.init()
        // 3.
        provider.setDelegate(self, queue: nil)
    }
  
    // 4.
    static var providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
    
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
    
        return providerConfiguration
    }()
    
    func reportIncomingCall(
        uuid: UUID,
        handle: String,
        hasVideo: Bool = false,
        completion: ((Error?) -> Void)?
        ) {
        // 1.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
      
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                // 3.
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.add(call: call)
            }
        
            // 4.
            completion?(error)
        }
    }
}

// MARK: - CXProviderDelegate
extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        stopAudio()
    
        for call in callManager.calls {
            call.end()
        }
    
        callManager.removeAllCalls()
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // 1.
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // 2.
        configureAudioSession()
        // 3.
        call.answer()
        // 4.
        action.fulfill()
    }
    
    // 5.
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        startAudio()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // 1.
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // 2.
        stopAudio()
        // 3.
        call.end()
        // 4.
        action.fulfill()
        // 5.
        callManager.remove(call: call)
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
      
        // 1.
        call.state = action.isOnHold ? .held : .active
      
        // 2.
        if call.state == .held {
            stopAudio()
        } else {
            startAudio()
        }
      
        // 3.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call(uuid: action.callUUID, outgoing: true,
                        handle: action.handle.value)
        // 1.
        configureAudioSession()
        // 2.
        call.connectedStateChanged = { [weak self, weak call] in
            guard
                let self = self,
                let call = call
            else {
                return
            }

            if call.connectedState == .pending {
                self.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
            } else if call.connectedState == .complete {
                self.provider.reportOutgoingCall(with: call.uuid, connectedAt: nil)
            }
        }
        // 3.
        call.start { [weak self, weak call] success in
            guard
                let self = self,
                let call = call
            else {
                return
            }

            if success {
                action.fulfill()
                self.callManager.add(call: call)
            } else {
                action.fail()
            }
        }
    }
}
