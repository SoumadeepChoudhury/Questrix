//
//  FileManagement.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

class FileManagement {
    
    var masterDirectory: URL
    var COURSESARRAY: CoursesArray
    var USER: User
    var QUIZARRAY: QuizArray
    var BOOKMARK: BookmarkData
    var isRefferedFromEdit: Bool
    var draftDataSet: [String:Any]
    var reDraftedCourseName: String
    var reDraftedTitle: String

    init(coursesArray: CoursesArray = CoursesArray(), quizArray: QuizArray = QuizArray(), user: User = User(),bookmark: BookmarkData = BookmarkData()) {
        self.masterDirectory =
            FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask)[0]
        self.COURSESARRAY = coursesArray
        self.QUIZARRAY = quizArray
        self.USER = user
        self.BOOKMARK = bookmark
        self.isRefferedFromEdit = false
        self.draftDataSet = Dictionary()
        self.reDraftedCourseName = ""
        self.reDraftedTitle = ""
        setUser()
        createMasterDirectory()
        getResultData()
    }

    func setUser(userName: String = "") {
        do {
            if userName.isEmpty {
                var content = try FileManager.default.contentsOfDirectory(atPath: self.masterDirectory.path)
                content.removeAll(where: { $0 == (".DS_Store") })
                content.removeAll(where: { $0 == (".resultData") })
                content.removeAll(where: { $0 == (".bookmarkData") })
                if content.isEmpty {
                    self.masterDirectory = self.masterDirectory.appendingPathComponent(".user")
                }else{
                    self.masterDirectory = self.masterDirectory.appendingPathComponent(content[0])
                    let displayName = content[0].replacingOccurrences(of: "_", with: " ").capitalized
                    self.USER.UserName = displayName.replacingOccurrences(of: ".", with: "")
                    
                }
            }else{
                let improvedUserName = userName.replacingOccurrences(of: " ", with: "_").lowercased()
                let finalPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".\(improvedUserName)")
                try FileManager.default.moveItem(at: self.masterDirectory, to: finalPath)
                self.masterDirectory = finalPath
                self.USER.UserName = userName
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func createMasterDirectory() {
        if !FileManager.default.fileExists(atPath: self.masterDirectory.path) {
            try! FileManager.default.createDirectory(
                at: self.masterDirectory, withIntermediateDirectories: true)
        }
    }

    func createCourses(courseName: String) -> String {
        do {
            if !FileManager.default.fileExists(
                atPath: self.masterDirectory.path + "/\(courseName)")
            {
                try FileManager.default.createDirectory(
                    at: self.masterDirectory.appendingPathComponent(courseName),
                    withIntermediateDirectories: true)
                COURSESARRAY.courses.append(
                    CourseData(
                        title: courseName, drafts: 0, quizzes: 0, attempted: 0))
                return "Created"
            } else {
                return "Exist"
            }
        } catch {
            print(error.localizedDescription)
            return "Error"
        }
    }

    func createQuiz(
        course: String,
        title: String,
        description: String,
        questionData: [[String: Any]],
        duration: Int,
        publishDate: Date,
        isDrafted: Bool = false
    ) {
        do {
            let tempListOfQuizzes = try FileManager.default.contentsOfDirectory(atPath: self.masterDirectory.path + "/\(course)")
            for q in tempListOfQuizzes {
                if(q.contains(title) && !q.starts(with: ".")){
                    self.deleteQuiz(course: course, title: title)
                    break
                }
            }
            let dataDictionary: [String: Any] = [
                "Course": course,
                "Title": title,
                "Description": description,
                "QuestionData": questionData,
                "Duration": duration,
                "PublishDate": publishDate,
            ]
            let filePath =
                "\(self.masterDirectory.path)/\(course)/\(title).\(isDrafted ? "draft" : "quiz")"

            try NSKeyedArchiver.archivedData(
                withRootObject: dataDictionary, requiringSecureCoding: false
            ).write(to: URL(fileURLWithPath: filePath))
            
            if(isDrafted){
                self.setDraftDataSet(course: self.reDraftedCourseName, title: self.reDraftedTitle, isReDrafted: true)
                self.reDraftedCourseName = ""
                self.reDraftedTitle = ""
            }
            
            self.QUIZARRAY.quizzes.append(
                QuizData(
                    course: course, title: title, description: "",
                    duration: duration, releaseDate: publishDate,
                    questionsData: questionData,isDrafted: isDrafted))
            
            self.getCourses()

        } catch {
            print(error.localizedDescription)
        }
    }

    func getQuizData(courseName: String, title: String, ext: String) -> [String:
        Any]
    {
        //Getting data of a single quiz by opening the file.
        let filePath =
            "\(self.masterDirectory.path)/\(courseName)/\(title).\(ext)"
        var dataDict: [String: Any] = Dictionary()
        if FileManager.default.fileExists(atPath: filePath) {
            dataDict =
                (NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
                as? [String: Any])!
            //            let courses = dataDict!["Course"] as? String
            //            let title = dataDict!["Title"] as? String
            //            let questions = dataDict!["Questions"] as? [[String: Any]]
        }
        //        print("Course: ",courses!)
        //        print("Title: ",title!)
        //        for question in questions!{
        //            print("Question: ",question["question"]!)
        //        }
        return dataDict
    }
    
    func getDraftedQuizCount(course: String) -> Int {
        var total = 0
        let quizzes =  getQuizzes(selectedCourse: course)
        for quiz in quizzes {
            if quiz.isDrafted == true {
                total += 1
            }
        }
        return total

    }
    
    func getAttemptedQuizCount(course: String = "") -> Int {
        var total = 0
        if(!course.isEmpty){
            let quizzes =  getQuizzes(selectedCourse: course)
            for quiz in quizzes {
                if quiz.isAttempted == true {
                    total += 1
                }
            }
        }else{
            let contents = try! FileManager.default.contentsOfDirectory(
                atPath: self.masterDirectory.path)
            for content in contents {
                if !content.contains(".DS_Store") {
                    let quizzes = try! FileManager.default.contentsOfDirectory(atPath: self.masterDirectory.path+"/\(content)")
                    for quiz in quizzes{
                        if(quiz.contains(".attempted")){
                            total += 1
                        }
                    }
                }
            }
        }
        return total

    }
    
    func getTotalNewQuizCount(course: String) -> Int {
        var total = 0
        let quizzes =  getQuizzes(selectedCourse: course)
        for quiz in quizzes {
            if quiz.isAttempted == false && quiz.isDrafted == false {
                total += 1
            }
        }
        return total
    }

    func getCourses() {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                atPath: self.masterDirectory.path)
            COURSESARRAY.courses = []
            for content in contents {
                if !content.contains(".DS_Store") {
                    COURSESARRAY.courses.append(
                        CourseData(
                            title: content, drafts: getDraftedQuizCount(course: content),
                            quizzes: getTotalNewQuizCount(course: content),
                            attempted: getAttemptedQuizCount(course: content))
                    )
                }
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    func getQuizzes(selectedCourse: String) -> [QuizData] {

        var quizzes: [QuizData] = []

        do {
            let contents = try FileManager.default.contentsOfDirectory(
                atPath: self.masterDirectory.path + "/" + selectedCourse)
            for content in contents {
                if !content.contains(".DS_Store") && !content.starts(with: ".") {
                    let seperated_Title_Ext = content.split(separator: ".")

                    let quizDetails: [String: Any] = getQuizData(
                        courseName: selectedCourse,
                        title: String(seperated_Title_Ext[0]),
                        ext: String(seperated_Title_Ext[1]))
                    quizzes.append(
                        QuizData(
                            course: quizDetails["Course"] as! String,
                            title: quizDetails["Title"] as! String,
                            description: quizDetails["Description"] as! String,
                            duration: quizDetails["Duration"] as! Int,
                            releaseDate: quizDetails["PublishDate"] as! Date,
                            questionsData: quizDetails["QuestionData"]
                                as! [[String: Any]],
                            isAttempted: seperated_Title_Ext[1] == "attempted"
                            ? true : false,
                            isDrafted: seperated_Title_Ext[1] == "draft" ? true : false
                        ))
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        return quizzes
    }

    func getAllQuizzes() {
        //Provide total no of all exixting quizzes in all the courses present
        //        var total = 0
        do {
            self.QUIZARRAY.quizzes = []
            let courseList = try FileManager.default.contentsOfDirectory(
                atPath: self.masterDirectory.path)
            for course in courseList {
                if !course.contains(".DS_Store") {
                    //                    var quizzes = try FileManager.default.contentsOfDirectory(atPath: self.masterDirectory.path+"/\(course)")
                    //                    quizzes.removeAll(where: {$0.contains(".DS_Store")})
                    //                    total += quizzes.count
                    let quizzes = self.getQuizzes(selectedCourse: course)
                    for quiz in quizzes {
                        self.QUIZARRAY.quizzes.append(quiz)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        //        return total
    }

    func deleteCourse(courseName: String) -> Bool {
        //Delete
        var isDeleted = false
        do {
            if FileManager.default.fileExists(
                atPath: self.masterDirectory.path + "/\(courseName)")
            {
                try FileManager.default.removeItem(
                    atPath: self.masterDirectory.path + "/\(courseName)")
                isDeleted = true
                COURSESARRAY.courses.removeAll(where: { $0.title == courseName })
                self.getAllQuizzes()
                self.updateBookmarks(course: courseName, title: "", desc: "", bookmarkedQuestions: [], isCourseDeleted: true)

            }
        } catch {
            isDeleted = false
            print(error.localizedDescription)
        }
        return isDeleted
    }

    func deleteQuiz(course: String, title: String,isSubmitted: Bool = true) {
        //Delete Quiz
        do {
            var filePath = self.masterDirectory.path + "/\(course)/"
            let contents = try FileManager.default.contentsOfDirectory(
                atPath: filePath)
            for content in contents {
                if content.contains(title) && !content.starts(with: "."){
                     if !isSubmitted {
                         for c in contents{
                             var fPath = ""
                             if(c.starts(with: ".") && c.contains(title)){
                                 fPath += self.masterDirectory.path + "/\(course)/\(c)"
                                 try FileManager.default.removeItem(atPath: fPath)
                             }
                         }
                     }
                    filePath += content
                    break
                }
            }
            
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
                self.getAllQuizzes()
                self.getCourses()
                self.updateBookmarks(course: course, title: title, desc: "", bookmarkedQuestions: [])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setDraftDataSet(course: String,title: String,isReDrafted: Bool = false){
        if(isReDrafted){
            self.QUIZARRAY.quizzes.removeAll(where: {$0.course == course && $0.title == title})
        }else{
            self.reDraftedCourseName = course
            self.reDraftedTitle = title
            let data = self.getQuizData(courseName: course, title: title, ext: "draft")
            
            //Append in Dictionary
            self.draftDataSet.updateValue(data["Course"] as! String, forKey: "Course")
            self.draftDataSet.updateValue(data["Title"] as! String, forKey: "Title")
            self.draftDataSet.updateValue(data["Description"] as! String, forKey: "Description")
            self.draftDataSet.updateValue("\(data["Duration"] as! Int)", forKey: "Duration")
            self.draftDataSet.updateValue(data["PublishDate"] as! Date, forKey: "Release Date")
            self.draftDataSet.updateValue(data["QuestionData"] as! [[String:Any]], forKey: "Question Data")
        }
    }
    
    
    func getDataFromDraft(item: String) -> Any {
        return draftDataSet[item] ?? ""
    }
    
 
    func updateExistingQuizToAttempted(
        course: String,
        title: String,
        description: String,
        questionData: [[String: Any]],
        latestGivenAnswers: [String],
        duration: Int,
        publishDate: Date
    ){
        self.deleteQuiz(course: course, title: title)
        do {
            let dataDictionary: [String: Any] = [
                "Course": course,
                "Title": title,
                "Description": description,
                "QuestionData": questionData,
                "LatestAnswers": latestGivenAnswers,
                "Duration": duration,
                "PublishDate": publishDate,
            ]
            let filePath =
                "\(self.masterDirectory.path)/\(course)/\(title).attempted"

            try NSKeyedArchiver.archivedData(
                withRootObject: dataDictionary, requiringSecureCoding: false
            ).write(to: URL(fileURLWithPath: filePath))
            
            
            self.QUIZARRAY.quizzes.append(
                QuizData(
                    course: course, title: title, description: "",
                    duration: duration, releaseDate: publishDate,
                    questionsData: questionData,isAttempted: true))
            
            self.getCourses()

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateQuizResultData(resultData: [String:Any]) {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".resultData").path
        var existingData: [[String:Any]] = []
        do{
            //get data by unarchiving
            if(FileManager.default.fileExists(atPath: filePath)){
                existingData = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String: Any]])!
            }
            //Append Data with the existing
            existingData.append(resultData)
            //Archive the data
            try NSKeyedArchiver.archivedData(
                withRootObject: existingData, requiringSecureCoding: false
            ).write(to: URL(fileURLWithPath: filePath))
            getResultData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getResultData() {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".resultData").path
        if(FileManager.default.fileExists(atPath: filePath)){
            let resultData: [[String:Any]] = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String: Any]])!
            var counter: Int = 1
            USER.resultData = []
            USER.activityData = []
            var datesAdded: [String] = []
            for item in resultData.reversed(){
                //Points
                USER.MyPoints += item["Points Scored"] as! Int
                
                //Result Data
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let date = dateFormatter.string(from: item["Date Attempted"] as! Date)
                
                let title: String = item["Course"] as! String + "/\(item["Title"]!)"
                if(counter <= 10){
                    USER.resultData.append(ResultData(slno: counter, title: title, date: date, totalPoints: item["Total Points"] as? Int ?? 0, pointsAcquired: item["Points Scored"] as? Int ?? 0))
                    counter += 1
                }
                
                //ActivityData
                if(!datesAdded.contains(date)){
                    var freq: Int = 0
                    for res in resultData{
                        if(date == dateFormatter.string(from: res["Date Attempted"] as! Date)){
                            freq += 1
                            datesAdded.append(date)
                        }
                    }
                    USER.activityData.append(UserActivity(type: date, value: freq))
                    if(USER.activityData.count > 7){
                        USER.activityData.remove(at: 0)
                    }
                    if(freq > USER.MaxActivityYScale){
                        USER.MaxActivityYScale = freq
                    }
                }
                
                
            }
        }

    }
    
    
    func updateBookmarks(course: String,title: String,desc: String,bookmarkedQuestions: [[String:Any]],isCourseDeleted: Bool = false){
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".bookmarkData").path
        var existingData: [[String:Any]] = []
        var done: Bool = false
        do{
            //get data by unarchiving
            if(FileManager.default.fileExists(atPath: filePath)){
                existingData = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String:Any]])!
            }
            //Append Data with the existing
            for index in 0..<existingData.count{
                if isCourseDeleted && existingData[index]["Course"] as! String == course{
                    existingData.remove(at: index)
                    done = true
                    break
                }
                else if(existingData[index]["Course"] as! String == course && existingData[index]["Title"] as! String == title){
                    if(bookmarkedQuestions.isEmpty){
                        existingData.remove(at: index)
                    }else{
                        existingData[index]["QuestionData"] = bookmarkedQuestions
                    }
                    done = true
                    break
                }
            }
            if !done && !bookmarkedQuestions.isEmpty {
//                existingData.append(Bookmark(course: course, title: title, decripton: "", questionData: bookmarkedQuestions))
                existingData.append([
                    "Course": course,
                    "Title": title,
                    "QuestionData": bookmarkedQuestions
                ])
            }
            //Archive the data
            try NSKeyedArchiver.archivedData(
                withRootObject: existingData, requiringSecureCoding: false
            ).write(to: URL(fileURLWithPath: filePath))
            getBookmarks()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getBookmarks(){
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".bookmarkData").path
        //get data by unarchiving
        if(FileManager.default.fileExists(atPath: filePath)){
            let data: [[String:Any]] = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String:Any]])!
            self.BOOKMARK.bookmarks = []
            for item in data{
                if(!(item["QuestionData"] as! [[String:Any]]).isEmpty){
                    self.BOOKMARK.bookmarks.append(Bookmark(course: item["Course"] as! String, title: item["Title"] as! String, questionData: item["QuestionData"] as! [[String:Any]]))
                }
            }
        }
    }
    
    
    func saveImage(
        filePath: String,
        course: String,
        title: String,
        number: Int,
        ext: String
    ){
        do{
            if(FileManager.default.fileExists(atPath: self.masterDirectory.path+"/\(course)/.\(title)_image_\(number).\(ext)")){
                try FileManager.default.removeItem(atPath: self.masterDirectory.path+"/\(course)/.\(title)_image_\(number).\(ext)")
            }
            try FileManager.default.copyItem(atPath: filePath, toPath: self.masterDirectory.path+"/\(course)/.\(title)_image_\(number).\(ext)")
        }catch {
            print(error.localizedDescription)
        }
    }
}
