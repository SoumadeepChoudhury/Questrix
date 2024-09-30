//
//  Untitled.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 28/09/24.
//

import AVFoundation


//import QuartzCore
//import AppKit
//
//public class Recording : NSObject, AVAudioRecorderDelegate {
//    
//    @objc public enum State: Int {
//        case None, Record, Play
//    }
//    
////    static var directory: String {
////        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
////    }
//    
//    public private(set) var url: NSURL
//    public private(set) var filePath: String
//    
//    public var bitRate = 192000
//    public var sampleRate = 44100.0
//    public var channels = 1
//    
//    private var recorder: AVAudioRecorder?
//    private var player: AVAudioPlayer?
//
//
//    
//    var state: State = .None
//    
//    
//    // MARK: - Initializers
//    public init(filePath: String) {
//        self.filePath = filePath
//        url = NSURL(fileURLWithPath: self.filePath) as NSURL
//    }
//    
//    
//    
//    // MARK: - Record
//    private func prepare() throws {
//        
//        let settings: [String: AnyObject] = [
//            AVFormatIDKey: Int(kAudioFormatMPEGLayer3) as AnyObject,
//            AVEncoderBitRateKey: bitRate as AnyObject,
//            AVSampleRateKey: sampleRate as AnyObject,
//            AVNumberOfChannelsKey: channels as AnyObject,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue as AnyObject
//        ]
//        
//        recorder = try AVAudioRecorder(url: url as URL, settings: settings)
////        recorder = try AVAudioRecorder(url: url as URL, format: AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!)
//        recorder?.delegate = self
//        recorder?.prepareToRecord()
//    }
//    
//    public func record() throws {
//        print("Saving to \(url)")
//        if recorder == nil {
//            try prepare()
//        }
//        recorder?.record()
//        self.state = .Record
//    }
//    
//    // MARK: - Playback
//    public func play() throws {
//        player = try AVAudioPlayer(contentsOf: url as URL)
//        print(player)
//        player?.prepareToPlay()
//        player?.volume = 1.0
//        player?.play()
//        self.state = .Play
//    }
//    
//    public func stop() {
//        switch self.state {
//        case .Play:
//            player?.stop()
//            player = nil
//        case .Record:
//            recorder?.stop()
//            recorder = nil
//        default:
//            break
//        }
//        self.state = .None
//    }
//    
//    // MARK: - Delegates
//    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        print("audioRecorderDidFinishRecording")
//    }
//    
//    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
//        print("audioRecorderEncodeErrorDidOccur \(String(describing: error?.localizedDescription))")
//    }
//}


//class AudioRecorder {
//    let audioRecorder: AVAudioRecorder!
//
//    init() {
////        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////        let url = "file://" + ContentView.fileManager.masterDirectory.path + "/Anatomy/.audio.m4a"
//        let url = NSURL(string: "file://" + ContentView.fileManager.masterDirectory.path + "/Anatomy/.audio.m4a")
//        print(url)
//
//        let settings: [String:Any] = [
//            AVFormatIDKey: kAudioFormatMPEG4AAC,
//            AVSampleRateKey: 44100.0,
//            AVNumberOfChannelsKey: 2,
//            AVEncoderAudioQualityKey: AVAudioQuality.high
//        ]
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: url! as URL, settings: settings)
//            
//        } catch {
//            print("Error creating audio recorder: \(error)")
//            audioRecorder = nil
//        }
//    }
//
//    func startRecording() {
//        let r = audioRecorder.prepareToRecord()
//        print("Prep: ",r)
//        let resp = audioRecorder.record()
//        print("Record: ",resp)
//    }
//
//    func stopRecording() {
//        audioRecorder.stop()
//    }
//}


//class Rec {
//    let audioEngine = AVAudioEngine()
//    let audioPlayer = AVAudioPlayerNode()
//    
//    var outputFile: AVAudioFile? = nil
//    let input: AVAudioInputNode
//    let bus: Int
//    let inputFormat: AVAudioFormat
//    
//    let outputURL: String
//    init(){
//        input = audioEngine.inputNode
//        bus = 0
//        inputFormat = input.inputFormat(forBus: bus)
//        
//        outputURL = ContentView.fileManager.masterDirectory.path + "/Anatomy/.audio1.wav"
//        print("writing to \(outputURL)")
//    }
//    
//    func start() {
//        let settings: [String: AnyObject] = [
//            AVFormatIDKey: Int(kAudioFormatMPEGLayer3) as AnyObject,
//                    AVEncoderBitRateKey: 192000 as AnyObject,
//                    AVSampleRateKey: 44100.0 as AnyObject,
//                    AVNumberOfChannelsKey: 2 as AnyObject,
//                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue as AnyObject
//                ]
//        outputFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: outputURL), settings: inputFormat.settings, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: inputFormat.isInterleaved)
//        
//        if(outputFile != nil) {
//            input.installTap(onBus: bus, bufferSize: 512, format: inputFormat) { (buffer, time) in
//                try! self.outputFile?.write(from: buffer)
//            }
//            try! audioEngine.start()
//        }else{
//            print("Error occured..")
//        }
//    }
//    
//    
//    func stop(){
//        audioEngine.stop()
//    }
//    
//}

