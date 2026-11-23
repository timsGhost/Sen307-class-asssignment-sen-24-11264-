-- =====================================================================
-- Veritas University, Abuja | Department of Software Engineering
-- VUA-SEN307 Database Systems
-- Week 8 Practical - Lab 6: Aggregate Functions, Grouping and Subqueries
-- Student : Nden timman
-- File    : lab6_queries.sql
-- Tools   : MySQL Server, MySQL Workbench
-- Assumed tables (from Week 6/7):
--   Student(student_id, full_name, dept_id)
--   Department(dept_id, dept_name)
--   Course(course_id, course_title)
--   Enrolment(student_id, course_id)
-- =====================================================================

-- ---------------------------------------------------------------------
-- TASK 1: Count the students enrolled in each course (include empty courses)
-- LEFT JOIN keeps courses with no enrolment rows. For those, e.student_id
-- is NULL, and COUNT(column) ignores NULLs, so the result is 0.
-- COUNT(*) would give 1 because it counts the single NULL-padded row.
-- ---------------------------------------------------------------------
SELECT c.course_title,
       COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
ORDER BY total_students DESC;


-- ---------------------------------------------------------------------
-- TASK 2: Courses with more than N students (HAVING), N = 3, 5 and 7
-- WHERE filters rows before grouping; HAVING filters groups after
-- grouping, so only HAVING can use COUNT().
-- ---------------------------------------------------------------------

-- Threshold 3
SELECT c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 3
ORDER BY total_students DESC;

-- Threshold 5
SELECT c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 5
ORDER BY total_students DESC;

-- Threshold 7
SELECT c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 7
ORDER BY total_students DESC;


-- ---------------------------------------------------------------------
-- TASK 3: Average number of courses per student (including zero-course students)
-- Inner query: courses per student (LEFT JOIN so zero-course students appear
-- with 0). Outer query: average of those counts, rounded to 2 decimals.
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(course_count), 2) AS avg_courses_per_student
FROM (
    SELECT s.student_id,
           COUNT(e.course_id) AS course_count
    FROM Student s
    LEFT JOIN Enrolment e ON s.student_id = e.student_id
    GROUP BY s.student_id
) AS per_student;


-- ---------------------------------------------------------------------
-- TASK 4: Students not enrolled in any course (non-correlated subquery)
-- The inner query runs once and returns the list of enrolled student ids.
-- Compare with the Week 7, Task 3 result (should match).
-- Note: NOT IN returns nothing if the subquery list contains a NULL, so
-- the inner query filters NULLs out for safety.
-- ---------------------------------------------------------------------
SELECT s.student_id, s.full_name
FROM Student s
WHERE s.student_id NOT IN (
    SELECT e.student_id
    FROM Enrolment e
    WHERE e.student_id IS NOT NULL
);


-- ---------------------------------------------------------------------
-- TASK 5: Student with the highest number of enrolments in each department
-- (correlated subquery; ties allowed)
-- The final subquery refers to s.dept_id from the outer query, so it is
-- evaluated for each outer row. It builds each student's course count
-- (LEFT JOIN so zero counts exist) and takes the MAX within s's department.
-- ---------------------------------------------------------------------
SELECT d.dept_name,
       s.full_name,
       (SELECT COUNT(*)
        FROM Enrolment e
        WHERE e.student_id = s.student_id) AS courses
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
WHERE (SELECT COUNT(*)
       FROM Enrolment e
       WHERE e.student_id = s.student_id)
    = (SELECT MAX(x.cnt)
       FROM (
           SELECT s2.student_id,
                  s2.dept_id,
                  COUNT(e2.course_id) AS cnt
           FROM Student s2
           LEFT JOIN Enrolment e2 ON s2.student_id = e2.student_id
           GROUP BY s2.student_id, s2.dept_id
       ) AS x
       WHERE x.dept_id = s.dept_id)
ORDER BY d.dept_name;
