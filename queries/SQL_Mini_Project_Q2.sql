CREATE DATABASE dom_db

USE dom_db

-- Question 2.1 --
-- Create a table to store the name, university, course, and mark for spartans.
CREATE TABLE spartans_table
(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    university_name VARCHAR(15),
    course_taken VARCHAR(15),
    mark_achieved INT
)

-- Question 2,2 --
-- Insert values into the table.
INSERT INTO spartans_table
(first_name, last_name, university_name, course_taken, mark_achieved)
VALUES
('Dominic', 'Cogan-Tucker', 'Birmingham', 'Comp Sci MSc', 100),
('Kurtis', 'Hanson', 'London', 'Comp Sci BSc', 90),
('Bradley', 'Williams', 'York', 'Comp Sci BSc', 85),
('Aaron', 'Banjoko', 'London', 'Comp Sci BSc', 95),
('Malik', 'Shams', 'London', 'Comp Sci MSc', 75),
('Wahdel', 'Woodhouse', 'Manchester', 'Comp Sci', 80),
('Joel', 'Fright', 'York', 'Comp Sci BSc', 99);

SELECT * FROM spartans_table;