class Recorder {
    
    var audioEngine : AVAudioEngine = AVAudioEngine()
    var outref: ExtAudioFileRef?
    var mixer : AVAudioMixerNode = AVAudioMixerNode()
    var filePath : String
    
    init(){
        self.filePath = ""
    }
    
    init(filePath: String){
        self.filePath = filePath
    }
    
    func start() {

        if(!filePath.isEmpty){
            
            let bus: Int = 0
            let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32,
                                       sampleRate: 44100.0,
                                       channels: 1,
                                       interleaved: true)
            
            _ = ExtAudioFileCreateWithURL(URL(fileURLWithPath: self.filePath) as CFURL,
                                          kAudioFileWAVEType,
                                          (format?.streamDescription)!,
                                          nil,
                                          AudioFileFlags.eraseFile.rawValue,
                                          &outref)
            
            self.audioEngine.attach(self.mixer)
            
            self.mixer.installTap(onBus: bus, bufferSize: AVAudioFrameCount((format?.sampleRate)!), format: mixer.outputFormat(forBus: bus), block: { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                
                let audioBuffer : AVAudioBuffer = buffer
                if(self.outref != nil){
                    _ = ExtAudioFileWrite(self.outref!, buffer.frameLength, audioBuffer.audioBufferList)
                }
            })
            
            
            self.audioEngine.connect(self.audioEngine.inputNode, to: self.mixer, format: audioEngine.inputNode.inputFormat(forBus: bus))
            mixer.volume = 0
            self.audioEngine.connect(self.mixer, to: self.audioEngine.mainMixerNode, format: format)
            
            
            self.audioEngine.prepare()
            do{
                try self.audioEngine.start()
                print("STARTED.")
            }catch{
                print("Error in start of AudioEngine")
            }
        }else{
            print("Error. No File Path Set...")
        }
    }

    func stop() {
        self.audioEngine.stop()
        self.mixer.removeTap(onBus: 0)
        if(self.outref != nil){
            ExtAudioFileDispose(self.outref!)
            print("STOPPED")
        }
    }
}


class AudioPlayer {
    let audioEngine: AVAudioEngine = AVAudioEngine()
    let audioFilePlayer: AVAudioPlayerNode = AVAudioPlayerNode()
    let filePath: String
    
/*
 AudioFile <AVAudioFile: 0x600001d66c90>
 Audioformat:  <AVAudioFormat 0x600003ccbc50:  2 ch,  44100 Hz, Float32, deinterleaved>
 FrameCount:  71680
 Buffer:  <AVAudioPCMBuffer@0x600001f7f380: 0/286720 bytes>
 
 */
    
    init(){
        self.filePath = ""
    }
    
    init(filePath: String){
        
        self.filePath = filePath
        if(!filePath.isEmpty){
            
            let fileURL = URL(fileURLWithPath: filePath)
            
            guard let audioFile = try? AVAudioFile(forReading: fileURL) else{ print("Audio"); return }
            print("AudioFile",audioFile)
            
            let audioFormat = audioFile.processingFormat
            print("Audioformat: ",audioFormat)
            let audioFrameCount = UInt32(audioFile.length)
            print("FrameCount: ",audioFrameCount)
            guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)  else{ print("Here"); return }
            print("Buffer: ",audioFileBuffer)
            do{
                try audioFile.read(into: audioFileBuffer)
            } catch{
                print("over")
            }
            //        let mainMixer = audioEngine.mainMixerNode
            audioEngine.attach(audioFilePlayer)
            audioEngine.connect(audioFilePlayer, to: audioEngine.outputNode, format: audioFileBuffer.format)
            try? audioEngine.start()
            audioFilePlayer.scheduleBuffer(audioFileBuffer, at: nil, options:AVAudioPlayerNodeBufferOptions.loops)
        }
    }
    
    func play(){
        if(!self.filePath.isEmpty){
            audioFilePlayer.play()
        }
    }
    
    func pause(){
        if(!self.filePath.isEmpty){
            audioFilePlayer.pause()
        }
    }
    
    func stopEngine(){
        audioEngine.stop()
    }
}

