//
//  CallManager.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/07.
//

import Foundation
import CallKit

class CallManager {
  var callsChangedHandler: (() -> Void)?
  private let callController = CXCallController()

  private(set) var calls: [Call] = []

  func callWithUUID(uuid: UUID) -> Call? {
    guard let index = calls.index(where: { $0.uuid == uuid }) else {
      return nil
    }
    return calls[index]
  }
  
  func add(call: Call) {
    calls.append(call)
    call.stateChanged = { [weak self] in
      guard let self = self else { return }
      self.callsChangedHandler?()
    }
    callsChangedHandler?()
  }
  
  func remove(call: Call) {
    guard let index = calls.index(where: { $0 === call }) else { return }
    calls.remove(at: index)
    callsChangedHandler?()
  }
  
  func removeAllCalls() {
    calls.removeAll()
    callsChangedHandler?()
  }
  
  func end(call: Call) {
    // 1.
    let endCallAction = CXEndCallAction(call: call.uuid)
    // 2.
    let transaction = CXTransaction(action: endCallAction)
    
    requestTransaction(transaction)
  }

  // 3.
  private func requestTransaction(_ transaction: CXTransaction) {
    callController.request(transaction) { error in
      if let error = error {
        print("Error requesting transaction: \(error)")
      } else {
        print("Requested transaction successfully")
      }
    }
  }
  
  func setHeld(call: Call, onHold: Bool) {
    let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
    let transaction = CXTransaction()
    transaction.addAction(setHeldCallAction)
    
    requestTransaction(transaction)
  }
  
  func startCall(handle: String, videoEnabled: Bool) {
    // 1
    let handle = CXHandle(type: .phoneNumber, value: handle)
    // 2
    let startCallAction = CXStartCallAction(call: UUID(), handle: handle)
    // 3
    startCallAction.isVideo = videoEnabled
    let transaction = CXTransaction(action: startCallAction)
    
    requestTransaction(transaction)
  }
}

