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
        notificationCenter.addObserver(self, selector: #selector(appTerminated), name: UIApplication.willTerminateNotification, object: nil)
    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        btnCollectionCell.forEach({$0.layer.borderColor = UIColor.black.cgColor})
        btnCollectionCell.forEach({$0.layer.borderWidth = 1})
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if let addedVal = lastAddedValue {
                ticTacBoard[addedVal.index].value = nil
                btnCollectionCell[addedVal.index].setTitle("", for: .normal)
                lastAddedValue = nil
                isCurrentTurnA.toggle()
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
        checkResult()
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
        
        let isFirstRowX = p1 == "X" && p2 == "X" && p3 == "X"
        let isSecondRowX = p4 == "X" && p5 == "X" && p6 == "X"
        let isThirdRowX = p7 == "X" && p8 == "X" && p9 == "X"
        
        let isFirstColX = p1 == "X" && p4 == "X" && p7 == "X"
        let isSecondColX = p2 == "X" && p5 == "X" && p8 == "X"
        let isThirdColX = p3 == "X" && p6 == "X" && p9 == "X"
        
        let isFirstDiagX = p1 == "X" && p5 == "X" && p9 == "X"
        let isSecondDiagX = p3 == "X" && p5 == "X" && p7 == "X"
        
        let isFirstRowY = p1 == "0" && p2 == "0" && p3 == "0"
        let isSecondRowY = p4 == "0" && p5 == "0" && p6 == "0"
        let isThirdRowY = p7 == "0" && p8 == "0" && p9 == "0"
        
        let isFirstColY = p1 == "0" && p4 == "0" && p7 == "0"
        let isSecondColY = p2 == "0" && p5 == "0" && p8 == "0"
        let isThirdColY = p3 == "0" && p6 == "0" && p9 == "0"
        
        let isFirstDiagY = p1 == "0" && p5 == "0" && p9 == "0"
        let isSecondDiagY = p3 == "0" && p5 == "0" && p7 == "0"
        
        
        if isFirstRowX ||
            isSecondRowX ||
            isThirdRowX ||
            isFirstColX ||
            isSecondColX ||
            isThirdColX ||
            isFirstDiagX ||
            isSecondDiagX {
            showAlert(msg: "A won!!")
            winCountA = winCountA + 1
            resetGame()
            
        } else if  isFirstRowY ||
                    isSecondRowY ||
                    isThirdRowY ||
                    isFirstColY ||
                    isSecondColY ||
                    isThirdColY ||
                    isFirstDiagY ||
                    isSecondDiagY {
            showAlert(msg: "B won!!")
            winCountB = winCountB + 1
            resetGame()
            
        } else if p1 != "" &&
                    p2 != "" &&
                    p3 != "" &&
                    p4 != "" &&
                    p5 != "" &&
                    p6 != "" &&
                    p7 != "" &&
                    p8 != "" &&
                    p9 != "" {
            showAlert(msg: "It's a tie", actionTitle: "Oops")
        } else {
            print("continued..")
        }
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer){
        resetGame()
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
        alert.addAction(UIAlertAction(title: "Start New Game", style: .default, handler: { [self] _ in
            alert.dismiss(animated: true)
            self.resetGame()
        }));
        self.present(alert, animated: true, completion: nil)
    }
}
