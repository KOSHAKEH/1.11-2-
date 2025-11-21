USE Academy;
GO

-- Тестовые данные (чтобы запросы возвращали результат)
-- Запусти один раз — и всё будет работать!
INSERT INTO Faculties (Name) VALUES ('Computer Science'), ('Mathematics');
INSERT INTO Departments (Name, Financing, FacultyId) VALUES 
('Software Development', 30000, 1), ('Database Systems', 20000, 1);
INSERT INTO Groups (Name, Year, Rating, FacultyId) VALUES 
('P107', 1, 4, 1), ('CS51', 5, 5, 1), ('M201', 2, 3, 2);
INSERT INTO Teachers (Name, Surname, Salary, Premium, EmploymentDate, DepartmentId) VALUES
('Samantha', 'Adams', 1200, 300, '1998-05-10', 1),
('John', 'Doe', 1500, 500, '1995-03-15', 1),
('Mary', 'Smith', 800, 200, '2001-09-01', 2);
INSERT INTO Subjects (Name) VALUES ('Database Theory'), ('C# Programming'), ('Algorithms');
INSERT INTO Lectures (TeacherId, SubjectId, GroupId, LectureRoom) VALUES
(1,1,1,'B103'), (1,2,1,'A201'), (2,1,2,'B103');
INSERT INTO GroupCurators (GroupId, TeacherId) VALUES (1,1), (2,3), (3,2);
GO

-- 1. Все возможные пары преподавателей и групп
SELECT t.Surname + ' ' + t.Name AS Teacher, g.Name AS [Group]
FROM Teachers t CROSS JOIN Groups g;

-- 2. Факультеты, у которых есть кафедры с финансированием > 25000
SELECT DISTINCT f.Name
FROM Faculties f
JOIN Departments d ON f.Id = d.FacultyId
WHERE d.Financing > 25000;

-- 3. Кураторы и их группы
SELECT t.Surname, g.Name AS [Group]
FROM GroupCurators gc
JOIN Teachers t ON gc.TeacherId = t.Id
JOIN Groups g ON gc.GroupId = g.Id;

-- 4. Преподаватели, которые читают у группы P107
SELECT DISTINCT t.Name, t.Surname
FROM Lectures l
JOIN Teachers t ON l.TeacherId = t.Id
WHERE l.GroupId = (SELECT Id FROM Groups WHERE Name = 'P107');

-- 5. Фамилии преподавателей и факультеты, где они работают
SELECT DISTINCT t.Surname, f.Name AS Faculty
FROM Teachers t
JOIN Departments d ON t.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id;

-- 6. Кафедры и группы, относящиеся к ним (через факультет)
SELECT DISTINCT d.Name AS Department, g.Name AS [Group]
FROM Departments d
JOIN Faculties f ON d.FacultyId = f.Id
JOIN Groups g ON g.FacultyId = f.Id;

-- 7. Дисциплины, которые читает Samantha Adams
SELECT s.Name
FROM Lectures l
JOIN Teachers t ON l.TeacherId = t.Id
JOIN Subjects s ON l.SubjectId = s.Id
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams';

-- 8. Кафедры, где читается "Database Theory"
SELECT DISTINCT d.Name
FROM Lectures l
JOIN Subjects s ON l.SubjectId = s.Id
JOIN Teachers t ON l.TeacherId = t.Id
JOIN Departments d ON t.DepartmentId = d.Id
WHERE s.Name = 'Database Theory';

-- 9. Группы факультета Computer Science
SELECT g.Name
FROM Groups g
JOIN Faculties f ON g.FacultyId = f.Id
WHERE f.Name = 'Computer Science';

-- 10. Группы 5-го курса и их факультеты
SELECT g.Name, f.Name AS Faculty
FROM Groups g
JOIN Faculties f ON g.FacultyId = f.Id
WHERE g.Year = 5;

-- 11. Лекции в аудитории B103 (преподаватель, дисциплина, группа)
SELECT 
    t.Name + ' ' + t.Surname AS Teacher,
    s.Name AS Subject,
    g.Name AS [Group]
FROM Lectures l
JOIN Teachers t ON l.TeacherId = t.Id
JOIN Subjects s ON l.SubjectId = s.Id
JOIN Groups g ON l.GroupId = g.Id
WHERE l.LectureRoom = 'B103';