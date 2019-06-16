import PlaygroundSupport
import SpriteKit
import Foundation

public class WaitingCustom: SKScene {
  
  var swipeIndicator: SKShapeNode?
  var mainLabel: SKLabelNode?
  var customizedTasks = false
  
  var customUserTasks: [Task?]?  = []
  
  public override func didMove(to view: SKView) {
    
    //Configure mainLabel node
    mainLabel = childNode(withName: "mainLabel") as? SKLabelNode
    
    //Add gesture recognizer
    let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe: )))
    swipeRight.direction = .right
    view.addGestureRecognizer(swipeRight)
    
    //Setups indication that a swipe is required to play
    let swipeIndicatorPlaceholder = childNode(withName: "swipeIndicatorPlaceholder") as? SKNode
    
    swipeIndicator = SKShapeNode(circleOfRadius: 20)
    swipeIndicator?.fillColor = .white
    swipeIndicator?.alpha = 0
    swipeIndicator?.position = swipeIndicatorPlaceholder!.position
    addChild(swipeIndicator!)
    
  }
  
  func readyToPlay(){
    
    mainLabel?.text = "Swipe right when ready"
    
    swipeIndicator!.run(SKAction.fadeAlpha(to: 0.6, duration: 0.2))
    
    //Swipe indicator animation starts
    let swipeIndicatorAnimationsGroup = SKAction.group([SKAction.moveBy(x: 190, y: 0, duration: 1), SKAction.fadeOut(withDuration: 0.8)])
    swipeIndicator?.run(SKAction.repeatForever(SKAction.sequence([swipeIndicatorAnimationsGroup, SKAction.wait(forDuration: 1.5), SKAction.moveTo(x: -145.316, duration: 0),SKAction.fadeAlpha(to: 0.6, duration: 0.2)])))
  }
  
  //Begins game if user has generated tasks. Passes them to next scene.
  @objc func swipeAction(swipe: UISwipeGestureRecognizer){
    
    if customizedTasks{
      
      let scene1 = GameScene(fileNamed:"GameScene")
      
      scene1?.customUserTasks = customUserTasks
      
      let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.2)
      
      self.scene!.view?.presentScene(scene1!, transition: transition)
    }
  }
  
  //Add user generated tasks to array
  public func handleCustomTask(newTask: Task){
    
    customUserTasks?.append(newTask)
    customizedTasks = true
    readyToPlay()
  }
  
  //Resets current user tasks after a new code run
  public func clearCustomTasks(){
    
    customUserTasks = []
  }
  
}
