//
//  FeedbackViewController.swift
//  SpeechDemo
//
//  Created by Robert Olieman on 4/29/21.
//

import UIKit
import Speech

class FeedbackViewController: BaseViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var speechButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    let audioEngine = AVAudioEngine()

    let speechRecognizer = SFSpeechRecognizer()
    
    let bufferRequest = SFSpeechAudioBufferRecognitionRequest()
    
    var speechRecognitionTask: SFSpeechRecognitionTask?
    
    var isListening = false
    
    var speechButtonTitle: String {
        return self.isListening ? "Stop Speech" : "Start Speech"
    }
    
    var bus = 0
    
    var remoteAPI: RemoteAPI!
    
    var user: User!
    
    func setup(remoteAPI: RemoteAPI, user: User) {
        self.remoteAPI = remoteAPI
        self.user = user
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechButton.setTitle(self.speechButtonTitle, for: .normal)
        self.textView.backgroundColor = .clear
        self.submitButton.makeBasicButton()
        
        self.textView.layer.cornerRadius = 10
        self.textView.layer.borderWidth = 5
        self.textView.layer.backgroundColor = UIColor.white.cgColor
        self.textView.layer.borderColor = UIColor.black.cgColor
        
    }

    @IBAction func clickedSpeechButton(_ sender: UIButton) {
        self.toggleSpeech()
    }
    
    func toggleSpeech() {
        self.isListening.toggle()
        self.speechButton.setTitle(self.speechButtonTitle, for: .normal)
        self.isListening ? self.startSpeechRecognition() : self.stopSpeechRecognition()
    }
    
    @IBAction func tappedSubmitButton(_ sender: UIButton) {
        if let text = self.textView.text {
            if self.isListening {
                self.toggleSpeech()
            }
            self.remoteAPI.patchUser(user: self.user, newUsername: nil, newPassword: nil, newIsPremiumMember: nil, addedFeedback: text, success: {
                self.presentBasicAlert(title: "Thanks for your feedback!", onDismiss: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
        
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func startSpeechRecognition() {
        let node = self.audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: self.bus)
        node.installTap(onBus: self.bus, bufferSize: 1024, format: recordingFormat) { audioPCMBuffer, audioTime in
            self.bufferRequest.append(audioPCMBuffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
        
        self.speechRecognitionTask = self.speechRecognizer?.recognitionTask(with: self.bufferRequest, resultHandler: { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                let message = result.bestTranscription.formattedString
                self.textView.text = message
                
                var lastMessage: String?
         
                for segment in result.bestTranscription.segments {
                    let index = message.index(message.startIndex, offsetBy: segment.substringRange.location)
                    lastMessage = String(message[index...])
                }
                
                if let lastMessage = lastMessage {
                    switch lastMessage {
                    case "read", "Read", "red":
                        self.view.backgroundColor = .red
                    case "blue", "Blue":
                        self.view.backgroundColor = .blue
                    case "white", "White":
                        self.view.backgroundColor = .white
                    default:
                        break
                    }
                }
            }
        })
    }
    
    func stopSpeechRecognition() {
        self.speechRecognitionTask?.finish()
        self.speechRecognitionTask?.cancel()
        self.bufferRequest.endAudio()
        self.audioEngine.stop()
        
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: self.bus)
        }
    }
}

