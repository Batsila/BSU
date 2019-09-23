/*Init owners*/
INSERT INTO dbo.owners VALUES ('Joy', 'Smith', 'Grand Rapids 3414 Wetzel Lane');
INSERT INTO dbo.owners VALUES ('Ismail', 'Moore', 'Southfield 2466 Hayhurst Lane');
INSERT INTO dbo.owners VALUES ('Wendy', 'Wood', 'Cambridge 2362 Joanne Lane');
INSERT INTO dbo.owners VALUES ('Cavan', 'Mccaffrey', 'Los Angeles 4501 Evergreen Lane');
INSERT INTO dbo.owners VALUES ('Ema', 'Clegg', 'Lexington 2065 Zappia Drive');
INSERT INTO dbo.owners VALUES ('Riaz', 'Woodcock', 'Memphis 4595 Oxford Court');
INSERT INTO dbo.owners VALUES ('Cherish', 'Hahn', 'Yatesville 1590 Limer Street');
INSERT INTO dbo.owners VALUES ('Jeffrey', 'O.Reilly', 'Phoenix 2055 Dogwood Road');
INSERT INTO dbo.owners VALUES ('Paolo', 'Hood', 'Berea 3332 Ralph Drive');
INSERT INTO dbo.owners VALUES ('Jordon', 'Vickers', 'Bayside 2927 Alfred Drive');


/*Init jockeys*/
INSERT INTO dbo.jockeys VALUES ('Tiya', 'Forster', 43, 'Curlew 3123 Clousson Road', 170, 55);
INSERT INTO dbo.jockeys VALUES ('Eduard', 'Deleon', 25, 'Silver Lake 4490 Cessna Drive', 180, 70);
INSERT INTO dbo.jockeys VALUES ('Zaynah', 'Goulding', 16, 'Grand Rapids 204 Howard Street', 185, 75);
INSERT INTO dbo.jockeys VALUES ('Deanna', 'Cook', 19, 'Jacksonville 681 Railroad Street', 165, 50);
INSERT INTO dbo.jockeys VALUES ('Ayyub', 'Mills', 21, 'Harahan 4126 Rose Avenue', 160, 60);
INSERT INTO dbo.jockeys VALUES ('Nathanial', 'Curry', 33, 'Knoxville 3551 Corbin Branch Road', 190, 90);


/*Init horses*/
INSERT INTO dbo.horses VALUES ('Rocket', 4, 'mare', 1, 1, '2019-10-09');
INSERT INTO dbo.horses VALUES ('Friday', 3, 'stallion', 2, 2, '2020-09-09');
INSERT INTO dbo.horses VALUES ('Basia', 7, 'mare', 2, 3, '2019-10-09');
INSERT INTO dbo.horses VALUES ('Lucky', 9, 'stallion', 3, 1, '2019-10-19');
INSERT INTO dbo.horses VALUES ('Bob', 3, 'stallion', 4, 4, '2020-10-09');
INSERT INTO dbo.horses VALUES ('MadMax', 10, 'mare', 4, 4, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Ruchejok', 7, 'stallion', 5, 4, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Mary', 3, 'mare', 6, 5, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Stallion', 7, 'stallion', 7, 6, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Mare', 11, 'mare', 8, 1, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Jim', 13, 'stallion', 9, 2, '2020-10-09');
INSERT INTO dbo.horses VALUES ('Davie', 8, 'stallion', 10, 3, '2020-10-09');


/*Init competitions*/
INSERT INTO dbo.competitions VALUES ('2019-08-07', '13:30', 'Minsk', 'Minsk', 4);
INSERT INTO dbo.competitions VALUES ('2019-06-05', '8:30', 'Brest', 'Brest race', 4);
INSERT INTO dbo.competitions VALUES ('2019-07-13', '19:30', 'Bobruisk', 'Bobruisk super cup', 4);
INSERT INTO dbo.competitions VALUES ('2019-05-23', '12:15', 'Vilnus', 'Vilnus open cup', 4);


/*Init results*/
INSERT INTO dbo.results VALUES (1, 1, 1);
INSERT INTO dbo.results VALUES (2, 2, 1);
INSERT INTO dbo.results VALUES (3, 3, 1);
INSERT INTO dbo.results VALUES (4, 4, 1);
INSERT INTO dbo.results VALUES (5, 5, 1);

INSERT INTO dbo.results VALUES (1, 5, 2);
INSERT INTO dbo.results VALUES (3, 3, 2);
INSERT INTO dbo.results VALUES (4, 2, 2);
INSERT INTO dbo.results VALUES (5, 1, 2);

INSERT INTO dbo.results VALUES (1, 4, 3);
INSERT INTO dbo.results VALUES (2, 5, 3);
INSERT INTO dbo.results VALUES (3, 3, 3);
INSERT INTO dbo.results VALUES (4, 1, 3);
INSERT INTO dbo.results VALUES (5, 2, 3);

INSERT INTO dbo.results VALUES (1, 2, 4);
INSERT INTO dbo.results VALUES (2, 1, 4);
INSERT INTO dbo.results VALUES (3, 5, 4);
INSERT INTO dbo.results VALUES (4, 3, 4);
INSERT INTO dbo.results VALUES (5, 4, 4);