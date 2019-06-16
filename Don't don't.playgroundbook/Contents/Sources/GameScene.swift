import SpriteKit
import PlaygroundSupport

public struct Task {
  let taskInstruction: String
  let expectedResponse: Int
  
}


public class GameScene: SKScene {
  
  //Time indicator
  var progressBarWireframe: SKSpriteNode?
  var progressBar: SKSpriteNode?
  
  //Time defaults
  var taskDuration = 3.0
  var minimumTaskDuration = 1.0
  
  //Display the current task to user
  var task: SKLabelNode?
  
  //Display currentScore
  var scoreLabel: SKLabelNode?
  
  //All colors used in Playground
  let greenColor = UIColor(red: 25/255, green: 255/255, blue: 161/255, alpha: 1)
  let redColor = UIColor(red: 239/255, green: 112/255, blue: 110/255, alpha: 1)
  let yellowColor = UIColor(red: 255/255, green: 211/255, blue: 0, alpha: 1)
  let greyColor = UIColor(red: 37/255, green: 33/255, blue: 34/255, alpha: 1)
  
  //Default tasks
  var task0: Task?
  var task1: Task?
  var task2: Task?
  var task3: Task?
  var task4: Task?
  var task5: Task?
  var task6: Task?
  var task7: Task?
  var task8: Task?
  var task9: Task?
  var task10: Task?
  var task11: Task?
  var taskEasterEgg: Task?
  
  //Arrays that store tasks
  var availableTasks: [Task?]?
  var customUserTasks:[Task?]?
  
  //Current player status
  var currentTask: Task?
  var currentScore = 0
  
  //Game sound
  var backgroundLoop = SKAudioNode(fileNamed: "backgroundLoop")

