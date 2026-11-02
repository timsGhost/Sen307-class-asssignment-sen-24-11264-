CREATE DATABASE IF NOT EXISTS sen307_2411264;
USE sen307_2411264;

CREATE TABLE Lecturer (
    lecturer_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_no VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    dept_id INT NOT NULL,
    CONSTRAINT fk_lecturer_department
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
) ENGINE=InnoDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    matric_no VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('M','F'),
    date_of_birth DATE,
    dept_id INT,
    CONSTRAINT fk_student_department
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
) ENGINE=InnoDB;

CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_title VARCHAR(150) NOT NULL,
    credit_units TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    dept_id INT,
    CONSTRAINT fk_course_department
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
) ENGINE=InnoDB;

CREATE TABLE Enrolment (
    enrolment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_session VARCHAR(9) NOT NULL DEFAULT '2026/2027',
    semester ENUM('First','Second') NOT NULL DEFAULT 'First',
    enrolled_on DATE DEFAULT (CURRENT_DATE),
    UNIQUE (student_id, course_id, academic_session),
    CONSTRAINT fk_enrolment_student
        FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enrolment_course
        FOREIGN KEY (course_id) REFERENCES Course(course_id)
) ENGINE=InnoDB;

CREATE TABLE CourseAllocation (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    lecturer_id INT NOT NULL,
    academic_session VARCHAR(9) NOT NULL DEFAULT '2026/2027',
    UNIQUE (course_id, lecturer_id, academic_session),
    CONSTRAINT fk_allocation_course
        FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT fk_allocation_lecturer
        FOREIGN KEY (lecturer_id) REFERENCES Lecturer(lecturer_id)
) ENGINE=InnoDB;

ALTER TABLE Student
    ADD COLUMN phone VARCHAR(15) AFTER full_name;

ALTER TABLE Course
    ADD CONSTRAINT chk_credit_units
    CHECK (credit_units BETWEEN 1 AND 6);

SHOW TABLES;
DESCRIBE Department;
DESCRIBE Lecturer;
DESCRIBE Student;
DESCRIBE Course;
DESCRIBE Enrolment;
DESCRIBE CourseAllocation;
SHOW CREATE TABLE Enrolment;
