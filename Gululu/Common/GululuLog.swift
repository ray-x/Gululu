//
//  GululuLog.swift
//  Gululu
//
//  Created by Wei on 6/21/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation

enum LogLevel: Int {
    case debug = 0
    case info
    case pair
    case warning
    case error
    case critical
}

let gululu_log_name = "gululu.log"

struct BHGululuLog
{

    /**
     Get the file url of log
     
     - returns: NSURL, the url of file
     */
    func getLogFilePathURLWithFileName(_ fileName: String) -> URL
    {
        let documentURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let fileURL = (documentURL[0] as URL).appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: fileURL.path)
        {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        return fileURL
    }
    
    /**
     Write logs data to file
     
     - parameter log     :    the content to write to log file
     - parameter mode    :    the level of the log
     - parameter fileName:    the file name to write to
     - format            :    2016-16-16 16:16:16:166 [pair]: xxxxxxxx
     
     ssid: abcd\r\n
     ssid ok\r\n
     pwd: length=13\r\n
     pwd ok
     childsn: wertyui
     childsn ok
     tosta
     tosta ok
     
     - returns: success :     true - read succeed, false - read failed
     error   :     the error message of write to log file failed
     */
    @discardableResult
    func writeToLogFile(_ log: String, mode: String, fileName: String) -> (success: Bool, error: String)
    {
        var success: Bool = false
        var error: String = ""
        var logString: String = ""
        let dateStr = BKDateTime.getLocalDateString(Date())
        logString = dateStr + "  [\(mode)]: \(log)"

        if (log.range(of: "\r\n") != nil) {
            logString = logString.replacingOccurrences(of: "\r\n", with: "")
        }
        logString.append("\n")

        let fileURL: URL = getLogFilePathURLWithFileName(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            let data: Data = logString.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            let fileHandler: FileHandle = try! FileHandle(forWritingTo: fileURL)
            fileHandler.seekToEndOfFile()
            fileHandler.write(data)
            fileHandler.closeFile()
            success = true
        }
        else
        {
            success = false
            error = "Failed: target file is not exist"
        }
        return (success, error)
    }
    
    /**
     Write logs data to file
     
     - parameter log     :    the content to write to log file
     
     - returns: success :     true - read succeed, false - read failed
     error   :     the error message of write to log file failed
     */
    @discardableResult
    func writeToLogFile(_ logStr: String) -> (success: Bool, error: String)
    {
        var success: Bool = false
        var error: String = ""
        let fileURL: URL = getLogFilePathURLWithFileName(gululu_log_name)
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            let data: Data = logStr.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            let fileHandler: FileHandle = try! FileHandle(forWritingTo: fileURL)
            fileHandler.seekToEndOfFile()
            fileHandler.write(data)
            fileHandler.closeFile()
            success = true
        }
        else
        {
            success = false
            error = "Failed: target file is not exist"
        }
        return (success, error)
    }
    
    /**
     Read content from log file
     
     - returns: success: true - read successfully, false - read failed
     content: the content of log file
     error  : the error message when read log file failed
     */
    func readFromLogFile(_ fileName: String) -> (success: Bool, content: String, error: String)
    {
        var success: Bool = false
        var content: String = ""
        var error: String = ""
        
        let fileURL: URL = getLogFilePathURLWithFileName(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) && logFileSize(fileName) > 0
        {
            let fileHandler: FileHandle = try! FileHandle(forReadingFrom: fileURL)
            fileHandler.seek(toFileOffset: 0)
            let data = fileHandler.readDataToEndOfFile()
            content = String(data: data, encoding: String.Encoding.utf8)!
            success = true
            
            fileHandler.closeFile()
        }
        else
        {
            success = false
            error = "Failed: target file is not exist"
        }
        return (success, content, error)
    }
    
    
    /**
     Get log size
     
     - parameter fileURL: the url of log file
     
     - returns: the size of log file
     */
    func logFileSize(_ fileName: String) -> Int64
    {
        let fileURL: URL = getLogFilePathURLWithFileName(fileName)
        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: fileURL.path)
        let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
        let fileSize = fileSizeNumber.int64Value
        return fileSize
    }
    
    /**
     Remove the log file
     */
    func removeLogFile(_ fileName: String)
    {
        let fileURL: URL = getLogFilePathURLWithFileName(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            }
            catch {
                print("an error during removing")
            }
        }
    }
    
    /**
     Upload log file to sever
     
     - returns: success: true: upload succeed, false: upload failed
     error  : the error message of upload failed
     */
    func uploadLogFile(_ fileName: String) {
        let readResult = readFromLogFile(fileName)
        if readResult.success {
            CloudComm.shareObject.uploadDiagnostic(readResult.content) { (result) in
                switch result {
                case .Success :
                    self.removeLogFile(fileName)
                    break
                case .Error(_): break
                }
            }
        } else {
            print("Upload \(readResult.error)")
        }
    }
}

    /**
     Write logs of string with log level to file
     */
    func BH_Log(_ logString: String, logLevel: LogLevel)
    {
        #if DEBUG
            print(logString)
        #endif
        
        if 0 < logLevel.rawValue {
            let logInfo = getLogInfo(logLevel)
            BHGululuLog().writeToLogFile(logString, mode: logInfo.mode, fileName: logInfo.fileName)
        }
    }

    func BH_Log_New(_ logLevel: LogLevel, _ log: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function){
        if logLevel.rawValue == 0{
            return
        }
        guard isValidString(log) else{
            return
        }
        let logInfo = getLogInfo(logLevel)
        let file_name = handle_file_to_get_last_file_name(file)
        var logString: String = ""
        let dateStr = BKDateTime.getLocalDateString(Date())
        logString = dateStr + "  [\(logInfo.mode)]: \(log)  ->| \(file_name) - \(function) - \(line)"
        if (log.range(of: "\r\n") != nil) {
            logString = logString.replacingOccurrences(of: "\r\n", with: "")
        }
        logString.append("\n")

        BHGululuLog().writeToLogFile(logString)
    }

    func handle_file_to_get_last_file_name(_ file: String) -> String {
        guard isValidString(file) else{
            return "invaild string"
        }
        let file_array = file.components(separatedBy: "/")
        for str: String in file_array{
            if str.contains(".swift"){
                return str
            }
        }
        return file_array.last!
    }

    func BH_INFO_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.info, logString, file, line, function)
    }

    func BH_DEBUG_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.debug, logString, file, line, function)
    }

    func BH_WARNING_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.warning, logString, file, line, function)
    }

    func BH_ERROR_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.error, logString, file, line, function)
    }

    func BH_CRITICAL_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.critical, logString, file, line, function)
    }

    func BH_PAIR_LOG(_ logString: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        BH_Log_New(.pair, logString, file, line, function)
    }

    func getLogInfo(_ logLevel: LogLevel) -> (mode: String, fileName: String)
    {
        var logMode: String = ""
        var logName: String = ""
        
        switch logLevel {
        case .debug:
            logMode     = "Debug"
            logName     = "debug.log"
        case .info:
            logMode     = "Info"
        case .warning:
            logMode     = "Warning"
        case .error:
            logMode     = "Error"
        case .critical:
            logMode     = "Critical"
        case .pair:
            logMode     = "Pair"
        }
        
        if logName == "" { logName = gululu_log_name }
        
        return (logMode, logName)
    }

    func printLog<T>(_ message: T, file: String = #file, method: String = #function, line:Int = #line) {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