  public override func didMove(to view: SKView) {
    
    //Configure progress bar
    progressBarWireframe = childNode(withName: "progressBarWireframe") as? SKSpriteNode
    progressBar = childNode(withName: "progressBar") as? SKSpriteNode
    progressBarWireframe?.size = CGSize(width: view.frame.width, height: 20)
    progressBar?.size = CGSize(width: view.frame.width, height: 20)
    progressBarWireframe?.position = CGPoint(x: view.frame.minX, y: view.frame.height/2 - 10)
    progressBar?.position = CGPoint(x: view.frame.minX-progressBar!.frame.width, y: view.frame.height/2 - 10)
    
    
    
    //Setup available tasks
    task0 = Task(taskInstruction: "Swipe right", expectedResponse: 1)
    task1 = Task(taskInstruction: "Don't don't swipe right", expectedResponse: 1)
    
    task2 = Task(taskInstruction: "Swipe left", expectedResponse: 2)
    task3 = Task(taskInstruction: "Don't don't swipe left", expectedResponse: 2)
    
    task4 = Task(taskInstruction: "Swipe down", expectedResponse: 8)
    task5 = Task(taskInstruction: "Don't don't swipe down", expectedResponse: 8)
    
    task6 = Task(taskInstruction: "Swipe up", expectedResponse: 4)
    task7 = Task(taskInstruction: "Don't don't swipe up", expectedResponse: 4)
    
    task8 = Task(taskInstruction: "Don't swipe right", expectedResponse: -1)
    task9 = Task(taskInstruction: "Don't swipe left", expectedResponse: -2)
    task10 = Task(taskInstruction: "Don't swipe down", expectedResponse: -8)
    task11 = Task(taskInstruction: "Don't swipe up", expectedResponse: -4)
    
    taskEasterEgg = Task(taskInstruction: "Take me to WWDC", expectedResponse: -10)
    
    //Add default tasks to availableTasks
    availableTasks = [task0, task1, task2, task3, task4, task5, task6, task7, task8, task9, task10, task11]
    
    //If user has configurated any custom task on Page2, ignore default tasks
    if !customUserTasks!.isEmpty {
      availableTasks = []
      availableTasks?.append(contentsOf: customUserTasks as! [Task])
      availableTasks = availableTasks?.unique{$0!.taskInstruction ?? ""}
    }
    
    
    //Configure task node
    task = childNode(withName: "task") as? SKLabelNode
    
    //Configure score node
    scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
    scoreLabel?.text = "\(currentScore)"
    
    //Setup Gesture Recognizers
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe: )))
    leftSwipe.direction = .left
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe: )))
    rightSwipe.direction = .right
    let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe: )))
    upSwipe.direction = .up
    let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe: )))
    downSwipe.direction = .down
    
    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(rightSwipe)
    view.addGestureRecognizer(upSwipe)
    view.addGestureRecognizer(downSwipe)
    
    //Adjusts game music volume
    self.backgroundLoop.run(SKAction.changeVolume(to: 0.15, duration: 0))

    //Start the game
    self.newTask()

    
    //Setup audio with delay, to avoid bug that stoped SKTransition from working
    self.run(SKAction.wait(forDuration: 0.05)) {

      self.addChild(self.backgroundLoop)

    }
    
  }
  
  func newTask(){
    
    //Reset progress bar position
    progressBar?.position = CGPoint(x: self.view!.frame.minX-progressBar!.frame.width, y: view!.frame.height/2 - 10)
    
    //Setup new task
    if currentScore == 15{
      //Easter egg
      currentTask = taskEasterEgg
    } else {
      currentTask = availableTasks![Int.random(in: 0...availableTasks!.count-1)]
    }
    
    //Setup new current task to user
    task?.text = currentTask!.taskInstruction
    task?.alpha = 0
    task?.run(SKAction.moveTo(x: -185, duration: 0))
    task?.run(SKAction.moveTo(y: 131, duration: 0))
    task?.run(SKAction.fadeIn(withDuration: 0.1))
    self.backgroundColor = yellowColor
    
    //Animate progress bar
    progressBar?.run(SKAction.moveTo(x: progressBarWireframe!.position.x, duration: TimeInterval(taskDuration)), completion: {
      
      if self.currentTask!.expectedResponse > 0{
        //Time's up for the current task
        self.gameOver()
      } else{
        //Time's up but task didn't expect any user action
        self.handleCorrectTask()
      }
    })
  }
  
  @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
    
    print(swipe.direction.rawValue)
    progressBar?.removeAllActions()
    
    //Animate task according to gesture
    switch swipe.direction.rawValue {
      
    case 1: //right
      task?.run(SKAction.moveTo(x: 800, duration: 0.3))
      
    case 2: //left
      task?.run(SKAction.moveTo(x: -900, duration: 0.3))
      
    case 8: //down
      task?.run(SKAction.moveTo(y: -800, duration: 0.3))
      
    case 4: //up
      task?.run(SKAction.moveTo(y: 800, duration: 0.3))
      
    default:
      print("Unrecognized gesture")
      
    }
    
    //Verify is gesture was correct
    if currentTask!.expectedResponse > 0{
      if currentTask?.expectedResponse == Int(swipe.direction.rawValue){ //correct
        
        handleCorrectTask()
      } else{ //wrong
        
        handleWrongTask()
      }
    } else{
      if currentTask!.expectedResponse + Int(swipe.direction.rawValue) == 0{ //correct. numbers are inversed and sum equals 0.
        
        handleWrongTask()
        
      } else{ //wrong
        
        handleCorrectTask()
      }
    }
    
    
  }
  
  func handleCorrectTask(){
    
    //Color feedback
    self.backgroundColor = greenColor
    
    //Update Score
    currentScore += 1
    scoreLabel?.text = "\(currentScore)"
    
    //Setup next round with delay
    let wait = SKAction.wait(forDuration: 0.3)
    let block = SKAction.run(newTask)
    let sequence = SKAction.sequence([wait,block])
    
    //Increases difficulty
    if taskDuration >= minimumTaskDuration{
      taskDuration -= 0.1
    }
    
    run(sequence)
  }
  
  func handleWrongTask(){
    
    //Color feedback
    self.backgroundColor = redColor
    
    //Setup game over with delay
    let wait = SKAction.wait(forDuration: 0.3)
    let block = SKAction.run(gameOver)
    let sequence = SKAction.sequence([wait,block])
    
    run(sequence)
  }
  
  //Ends game and passes user generated tasks and final score to next scene
  func gameOver(){
    
    let gameOverScene = GameOver(fileNamed: "GameOver")
    gameOverScene?.finalScore = currentScore
    
    gameOverScene?.customUserTasks = customUserTasks
    
    let transition = SKTransition.fade(with: redColor, duration: 0.1)
    self.view?.presentScene(gameOverScene!, transition: transition)
  }
  
  //Add user generated tasks to array
  public func handleCustomTask(newTask: Task){
    
    customUserTasks?.append(newTask)
  }
  
  //Resets current user tasks after a new code run
  public func clearCustomTasks(){
    
    customUserTasks = []
  }
}
