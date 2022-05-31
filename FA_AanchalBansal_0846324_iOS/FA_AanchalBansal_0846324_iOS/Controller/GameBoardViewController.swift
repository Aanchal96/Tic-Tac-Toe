//
//  GameBoardViewController.swift
//  


import UIKit
import SwiftyJSON

class GameBoardViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var winCountALabel: UILabel!
    @IBOutlet var winCountBLabel: UILabel!
    @IBOutlet var currentPlayerTurnLabel: UILabel!
    
    // MARK: Properties
    var winCountA: Int = 0
    var winCountB: Int = 0
    var lastAddedValue: GameModel?
    var ticTacBoard : [GameModel] = [GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ]
    var isCurrentTurnA = true
    
    @IBOutlet var btnCollectionCell: [UIButton]!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.becomeFirstResponder()
        addSwipeGesture()
        checkIfGameExistOrResetGame()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willTerminateNotification, object: nil)
    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if let addedVal = lastAddedValue {
                print("shake")
                ticTacBoard[addedVal.index].value = nil
                btnCollectionCell[addedVal.index].setTitle("", for: .normal)
                lastAddedValue = nil
                setBoardData()
            }
        }
    }
    
    // MARK: Button Actions
    @IBAction func btnActionCollectionCell(_ sender: UIButton) {
        
        if let _ = ticTacBoard[sender.tag - 1].value {
            return
        } else {
            if isCurrentTurnA {
                ticTacBoard[sender.tag - 1].value = .cross
                sender.setTitle("X", for: .normal)
            } else {
                ticTacBoard[sender.tag - 1].value = .zero
                sender.setTitle("0", for: .normal)
            }
            isCurrentTurnA.toggle()
            ticTacBoard[sender.tag - 1].index = sender.tag - 1
            lastAddedValue = ticTacBoard[sender.tag - 1]
        }
        setBoardData()
    }
    
}

extension GameBoardViewController {
    func checkIfGameExistOrResetGame() {
        let json = ApplicationUserDefaults.value(forKey: .gameData)
        if json != JSON.null {
            let gameModel = SavedGameData.init(json)
            winCountA = gameModel.winCountA
            winCountB = gameModel.winCountB
            lastAddedValue = nil
            ticTacBoard = gameModel.currentGame
            isCurrentTurnA = gameModel.isCurrentTurnA
        } else {
            resetGame()
        }
        setBoardData()
    }
    
    func resetGame() {
        lastAddedValue = nil
        isCurrentTurnA = true
        ticTacBoard = [GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ,GameModel() ]
        setBoardData()
    }
    
    func setBoardData() {
        currentPlayerTurnLabel.text = isCurrentTurnA ? "A" : "B"
        for btn in btnCollectionCell {
            btn.setTitle(ticTacBoard[btn.tag - 1].value?.rawValue ?? "", for: .normal)
        }
        winCountALabel.text = winCountA.description
        winCountBLabel.text = winCountB.description
    }
    
    func addSwipeGesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    func checkResult(){
        let p1 = ticTacBoard[0].value?.rawValue ?? ""
        let p2 = ticTacBoard[1].value?.rawValue ?? ""
        let p3 = ticTacBoard[2].value?.rawValue ?? ""
        let p4 = ticTacBoard[3].value?.rawValue ?? ""
        let p5 = ticTacBoard[4].value?.rawValue ?? ""
        let p6 = ticTacBoard[5].value?.rawValue ?? ""
        let p7 = ticTacBoard[6].value?.rawValue ?? ""
        let p8 = ticTacBoard[7].value?.rawValue ?? ""
        let p9 = ticTacBoard[8].value?.rawValue ?? ""
        
        if (p1 && p2 && p3) == "X" || (p4 && p5 && p6) == "X" || (p7 && p8 && p9) == "X" || (p1 && p4 && p7) == "X" || (p2 && p5 && p8) == "X" || (p3 && p6 && p9) == "X" || (p1 && p5 && p9) == "X" || (p3 && p5 && p7) == "X" {
            showAlert(msg: "A won!!")
            winCountA = winCountA + 1
            resetGame()
            
        } else if (p1 && p2 && p3) == "0" || (p4 && p5 && p6) == "0" || (p7 && p8 && p9) == "0" || (p1 && p4 && p7) == "0" || (p2 && p5 && p8) == "0" || (p3 && p6 && p9) == "0" || (p1 && p5 && p9) == "0" || (p3 && p5 && p7) == "0"{
            showAlert(msg: "B won!!")
            winCountB = winCountB + 1
            resetGame()
            
        } else if (p1 && p2 && p3 && p3 && p3 && p3 && p3 && p3 && p3) != ""{
            showAlert(msg: "It's a tie", actionTitle: "Oops")
        } else {
            print("continued..")
        }
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer){
        resetGame()
        print("swipe")
    }
    
    @objc func appTerminated(){
        let modelToSave = SavedGameData.init()
        modelToSave.winCountB = winCountB
        modelToSave.winCountA = winCountA
        modelToSave.isCurrentTurnA = isCurrentTurnA
        modelToSave.currentGame = ticTacBoard
        ApplicationUserDefaults.save(value: modelToSave.getDict(), forKey: .gameData)
    }
    
    func showAlert(msg: String , actionTitle: String = "Wohooo!") {
        let alert = UIAlertController(title: actionTitle, message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start New Game", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }));
        self.present(alert, animated: true, completion: nil)
    }
}
