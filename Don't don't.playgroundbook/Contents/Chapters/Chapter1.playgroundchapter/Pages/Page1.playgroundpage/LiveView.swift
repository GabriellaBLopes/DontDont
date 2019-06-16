import UIKit
import PlaygroundSupport
import SpriteKit


let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 320, height: 480))

let myScene = FirstScene(fileNamed: "FirstScene")

// Present the scene
sceneView.presentScene(myScene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

