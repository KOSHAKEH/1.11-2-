CREATE DATABASE Academy;
GO
USE Academy;
GO

-- 1. Факультеты
CREATE TABLE Faculties (
    Id   INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LTRIM(RTRIM(Name)) <> '')
);

-- 2. Кафедры
CREATE TABLE Departments (
    Id         INT IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL UNIQUE CHECK (LTRIM(RTRIM(Name)) <> ''),
    Financing  MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    FacultyId  INT NOT NULL
);

-- 3. Группы
CREATE TABLE Groups (
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    Name      NVARCHAR(10) NOT NULL UNIQUE CHECK (LTRIM(RTRIM(Name)) <> ''),
    Year      INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    Rating    INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
    FacultyId INT NOT NULL
);

-- 4. Преподаватели
CREATE TABLE Teachers (
    Id             INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(Name)) <> ''),
    Surname        NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(Surname)) <> ''),
    Salary         MONEY NOT NULL CHECK (Salary > 0),
    Premium        MONEY NOT NULL DEFAULT 0 CHECK (Premium >= 0),
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    DepartmentId   INT NULL
);

-- 5. Дисциплины
CREATE TABLE Subjects (
    Id   INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);

-- 6. Лекции (кто, что, у кого, где)
CREATE TABLE Lectures (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    TeacherId    INT NOT NULL,
    SubjectId    INT NOT NULL,
    GroupId      INT NOT NULL,
    LectureRoom  NVARCHAR(10) NOT NULL
);

-- 7. Кураторы групп
CREATE TABLE GroupCurators (
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    GroupId   INT NOT NULL,
    TeacherId INT NOT NULL,
    CONSTRAINT UQ_GroupCurator UNIQUE (GroupId)  -- одна группа — один куратор
);

-- Внешние ключи
ALTER TABLE Departments ADD CONSTRAINT FK_Departments_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(Id);
ALTER TABLE Groups ADD CONSTRAINT FK_Groups_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(Id);
ALTER TABLE Teachers ADD CONSTRAINT FK_Teachers_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id);

ALTER TABLE Lectures ADD CONSTRAINT FK_Lectures_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id);
ALTER TABLE Lectures ADD CONSTRAINT FK_Lectures_Subjects FOREIGN KEY (SubjectId) REFERENCES Subjects(Id);
ALTER TABLE Lectures ADD CONSTRAINT FK_Lectures_Groups   FOREIGN KEY (GroupId)   REFERENCES Groups(Id);

ALTER TABLE GroupCurators ADD CONSTRAINT FK_GC_Groups   FOREIGN KEY (GroupId)   REFERENCES Groups(Id);
ALTER TABLE GroupCurators ADD CONSTRAINT FK_GC_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id);

PRINT 'База данных Academy полностью готова для всех домашних заданий!';