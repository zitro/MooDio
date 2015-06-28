//
//  PlaySoundsViewController.swift
//  MooDio Recorder
//
//  Created by Bryan Ortiz on 6/25/15.
//  Copyright (c) 2015 NerdyCow. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer! //for echo
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    

  
    override func viewDidLoad() {
        super.viewDidLoad()
// Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        //echo
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        //end echo
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.play()
        
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 2
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.play()
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    
    @IBAction func echoButton(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.5
        var delaytime:NSTimeInterval
        delaytime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.rate = 1
        audioPlayer2.volume = 0.8
        audioPlayer2.playAtTime(delaytime)
        
    }
    
    
    @IBAction func reverbButton(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        playAudioWithReverb(100)
    }
    
    func playAudioWithReverb (reverb: Float) {
        
        var audioPlayerNode = AVAudioPlayerNode ()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb ()
        changeReverbEffect.wetDryMix = reverb
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    
}
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
