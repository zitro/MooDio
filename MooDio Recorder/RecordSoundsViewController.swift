//
//  RecordSoundsViewController.swift
//  MooDio Recorder
//
//  Created by Bryan Ortiz on 6/25/15.
//  Copyright (c) 2015 NerdyCow. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var mictext: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pauseText: UIImageView!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var continueRecord: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueRecord = false
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        mictext.hidden = false
        pauseButton.hidden = true
        pauseText.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        mictext.hidden = true
        pauseButton.hidden = false
        pauseText.hidden = false
    
        if(!continueRecord){
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
       
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        }
        else{
            continueRecord = false
        }
        audioRecorder.record()
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
       
        recordedAudio = RecordedAudio(filePathURL: recorder.url, title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            recordButton.enabled = true
            stopButton.hidden = true
            mictext.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
       
        recordingInProgress.hidden = true
        stopButton.hidden = false
        recordButton.enabled = true
        mictext.hidden = false
        pauseButton.hidden = true
        pauseText.hidden = true
        continueRecord = true
        
        audioRecorder.pause()
       
        }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
}