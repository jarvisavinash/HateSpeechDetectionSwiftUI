//
//  Tweet Analyser.swift
//  Hate Speech Detection
//
//  Created by Avinash Patil on 14/06/21.
//  Copyright © 2021 Avinash Patil. All rights reserved.

import Foundation
import Swifter
import SwiftyJSON
import CoreML
import Combine

let swifter = Swifter(consumerKey: "ANqwWFQI5RGYFM7lZjt7tRA9I", consumerSecret: "BhAhZaPNXOIoiFqpnogqCbFPx6789cEsWwbRfVFN9RVLnII5lX")
let tweetcount = 100
let language = "en"
var tweets = [TweetAnalyserInput]()
let sentimentClassifier = TweetAnalyser()

var output = [0,0,0]


class Value : ObservableObject {

    @Published var cag = 0
    @Published var oag = 0
    @Published var nag = 0
    
    func updateData() {
        self.cag = output[0]
        self.oag = output[1]
        self.nag = output[2]
    }
}
   

var OAGcount = 0
var CAGcount = 0
var NAGcount = 0

func fetch(query: String){
swifter.searchTweet(using: query, lang: language, count: tweetcount, tweetMode: .extended ,success: {(results, metadata) in
    
    OAGcount = 0
    CAGcount = 0
    NAGcount = 0
    
    for i in 0..<100{
        if let tweet = results[i]["full_text"].string{
        let temp = TweetAnalyserInput(text: tweet)
        tweets.append(temp)
        }
    }
    print("Fetch Over")
    DispatchQueue.main.async {
    output = analyse()
    print(output)
    }
}) { (error) in
    print("API Error \(error)")
}
}

func analyse()->Array<Int>{
do{
let predictions = try sentimentClassifier.predictions(inputs: tweets)
for pred in predictions{
    
    let output = pred.label
    
    switch output{
    case "CAG":
        CAGcount+=1
    case "OAG":
        OAGcount+=1
    case "NAG":
        NAGcount+=1
    default:
        CAGcount+=0
        OAGcount+=0
        NAGcount+=0
        }
    }
}
catch
{
print("Analysis Error \(error)")
}
print("Analysis Over")
print(OAGcount,CAGcount,NAGcount)
return [CAGcount,OAGcount,NAGcount]
}

