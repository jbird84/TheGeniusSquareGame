//
//  GameScene.swift
//  SwiftUIWithSpriteKit
//
//  Created by Kinney Kare on 11/17/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    enum GameState: String {
        case Playing = "Playing"
        case GameOver = "GameOver"
    }
    
    var gameState: GameState = .Playing
    var background = SKSpriteNode(imageNamed: K.ImageName.picnic)
    var gameBoard = SKSpriteNode(imageNamed: K.ImageName.gameBoard)
    var touchingPlayer = false
    
    var blockArray: [Block] = []
    var diceArray: [SKSpriteNode] = []
    var selectedBlock = SKSpriteNode()
    
    //blocks
    let oneBlock = Block(imageNamed: K.ImageName.oneBlock)
    let vBlock = Block(imageNamed: K.ImageName.vBlock)
    let lBlock = Block(imageNamed: K.ImageName.lBlock)
    
    //Dice Images
    let diceOne = [K.DieValue.b4, K.DieValue.c3, K.DieValue.c4, K.DieValue.d4, K.DieValue.d3, K.DieValue.e3]
    let diceTwo = [K.DieValue.a6, K.DieValue.f1]
    let diceThree = [K.DieValue.a5, K.DieValue.b6, K.DieValue.f2, K.DieValue.e1]
    let diceFour = [K.DieValue.d5, K.DieValue.e5, K.DieValue.e6, K.DieValue.e4, K.DieValue.f4, K.DieValue.f5]
    let diceFive = [K.DieValue.a4, K.DieValue.b5, K.DieValue.c5, K.DieValue.c6, K.DieValue.d6, K.DieValue.f6]
    let diceSix = [K.DieValue.c1, K.DieValue.f3, K.DieValue.a1, K.DieValue.e2, K.DieValue.d2, K.DieValue.d1]
    let diceSeven = [K.DieValue.b3, K.DieValue.a2, K.DieValue.a3, K.DieValue.b1, K.DieValue.b2, K.DieValue.c2]
    
    
    //Method that auto executes like viewDidAppear is called didMove
    override func didMove(to view: SKView) {
        setupBackgroundAndGameBoard(view: view)
        setupBlocks()
        setupDice()
        gameState = .Playing
        setupWoodBlockers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
        //Mark: pull out the first touch that happened.
        guard let touch = touches.first else { return }
        //Mark: get current location of the node touched first
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for block in blockArray {
            if tappedNodes.contains(block) {
                selectedBlock = block
                touchingPlayer = true
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchingPlayer else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        selectedBlock.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
        touchingPlayer = false
        selectedBlock = SKSpriteNode()
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max:CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    private func setupBackgroundAndGameBoard(view: SKView) {
       //This will create and setup background
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.size = view.frame.size
        background.alpha = 0.3
        background.zPosition = -1
        addChild(background)
        
        //This will create and setup gameboard
        gameBoard.size = CGSize(width: 250, height: 250)
        gameBoard.position = (scene?.view!.center)!
        addChild(gameBoard)
    }
    
    private func setupBlocks() {
        let x = gameBoard.position.x - 170
        
        //1Block
        oneBlock.position = CGPoint(x: x - 10, y: 510)
        blockArray.append(oneBlock)
        
        //vBlock
        vBlock.position = CGPoint(x: x, y: oneBlock.position.y - 100)
        blockArray.append(vBlock)
        
        //lBlock
        lBlock.position = CGPoint(x: x - 20, y: vBlock.position.y - 120)
        blockArray.append(lBlock)
        
        //tBlock
        let tBlock = Block(imageNamed: K.ImageName.tBlock)
        tBlock.position = CGPoint(x: lBlock.position.x - 70, y: 240)
        blockArray.append(tBlock)
        
        //oBlock
        let oBlock = Block(imageNamed: K.ImageName.oBlock)
        oBlock.position = CGPoint(x: lBlock.position.x - 70, y: tBlock.position.y + 120)
        blockArray.append(oBlock)
        
        //4Block
        let fourBlock = Block(imageNamed: K.ImageName.fourBlock)
        fourBlock.position = CGPoint(x: lBlock.position.x - 70, y: oBlock.position.y + 120)
        blockArray.append(fourBlock)
        
        //zBlock
        let zBlock = Block(imageNamed: K.ImageName.zBlock)
        zBlock.position = CGPoint(x: tBlock.position.x - 80, y: 280)
        blockArray.append(zBlock)
        
        //2Block
        let twoBlock = Block(imageNamed: K.ImageName.twoBlock)
        twoBlock.position = CGPoint(x: tBlock.position.x - 80, y: zBlock.position.y + 90)
        blockArray.append(twoBlock)
        
        //3Block
        let threeBlock = Block(imageNamed: K.ImageName.threeBlock)
        threeBlock.position = CGPoint(x: tBlock.position.x - 80, y: twoBlock.position.y + 120)
        blockArray.append(threeBlock)
        
        for block in blockArray {
            block.size = CGSize(width: 300, height: 300)
            block.zPosition = 0
            addChild(block)
        }
    }
    
    private func setupDice() {
        let x = gameBoard.position.x + 170
        guard
                let dieOneImage = diceOne.randomElement(),
                let dieTwoImage = diceTwo.randomElement(),
                let dieThreeImage = diceThree.randomElement(),
                let dieFourImage = diceFour.randomElement(),
                let dieFiveImage = diceFive.randomElement(),
                let dieSixImage = diceSix.randomElement(),
                let dieSevenImage = diceSeven.randomElement()
        else { return }
        
        //Die 1 -> can be B4,C3,C4,D4,D3,E3
        let dieOne = SKSpriteNode(imageNamed: dieOneImage)
        dieOne.accessibilityLabel = dieOneImage
        dieOne.position = CGPoint(x: x, y: gameBoard.position.y + 120)
        diceArray.append(dieOne)
        
        //Die 2 -> can be A6,F1
        let dieTwo = SKSpriteNode(imageNamed: dieTwoImage)
        dieTwo.accessibilityLabel = dieTwoImage
        dieTwo.position = CGPoint(x: x, y: dieOne.position.y - 40)
        diceArray.append(dieTwo)
        
        //Die 3 -> can be A5,B6,F2,E1
        let dieThree = SKSpriteNode(imageNamed: dieThreeImage)
        dieThree.accessibilityLabel = dieThreeImage
        dieThree.position = CGPoint(x: x, y: dieTwo.position.y - 40)
        diceArray.append(dieThree)
        
        //Die 4 -> can be D5,E5,E6,E4,F4,F5
        let dieFour = SKSpriteNode(imageNamed: dieFourImage)
        dieFour.accessibilityLabel = dieFourImage
        dieFour.position = CGPoint(x: x, y: dieThree.position.y - 40)
        diceArray.append(dieFour)
        
        //Die 5 -> can be B4,C3,C4,D4,D3,E3
        let dieFive = SKSpriteNode(imageNamed: dieFiveImage)
        dieFive.accessibilityLabel = dieFiveImage
        dieFive.position = CGPoint(x: x, y: dieFour.position.y - 40)
        diceArray.append(dieFive)
        
        //Die 6 -> can be D2,D1,E2,A1,F3,C1
        let dieSix = SKSpriteNode(imageNamed: dieSixImage)
        dieSix.accessibilityLabel = dieSixImage
        dieSix.position = CGPoint(x: x, y: dieFive.position.y - 40)
        diceArray.append(dieSix)
        
        //Die 7 -> can be B3,A2,A3,B1,B2,C2
        let dieSeven = SKSpriteNode(imageNamed: dieSevenImage)
        dieSeven.accessibilityLabel = dieSevenImage
        dieSeven.position = CGPoint(x: x, y: dieSix.position.y - 40)
        diceArray.append(dieSeven)
        
        for die in diceArray {
            die.size = CGSize(width: 250, height: 250)
            addChild(die)
        }
    }
   
    private func setupWoodBlockers() {
        
        //woodenBlockers
        let woodBlocker1 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker2 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker3 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker4 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker5 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker6 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        let woodBlocker7 = SKSpriteNode(imageNamed: K.ImageName.woodCircle)
        
        var woodBlockerArray: [SKSpriteNode] = []
        
        let a1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y + 73)
        let b1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y + 40)
        let c1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y + 8)
        let d1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y - 24)
        let e1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y - 57)
        let f1 = CGPoint(x: gameBoard.position.x - 79, y: gameBoard.position.y - 89)
        
        let a2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y + 73)
        let b2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y + 40)
        let c2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y + 8)
        let d2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y - 24)
        let e2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y - 57)
        let f2 = CGPoint(x: gameBoard.position.x - 47, y: gameBoard.position.y - 89)
        
        let a3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y + 73)
        let b3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y + 40)
        let c3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y + 8)
        let d3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y - 24)
        let e3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y - 57)
        let f3 = CGPoint(x: gameBoard.position.x - 15, y: gameBoard.position.y - 89)
        
        let a4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y + 73)
        let b4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y + 40)
        let c4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y + 8)
        let d4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y - 24)
        let e4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y - 57)
        let f4 = CGPoint(x: gameBoard.position.x + 17, y: gameBoard.position.y - 89)
        
        let a5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y + 73)
        let b5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y + 40)
        let c5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y + 8)
        let d5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y - 24)
        let e5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y - 57)
        let f5 = CGPoint(x: gameBoard.position.x + 50, y: gameBoard.position.y - 89)
        
        let a6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y + 73)
        let b6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y + 40)
        let c6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y + 8)
        let d6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y - 24)
        let e6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y - 57)
        let f6 = CGPoint(x: gameBoard.position.x + 83, y: gameBoard.position.y - 89)
        
        //get woodenBlocker position based on dice
        
        switch diceArray[0].accessibilityLabel {
        case K.DieValue.b4:
            woodBlocker1.position = b4
        case K.DieValue.c3:
            woodBlocker1.position = c3
        case K.DieValue.c4:
            woodBlocker1.position = c4
        case K.DieValue.d4:
            woodBlocker1.position = d4
        case K.DieValue.d3:
            woodBlocker1.position = d3
        case K.DieValue.e3:
            woodBlocker1.position = e3
        default:
            break
        }
        woodBlockerArray.append(woodBlocker1)
        
        switch diceArray[1].accessibilityLabel {
        case K.DieValue.a6:
            woodBlocker2.position = a6
        case K.DieValue.f1:
            woodBlocker2.position = f1
        default:
            break
        }
        woodBlockerArray.append(woodBlocker2)

        switch diceArray[2].accessibilityLabel {
        case K.DieValue.a5:
            woodBlocker3.position = a5
        case K.DieValue.b6:
            woodBlocker3.position = b6
        case K.DieValue.f2:
            woodBlocker3.position = f2
        case K.DieValue.e1:
            woodBlocker3.position = e1
        default:
            break
        }
        woodBlockerArray.append(woodBlocker3)
        
        switch diceArray[3].accessibilityLabel {
        case K.DieValue.d5:
            woodBlocker4.position = d5
        case K.DieValue.e5:
            woodBlocker4.position = e5
        case K.DieValue.e6:
            woodBlocker4.position = e6
        case K.DieValue.e4:
            woodBlocker4.position = e4
        case K.DieValue.f4:
            woodBlocker4.position = f4
        case K.DieValue.f5:
            woodBlocker4.position = f5
        default:
            break
        }
        woodBlockerArray.append(woodBlocker4)
        
        switch diceArray[4].accessibilityLabel {
        case K.DieValue.a4:
            woodBlocker5.position = a4
        case K.DieValue.b5:
            woodBlocker5.position = b5
        case K.DieValue.c5:
            woodBlocker5.position = c5
        case K.DieValue.c6:
            woodBlocker5.position = c6
        case K.DieValue.d6:
            woodBlocker5.position = d6
        case K.DieValue.f6:
            woodBlocker5.position = f6
        default:
            break
        }
        woodBlockerArray.append(woodBlocker5)
        
        switch diceArray[5].accessibilityLabel {
        case K.DieValue.c1:
            woodBlocker6.position = c1
        case K.DieValue.f3:
            woodBlocker6.position = f3
        case K.DieValue.a1:
            woodBlocker6.position = a1
        case K.DieValue.e2:
            woodBlocker6.position = e2
        case K.DieValue.d2:
            woodBlocker6.position = d2
        case K.DieValue.d1:
            woodBlocker6.position = d1
        default:
            break
        }
        woodBlockerArray.append(woodBlocker6)
        
        switch diceArray[6].accessibilityLabel {
        case K.DieValue.b3:
            woodBlocker7.position = b3
        case K.DieValue.a2:
            woodBlocker7.position = a2
        case K.DieValue.a3:
            woodBlocker7.position = a3
        case K.DieValue.b1:
            woodBlocker7.position = b1
        case K.DieValue.b2:
            woodBlocker7.position = b2
        case K.DieValue.c2:
            woodBlocker7.position = c2
        default:
            break
        }
        woodBlockerArray.append(woodBlocker7)
    
        for woodBlocker in woodBlockerArray {
            woodBlocker.size = CGSize(width: 300, height: 300)
            woodBlocker.zPosition = 0
            addChild(woodBlocker)
        }
    }
    
    //This is how you can create a node and move it across the screen at random speeds
    func addOBlock() {
        let oBlock = SKSpriteNode(imageNamed: K.ImageName.oBlock)
        oBlock.size = CGSize(width: 250, height: 250)
        let actualY = random(min: oBlock.size.height/2, max: size.height-oBlock.size.height/2)
        oBlock.position = CGPoint(x: size.width+oBlock.size.width/2, y: actualY)
        
        addChild(oBlock)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        //Move action
        let actionMove = SKAction.move(to: CGPoint(x: -oBlock.size.width/2, y: actualY), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        
        //Tell it to run /sequence = do it in order
        oBlock.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
    
}
