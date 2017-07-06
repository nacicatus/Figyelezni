//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 09/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make sure these UI elements appear every time
        stopButton.isHidden = true
        stopLabel.isHidden = true
        pauseButton.isHidden = true
        pauseLabel.isHidden = true
        recordButton.isEnabled = true
        recLabel.text = "Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        // Do Magic with buttons
        recLabel.text = "Recording..."
        stopButton.isHidden = false
        stopLabel.isHidden = false
        pauseButton.isHidden = false
        pauseLabel.isHidden = false
        recordButton.isEnabled = false
        
        
        // Set up to Record Audio

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] 
        // Use current date and time to give the recorded sound an identity
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let filePath = URL(fileURLWithPath: dirPath, isDirectory: true).appendingPathComponent(recordingName)
        print(filePath)
        
        // Create an Audio Play & Record session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Record it!
        do {
            try audioRecorder = AVAudioRecorder(url: filePath, settings: [dirPath : recordingName])
        } catch _ {
            
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Initialize the recorded audio when you're done recording
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            // Perform a segue to the second View
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
                } else {
                    print("Unsuccessful recording")
                    recordButton.isEnabled = true
                    stopButton.isHidden =  true
                    stopLabel.isHidden = true
                    pauseButton.isHidden = true
                    pauseLabel.isHidden = true
                }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the recorded audio in the first ViewController to the second ViewController
        if (segue.identifier == "stopRecording") {
            let PlaySoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            PlaySoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseRecording(_ sender: UIButton) {
        // Do magic with buttons
        recLabel.text = "Recording Paused"
        stopButton.isEnabled = false
        stopLabel.isHidden = true
        pauseButton.isHidden = false
        pauseLabel.text = "Release to Resume"
        recordButton.isEnabled = true
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(_ sender: UIButton) {
        // Do Magic with buttons
        recLabel.text = "Recording..."
        stopButton.isEnabled = true
        stopLabel.isHidden = false
        pauseButton.isHidden = false
        pauseLabel.text = "Pause"
        recordButton.isEnabled = false
        
        
        // Set up to Record Audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // Use current date and time to give the recorded sound an identity
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let filePath = URL(fileURLWithPath: dirPath, isDirectory: true).appendingPathComponent(recordingName)
        print(filePath)
        
        // Create an Audio Play & Record session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Record it!
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        // Stop and reset the recording scene
        recLabel.text = "Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

