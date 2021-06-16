//
//  Text Analyser.swift
//  Hate Speech Detection
//
//  Created by Avinash Patil on 14/06/21.
//  Copyright © 2021 Avinash Patil. All rights reserved.

import Foundation
import CoreML

let textClassifier = TweetAnalyser()

func text_analyse(analyse: String)->String{
    var result: String = ""
    do{
        if analyse == ""{
            result = "Enter Some Keywords"
        }
        else{
        let input_text = TweetAnalyserInput(text: analyse)
        let predict = try textClassifier.prediction(input: input_text)
        print(predict.label)
        if predict.label == "CAG"{
            result="Offensive Text"
        }
        else if predict.label == "OAG"{
            result="Hate Speech Text"
        }
        else if predict.label == "NAG"{
            result="Neither"
            }
        }
    }
    catch{
        print("Analysis Error \(error)")
        result = "Error Occured"
    }
    return result
}


