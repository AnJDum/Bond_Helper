//
//  question.swift
//  Bond_Helper
//


import Foundation


class question{
    
    
    var answer = [String](repeating: "", count: 5)
    var answerscore = [Int](repeating: 0, count: 5)
    var questionText: String
    var questionnum: Int
    
    init(text:String,Answer1score:Int,Answer2score:Int,Answer3score:Int,Answer4score:Int,Answer5score:Int,Answer1text:String,Answer2text:String,Answer3text:String,Answer4text:String,Answer5text:String,quesnum:Int){
        questionText = text
        answer[0] = Answer1text
        answer[1] = Answer2text
        answer[2] = Answer3text
        answer[3] = Answer4text
        answer[4] = Answer5text
        answerscore[0] = Answer1score
        answerscore[1] = Answer2score
        answerscore[2] = Answer3score
        answerscore[3] = Answer4score
        answerscore[4] = Answer5score
        questionnum = quesnum
    }
}


