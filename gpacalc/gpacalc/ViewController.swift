//
//  ViewController.swift
//  gpacalc
//
//  Created by Matt Argao on 2/13/17.
//  Copyright © 2017 Matt Argao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var aPointField: UITextField!
    @IBOutlet weak var aMaxField: UITextField!
    @IBOutlet weak var aPercentField: UITextField!
    @IBOutlet weak var mPointField: UITextField!
    @IBOutlet weak var mMaxField: UITextField!
    @IBOutlet weak var mPercentField: UITextField!
    @IBOutlet weak var fPointField: UITextField!
    @IBOutlet weak var fMaxField: UITextField!
    @IBOutlet weak var fPercentField: UITextField!
    @IBOutlet weak var credits: UITextField!
    @IBOutlet weak var courseNum: UITextField!
    @IBOutlet weak var course1: UILabel!
    @IBOutlet weak var course2: UILabel!
    @IBOutlet weak var course3: UILabel!
    @IBOutlet weak var course4: UILabel!
    @IBOutlet weak var course1Grade: UIImageView!
    @IBOutlet weak var course2Grade: UIImageView!
    @IBOutlet weak var course3Grade: UIImageView!
    @IBOutlet weak var course4Grade: UIImageView!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var gpaTotal: UILabel!
 
    
    
    var courseArray = [Course]()
    var assessment: Assessment!
    
    @IBAction func addCourse(_ sender: UIButton) {
        if (courseArray.count == 4) {
            let alert = UIAlertController(title: "Error", message: "Only 4 courses max!", preferredStyle: .alert)
            
            let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(myAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            
            if let aWeight = Double(aPercentField.text!), let mWeight = Double(mPercentField.text!), let fWeight = Double(fPercentField.text!), let aPoint = Double(aPointField.text!), let aMax = Double(aMaxField.text!), let mPoint = Double(mPointField.text!), let mMax = Double(mMaxField.text!), let fPoint = Double(fPointField.text!), let fMax = Double(fMaxField.text!), let credit = Int(credits.text!), credit > 0, credit < 5 {
                let sum = aWeight + mWeight + fWeight
                
                if sum == 100 {
                    
                    if checkDuplicateName(courseArray: courseArray, courseToCheck: titleField.text!) {
                        let alert = UIAlertController(title: "Error", message: "Duplicate course names are not allowed.", preferredStyle: .alert)
                        
                        let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        alert.addAction(myAction)
                        
                        present(alert, animated: true, completion: nil)
                    } else {
                        let course = Course(title: titleField.text!, aPoint: aPoint, aMax: aMax, aPercent: aWeight, mPoint: mPoint, mMax: mMax, mPercent: mWeight, fPoint: fPoint, fMax: fMax, fPercent: fWeight, credits: credit)
                        
                        courseArray.append(course)
                        
                        let assessment = Assessment(courseArray: courseArray)
                        
                        gpaTotal.text = String(assessment.calculateGPA())
                        refreshCourseList(courseArray: courseArray)
                        refreshGpaColor(total: assessment.calculateGPA())
                        gpaTotal.isHidden = false
                        delButton.isHidden = false
                        courseNum.isHidden = false
                    }

                } else {
                    let alert = UIAlertController(title: "Error", message: "% Weight of grades must equal 100!", preferredStyle: .alert)
                    
                    let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    alert.addAction(myAction)
                    
                    present(alert, animated: true, completion: nil)
                }
                
            } else {
                
                let alert = UIAlertController(title: "Error", message: "Invalid input!", preferredStyle: .alert)
                
                let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(myAction)
                
                present(alert, animated: true, completion: nil)
                
            }
            

        }
    }
    
 
    @IBAction func delCourse(_ sender: UIButton) {
        if (courseArray.count > 0) {
            
            if let courseToDel = Int(courseNum.text!), courseToDel > 0, courseToDel <= courseArray.count {
                
                courseArray.remove(at: Int(courseToDel) - 1)
                let assessment = Assessment(courseArray: courseArray)
                if (courseArray.count != 0) {
                    gpaTotal.text = String(assessment.calculateGPA())
                } else {
                    gpaTotal.isHidden = true
                }
                refreshCourseList(courseArray: courseArray)
                refreshGpaColor(total: assessment.calculateGPA())
                
                if courseArray.count == 0 {
                    delButton.isHidden = true
                    courseNum.isHidden = true
                    gpaTotal.isHidden = true
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Invalid input!", preferredStyle: .alert)
                
                let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(myAction)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func checkDuplicateName(courseArray: [Course], courseToCheck: String) -> Bool {
        var courseNames = [String]()
        
        for course in courseArray {
            courseNames.append(course.title)
        }
        
        for names in courseNames {
            if courseToCheck == names {
                return true
            }
        }
        return false
    }
    
    func refreshGpaColor(total: Double) {
        if (courseArray.count != 0) {
            if (total < 2.0) {
                gpaLabel.textColor = UIColor.red
                gpaTotal.textColor = UIColor.red
            } else if (total < 3.0) {
                gpaLabel.textColor = UIColor.orange
                gpaTotal.textColor = UIColor.orange
            } else {
                gpaLabel.textColor = UIColor.green
                gpaTotal.textColor = UIColor.green
            }
        } else {
            gpaLabel.textColor = UIColor.white
            gpaTotal.textColor = UIColor.white
        }
    }
    
    
    func refreshCourseList(courseArray: [Course]) {
        
        if courseArray.count == 4 {
            course1.isHidden = false
            course1.text = "1) \(courseArray[0].title) | \(courseArray[0].credits)"
            course1Grade.image = fetchGradeImage(course: courseArray[0])
            course1Grade.isHidden  = false
            
            course2.isHidden = false
            course2.text = "2) \(courseArray[1].title) | \(courseArray[1].credits)"
            course2Grade.image = fetchGradeImage(course: courseArray[1])
            course2Grade.isHidden  = false
            
            course3.isHidden = false
            course3.text = "3) \(courseArray[2].title) | \(courseArray[2].credits)"
            course3Grade.image = fetchGradeImage(course: courseArray[2])
            course3Grade.isHidden  = false
            
            course4.isHidden = false
            course4.text = "4) \(courseArray[3].title) | \(courseArray[3].credits)"
            course4Grade.image = fetchGradeImage(course: courseArray[3])
            course4Grade.isHidden  = false
            
        } else if courseArray.count == 3 {
            course1.isHidden = false
            course1.text = "1) \(courseArray[0].title) | \(courseArray[0].credits)"
            course1Grade.image = fetchGradeImage(course: courseArray[0])
            course1Grade.isHidden  = false
            
            course2.isHidden = false
            course2.text = "2) \(courseArray[1].title) | \(courseArray[1].credits)"
            course2Grade.image = fetchGradeImage(course: courseArray[1])
            course2Grade.isHidden  = false
            
            course3.isHidden = false
            course3.text = "3) \(courseArray[2].title) | \(courseArray[2].credits)"
            course3Grade.image = fetchGradeImage(course: courseArray[2])
            course3Grade.isHidden  = false
            
            course4Grade.isHidden = true
            course4.isHidden = true
        } else if courseArray.count == 2 {
            course1.isHidden = false
            course1.text = "1) \(courseArray[0].title) | \(courseArray[0].credits)"
            course1Grade.image = fetchGradeImage(course: courseArray[0])
            course1Grade.isHidden  = false
            
            course2.isHidden = false
            course2.text = "2) \(courseArray[1].title) | \(courseArray[1].credits)"
            course2Grade.image = fetchGradeImage(course: courseArray[1])
            course2Grade.isHidden  = false
            
            course3Grade.isHidden = true
            course3.isHidden = true
            course4Grade.isHidden = true
            course4.isHidden = true
        } else if courseArray.count == 1 {
            course1.isHidden = false
            course1.text = "1) \(courseArray[0].title) | \(courseArray[0].credits)"
            course1Grade.image = fetchGradeImage(course: courseArray[0])
            course1Grade.isHidden  = false
            
            course2Grade.isHidden = true
            course2.isHidden = true
            course3Grade.isHidden = true
            course3.isHidden = true
            course4Grade.isHidden = true
            course4.isHidden = true
        } else {
            course1Grade.isHidden = true
            course1.isHidden = true
            course2Grade.isHidden = true
            course2.isHidden = true
            course3Grade.isHidden = true
            course3.isHidden = true
            course4Grade.isHidden = true
            course4.isHidden = true
        }
        
    }
    
    func fetchGradeImage(course: Course) -> UIImage? {
        
        let grade = course.calculateGrade()
        
        switch grade {
            case "A":
                return UIImage(named: "grade_a.png")!
            case "B":
                return UIImage(named: "grade_b.png")!
            case "C":
                return UIImage(named: "grade_c.png")!
            case "D":
                return UIImage(named: "grade_d.png")!
            case "F":
                return UIImage(named: "grade_f.png")!
            default:
                return nil
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleField.delegate = self
        aPointField.delegate = self
        aMaxField.delegate = self
        aPercentField.delegate = self
        mPointField.delegate = self
        mMaxField.delegate = self
        mPercentField.delegate  = self
        fPointField.delegate = self
        fMaxField.delegate = self
        fPercentField.delegate  = self
        credits.delegate = self
        courseNum.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class Course {
    var title: String
    var aPoint: Double
    var aMax: Double
    var aPercent: Double
    var mPoint: Double
    var mMax: Double
    var mPercent: Double
    var fPoint: Double
    var fMax: Double
    var fPercent: Double
    var credits: Int
    
    init(title:String, aPoint:Double, aMax:Double, aPercent:Double, mPoint:Double, mMax:Double, mPercent:Double, fPoint:Double, fMax:Double, fPercent:Double, credits:Int) {
        self.title = title
        self.aPoint = aPoint
        self.aMax = aMax
        self.aPercent = aPercent
        self.mPoint = mPoint
        self.mMax = mMax
        self.mPercent = mPercent
        self.fPoint = fPoint
        self.fMax = fMax
        self.fPercent = fPercent
        self.credits = credits
    }
    
    func calculateGrade() -> String {
        let aGrade = aPoint/aMax
        let mGrade = mPoint/mMax
        let fGrade = fPoint/fMax
        
        let total = (aGrade * aPercent) + (mGrade * mPercent) + (fGrade * fPercent)
        
        if (total < 60) {
            return "F"
        } else if (total < 70) {
            return "D"
        } else if (total < 80) {
            return "C"
        } else if (total < 90) {
            return "B"
        } else {
            return "A"
        }
        
    }
}

class Assessment {
    var courseArray: [Course]
    
    init(courseArray: [Course]) {
        self.courseArray = courseArray
    }
    
    func calculateGPA() -> Double {
        var gpaArray = [Double]()
        var gpa: Double
        
        for i in 0 ..< courseArray.count {
            let grade = courseArray[i].calculateGrade()
            
            if (grade == "A") {
                gpa = 4.0
            } else if (grade == "B") {
                gpa = 3.0
            } else if (grade == "C") {
                gpa = 2.0
            } else if (grade == "D") {
                gpa = 1.0
            } else {
                gpa = 0.0
            }
            
            gpaArray.append(gpa)
            
        }
        
        var totalgpa = 0.0
        
        for i in 0 ..< gpaArray.count {
            totalgpa += gpaArray[i]
        }
        
        let roundgpa = round(100.0*totalgpa/Double(gpaArray.count))/100.0
        
        return(roundgpa)
        
    }
    
}




















