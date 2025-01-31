//
//  GameVIewModel.swift
//  Memory
//
//  Created by Edgar Adamyan on 31.01.25.
//

import SwiftUI

class GameViewModel: ObservableObject {
  
  var firstChoosedCard: (row: Int, column: Int)? = nil
  let emojis: [String] = ["🐶","🐻","🐭","🦊","🐮","🐼","🐵","🦁","🐸","🐨"]
  
  @Published var isGameFinished: Bool = false
  @Published var board: [[Card]] = []
  @Published var message = ""
  
  init () {
    board = makeBoard()
  }
  
  
  
  func makeBoard() -> [[Card]] {
    message = "Let’s test your memory! Find all the pairs!"
    var cards = emojis + emojis
    cards.shuffle()
    
    var row: [Card] = []
    var board: [[Card]] = []
    
    for (index, emoji) in cards.enumerated() {
      let cart = Card(content: emoji, isMatched: false, isFaceUp: false)
      row.append(cart)
      
      if (index + 1) % 10 == 0 {
        board.append(row)
        row = []
      }
    }
    return board
    
  }
  
  func restartGame() {
    board = makeBoard()
    firstChoosedCard = nil
    
    
  }
  
  func flipCard(row: Int, column: Int) {
    
    if board[row][column].isFaceUp == false && board[row][column].isMatched == false {
      if firstChoosedCard == nil {
        board[row][column].isFaceUp.toggle()
        message = "Choose one more card"
        firstChoosedCard = (row, column)
      } else {
        board[row][column].isFaceUp.toggle()
        message = "Checking for Match"
        checkForMatch(firstCard: firstChoosedCard!, secondCard: (row, column))
        firstChoosedCard = nil
      }
      
    }
  }
  
  
  
  
  
  func checkForMatch(firstCard: (row: Int, column: Int), secondCard: (row: Int, column: Int)) {
    
    var firstFlippedCard = board[firstCard.row][firstCard.column]
    var secondFlippedCard = board[secondCard.row][secondCard.column]
    
    if firstFlippedCard.content == secondFlippedCard.content {
      firstFlippedCard.isMatched = true
      secondFlippedCard.isMatched = true
      message = "You found a pair"
      checkIfFinished()
      
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.board[firstCard.row][firstCard.column].isFaceUp = false
        self.board[secondCard.row][secondCard.column].isFaceUp = false
      }
    }
    
  }
  
  func checkIfFinished() {
    if board.flatMap({$0}).allSatisfy({$0.isMatched}) {
      isGameFinished = true
      message = "You found all cards ! "
    }
  }
  
  //  func checkIfFinished() {
  //
  //    for row in board {
  //      for card in row {
  //        if !card.isMatched {
  //          isGameFinished = false
  //          return
  //        }
  //      }
  //    }
  //    isGameFinished = true
  //    if isGameFinished == true {
  //      print("Game is finished")
  //    }
  //
  //  }
  
  
  
}
