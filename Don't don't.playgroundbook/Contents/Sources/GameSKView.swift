import Foundation
import PlaygroundSupport
import SpriteKit

@objc(GameSKView)
public class GameSKView:SKView{
  
  public var myScene: WaitingCustom?
  
  public override init(frame:CGRect){
    
    super.init(frame:frame)
    
    myScene = WaitingCustom(fileNamed: "WaitingCustom")
    
    // Present the scene
    self.presentScene(myScene)
    
    //Setup view
    self.ignoresSiblingOrder = true
    self.showsFPS = false
    self.showsNodeCount = false
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

extension GameSKView: PlaygroundLiveViewMessageHandler {
  
  //Called after a new code run
  public func liveViewMessageConnectionOpened() {
    
    //Casts current scene and make it clear all custom tasks created so far. This way, I'm sure a deleted task won't keep showing up.
    if self.scene is WaitingCustom {
      
      let castedScene =  self.scene as! WaitingCustom
      castedScene.clearCustomTasks()
      
    } else if self.scene is GameScene {
      
      let castedScene =  self.scene as! GameScene
      castedScene.clearCustomTasks()
      
    } else if self.scene is FirstScene {
      
      let castedScene = self.scene as! FirstScene
      castedScene.clearCustomTasks()
      
    } else if self.scene is GameOver {
      
      let castedScene =  self.scene as! GameOver
      castedScene.clearCustomTasks()
    }
  }
  
  ///Send message to contents
  public func sendMessage(_ msg: String){
    let pv : PlaygroundValue = .string(msg)
    send(pv)
  }
  
  ///Receive and handle messagens from Contents
  public func receive(_ message: PlaygroundValue) {
    guard let taskInstruction = message.stringFromDict(withKey: "taskInstruction") else { return }
    
    //Creates new task based on user customization and delivers it to current (casted) scene.
    let newTask = Task(taskInstruction: taskInstruction, expectedResponse: message.integerFromDict(withKey:"expectedResponse")!)
    
    if self.scene is WaitingCustom {
      
      let castedScene =  self.scene as! WaitingCustom
      castedScene.handleCustomTask(newTask: newTask)
      
    } else if self.scene is GameScene {
      
      let castedScene =  self.scene as! GameScene
      castedScene.handleCustomTask(newTask: newTask)
      
    } else if self.scene is FirstScene {
      
      let castedScene = self.scene as! FirstScene
      castedScene.handleCustomTask(newTask: newTask)
      
    } else if self.scene is GameOver {
      
      let castedScene =  self.scene as! GameOver
      castedScene.handleCustomTask(newTask: newTask)
    }
    
  }
}


