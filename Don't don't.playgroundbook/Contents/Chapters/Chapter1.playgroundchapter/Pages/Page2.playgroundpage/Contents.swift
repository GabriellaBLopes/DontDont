//#-hidden-code

import PlaygroundSupport

public enum ExpectedResponse: Int {
  
  case right = 1
  case left = 2
  case up = 4
  case down = 8
  case notRight = -1
  case notLeft = -2
  case notUp = -4
  case notDown = -8
  
}

public func sendProxy(_ pv : PlaygroundValue){
  
  let page = PlaygroundPage.current
  if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
    proxy.send(pv)
  }
}

public func addTask(taskInstruction:String, expectedResponse:ExpectedResponse) {
  
  sendProxy(PlaygroundValue.dictionary([
    "taskInstruction":.string(taskInstruction),
    "expectedResponse": .integer(expectedResponse.rawValue)
    ]))
}

//#-end-hidden-code

/*:
 
 ## How did you do?
 I hope you got the chance to score at least 15 points and see the neat easter egg I implemented. 🤓
 
 ## Wondering how the game works?
 Anytime you were presented with instructions such as "Swipe right", some
 `UISwipeGestureRecognizer` instances looked for swiping in all four directions.
 
 The instruction you saw onscreen was only one of the two properties of the `Task` struct I created. The other property for each task was the expected user response for each instruction.
 
 When the `Task`’s expected user response and the actual swiping you performed matched, you scored!
 
 ## Go nuts! 🥜
 Now that you understand how the `Task` struct works, you can add your own unique challenges to the game! I’ve added a few examples below, but feel free to create new ones and challenge your friends!
 
 */
//#-code-completion(keyword, hide)
//#-editable-code
addTask(taskInstruction:"Fly little birdie", expectedResponse: .up)

addTask(taskInstruction:"Slide to unlock", expectedResponse: .right)

addTask(taskInstruction:"Don't let me down", expectedResponse: .notDown)

//#-end-editable-code

/*:
 
 When you're done adding new tasks, don't forget to tap on **Run My Code**.
 */
