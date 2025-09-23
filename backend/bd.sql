use gradiente;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS goal;
DROP TABLE IF EXISTS habit_register;
DROP TABLE IF EXISTS user_habit;
DROP TABLE IF EXISTS habit;
DROP TABLE IF EXISTS register_type;
DROP TABLE IF EXISTS habit_type;
DROP TABLE IF EXISTS user;

SET FOREIGN_KEY_CHECKS = 1;


select user from user where 

CREATE TABLE user (
    user INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    wake_up TIME,
    go_to_bed TIME,
    add_date DATE
);

CREATE TABLE habit_type (
    habit_type INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL -- build o quit
);

CREATE TABLE register_type (
    register_type INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE habit (
    habit INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(10),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    habit_type INT,
    units VARCHAR(100) NOT NULL,
    FOREIGN KEY (habit_type) REFERENCES habit_type(habit_type)
);

CREATE TABLE user_habit (
	user_habit INT AUTO_INCREMENT PRIMARY KEY,
    user INT NOT NULL,
    habit INT NOT NULL,
    register_type INT NOT NULL,
    quantity_register INT, 
    add_date DATE,
    FOREIGN KEY (user) REFERENCES user(user),
    FOREIGN KEY (habit) REFERENCES habit(habit),
    FOREIGN KEY (register_type) REFERENCES register_type(register_type)
);

CREATE TABLE habit_register (
	habit_register INT AUTO_INCREMENT PRIMARY KEY,
    user_habit INT NOT NULL,
    amount INT,
    add_date DATE,
    FOREIGN KEY (user_habit) REFERENCES user_habit(user_habit)
);

CREATE TABLE goal (
    goal INT AUTO_INCREMENT PRIMARY KEY,
    user_habit INT NOT NULL,
    quantity INT,
    days INT,
    actual boolean,
    add_date DATE,
    FOREIGN KEY (user_habit) REFERENCES user_habit(user_habit)
);

-- creación de registro de goals <- llevar un registro de todos los goals para que se observe como estos van cambiando en el tiempo
 

select * from user_habit;

-- 


-- Limpiar datos antes de insertar
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE goal;
TRUNCATE TABLE habit_register;
TRUNCATE TABLE user_habit;
TRUNCATE TABLE habit;
TRUNCATE TABLE register_type;
TRUNCATE TABLE habit_type;
TRUNCATE TABLE user;
SET FOREIGN_KEY_CHECKS = 1;

-- Users
INSERT INTO user (name, age, wake_up, go_to_bed, add_date) VALUES
('Alice Johnson', 25, '06:30:00', '23:00:00', CURDATE()),
('Michael Smith', 30, '07:00:00', '22:30:00', CURDATE()),
('Laura Davis', 28, '05:45:00', '22:00:00', CURDATE());

-- Habit Types
INSERT INTO habit_type (name) VALUES
('build'),
('quit');

-- Register Types
INSERT INTO register_type (name) VALUES
('sum_amount'),
('put_amount');

-- Habits
INSERT INTO habit (icon, name, description, habit_type, units) VALUES
('🏃', 'Running', 'Daily running sessions to improve cardio', 1, 'km'),
('📚', 'Reading', 'Reading for knowledge and relaxation', 1, 'minutes'),
('💧', 'Drink Water', 'Drinking enough water during the day', 1, 'cups'),
('🚬', 'Quit Smoking', 'Reducing or quitting smoking habits', 2, 'cigarettes'),
('🍔', 'Avoid Junk Food', 'Reducing fast food intake', 2, 'meals');

-- User Habits
INSERT INTO user_habit (user, habit, register_type, quantity_register, add_date) VALUES
(1, 1, 1, 1, CURDATE()),   -- Alice: Running
(1, 2, 2, NULL, CURDATE()),-- Alice: Reading (manual input)
(1, 3, 1, 1, CURDATE()),   -- Alice: Drink Water
(2, 4, 2, NULL, CURDATE()),-- Michael: Quit Smoking (manual input)
(3, 5, 1, 1, CURDATE());   -- Laura: Avoid Junk Food

-- Habit Registers
INSERT INTO habit_register (user_habit, amount, add_date) VALUES
(1, 2, CURDATE()),   -- Alice ran 2 km
(2, 30, CURDATE()),  -- Alice read 30 minutes
(3, 5, CURDATE()),   -- Alice drank 5 cups water
(4, 3, CURDATE()),   -- Michael smoked 3
(5, 1, CURDATE());   -- Laura ate 1 junk meal

-- Goals
INSERT INTO goal (user_habit, actual, add_date) VALUES
(1, TRUE, CURDATE()),
(2, TRUE, CURDATE()),
(3, TRUE, CURDATE()),
(4, TRUE, CURDATE()),
(5, TRUE, CURDATE());

-- ----------------------- Se dice que hay que asociar a los usuarios con el firebase uid


ALTER TABLE user ADD COLUMN firebase_uid VARCHAR(128) UNIQUE AFTER user;