
import Foundation

protocol ViewModelDelegate: AnyObject {
    func didUpdateData()
    func updateLabel(player: String)
}

class GameViewModel {
    
    lazy var scoreForLabelPlayer = 0
    lazy var scoreForLabelSecondPlayer = 0
    lazy var namePlayer = ""
    lazy var nameSecondPlayer = ""
    weak var delegate: ViewModelDelegate?
    private(set) var round = false
    private lazy var selectedCellX = [IndexPath]()
    private lazy var selectedCellO = [IndexPath]()
    private lazy var draw = [IndexPath]()
    private lazy var drawCheck = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    private lazy var winCombos = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    
    func updateRound(round: Bool) {
        if round {
            self.round = false
        } else {
            self.round = true
        }
    }
    
    func isCellSelected(at indexPath: IndexPath) -> Bool {
        return selectedCellX.contains(indexPath) || selectedCellO.contains(indexPath)
    }
    
    func checkDraw() {
        let drawResult = draw.map { $0[1] }
        let allElementsExist = drawCheck.allSatisfy { drawResult.contains($0) }
        if allElementsExist {
            delegate?.updateLabel(player: "Draw")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.resetGame()
                self.delegate?.didUpdateData()
            }
            return
        }
    }
    
    func markCellSelected(at indexPath: IndexPath, round: Bool) {
        if round {
            selectedCellX.append(indexPath)
            draw.append(indexPath)
            checkWin()
        } else {
            selectedCellO.append(indexPath)
            draw.append(indexPath)
            checkWin()
        }
    }
    
    func checkWin() {
        let winX = selectedCellX.map { $0[1] }
        let winO = selectedCellO.map { $0[1] }
        
        for combo in winCombos {
            if combo.allSatisfy({ winX.contains($0) }) {
                scoreForLabelPlayer += 1
                delegate?.updateLabel(player: "Win \(namePlayer)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.resetGame()
                    self.delegate?.didUpdateData()
                }
                return
            } else if combo.allSatisfy({ winO.contains($0) }) {
                scoreForLabelSecondPlayer += 1
                delegate?.updateLabel(player: "Win \(nameSecondPlayer)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.resetGame()
                    self.delegate?.didUpdateData()
                }
                return
            }
        }
        checkDraw()
    }
    
    func resetGame() {
        selectedCellX.removeAll()
        selectedCellO.removeAll()
        draw.removeAll()
    }
}
