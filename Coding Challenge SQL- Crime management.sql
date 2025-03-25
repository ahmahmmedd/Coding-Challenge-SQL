create database crime;
use crime;

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
);

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'),
(4, 'Assault', '2023-09-05', '321 Pine St, Cityville', 'Bar fight resulting in injuries', 'Open'),
(5, 'Robbery', '2023-09-02', '654 Maple St, Townsville', 'Bank robbery', 'Under Investigation'),
(6, 'Homicide', '2023-09-07', '987 Cedar St, Villagetown', 'Gang-related shooting', 'Open'),
(7, 'Burglary', '2023-09-08', '159 Rasengan Ave, Cityville', 'Blue Lily flower Theft', 'Closed'),
(8, 'Robbery', '2023-09-18', '753 Spruce St, Townsville', 'Jewelry store heist', 'Open'),
(9, 'Assault', '2023-09-22', '456 Heuco St, Villagetown', 'Park altercation', 'Under Investigation'),
(10, 'Assault', '2023-09-30', '123 Mondo St, Cityville', 'Metro Station altercation', 'Open');

CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
Age smallint,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries, Age) VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries', 45),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased', 32),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None', 28),
(4, 4, 'Robert Brown', 'robertb@example.com', 'Broken nose', 35),
(5, 5, 'Sarah Miller', 'sarahm@example.com', 'None', 30),
(6, 6, 'Michael Davis', 'michaeld@example.com', 'Gunshot wounds', 40),
(7, 7, 'Muzan Tanjiro', 'emilyw@example.com', 'None', 25),
(8, 8, 'John Doe', 'johndoe2@example.com', 'Trauma', 50),
(9, 9, 'Jessica Taylor', 'jessicat@example.com', 'Bruises', 22),
(10, 10, 'David Alaba', 'davida@example.com', 'None', 30),
(11, 1, 'Jennifer Lee', 'jenniferl@example.com', 'Minor injuries', 35),
(12, 4, 'Daniel Harris', 'danielh@example.com', 'Broken arm', 42);

CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
Description TEXT,
CriminalHistory TEXT,
Age smallint,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory, Age) VALUES
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions', 30),
(2, 2, 'Unknown', 'Investigation ongoing', NULL, NULL),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests', 22),
(4, 4, 'Devin Pratt', 'Known boxer', 'Prior assault charges', 35),
(5, 5, 'John Dillinger', 'Bank robber', 'Multiple robbery convictions', 40),
(6, 4, 'Billy Smith', 'Bar patron', 'No prior record', 25),
(7, 6, 'Gang Member A', 'Known gang affiliate', 'Violent crime history', 28),
(8, 7, 'Burglar X', 'Professional thief', 'Multiple burglary charges', 45),
(9, 8, 'Robber 2', 'Jewelry thief', 'International thefts', 38),
(10, 9, 'Street Fighter', 'Local troublemaker', 'Multiple assault charges', 29),
(11, 10, 'Student', 'High school student', 'No prior record', 16),
(12, 1, 'Robber 3', 'Getaway driver', 'Previous robbery involvement', 32),
(13, 5, 'Jane Smith', 'Bank employee with access', 'Embezzlement history', 35),
(14, 6, 'Gang Member B', 'Second suspect', 'Weapons charges', 30);

/* 1. Select all open incidents. */
select * 
from crime 
where status = 'Open';

/* 2. Find the total number of incidents.*/
select count(crimeid) as NoOfIncidents 
from crime;

/* 3. List all unique incident types. */
select distinct(incidenttype) 
from crime;

/* 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'. */
select * from crime 
where incidentdate 
between '2023-09-01' and '2023-09-10';

/* 5. List persons involved in incidents in descending order of age. */


select name, Age 
from victim 
union all
select name, Age
from suspect 
where age is not null
order by age desc;

/*6. Find the average age of persons involved in incidents. */
select avg(Age) as AvgAge from
(select age 
from victim
union all
select age 
from suspect 
where age is not null)
as Ages;

/* 7. List incident types and their counts, only for open cases.*/
select incidenttype, count(incidenttype) as NoOfIncidents
from crime
where status= 'open'
group by incidenttype;

/* 8. Find persons with names containing 'Doe'. */
select name 
from victim 
where name like '%doe%'
union all
select name 
from suspect 
where name like '%doe%';

/* 9. Retrieve the names of persons involved in open cases and closed cases.*/
select v.name, c.status
from victim v
join crime c on v.crimeid=c.crimeid
where c.status in('open','closed')
union all
select s.name, c.status
from suspect s
join crime c on s.crimeid=c.crimeid
where c.status in('open','closed');

/*10. List incident types where there are persons aged 30 or 35 involved.  */
select c.incidenttype, v.age
from crime c
join victim v on c.crimeid=v.crimeid
where age in (30,35)

union

select c.incidenttype, s.age
from crime c
join suspect s on c.crimeid=s.crimeid
where age in (30,35);

/* 11. Find persons involved in incidents of the same type as 'Robbery'.*/
select v.name, 'Victim' as Role
from victim v
join crime c on v.crimeid=c.crimeid
where c.incidenttype= 'Robbery'

union

select s.name, 'Suspect' as Role
from suspect s
join crime c on s.crimeid=c.crimeid
where c.incidenttype= 'Robbery';

/*12. List incident types with more than one open case. */

select incidenttype, count(*) as OpenCase
from crime 
where status='open'
group by incidenttype
having opencase>1;

/*13. List all incidents with suspects whose names also appear as victims in other incidents.*/
select c.*
from crime c
join suspect s on c.crimeid=s.crimeid
where s.name in 
(select name from victim);

/* 14. Retrieve all incidents along with victim and suspect details.*/
select c.*,v.*,s.*
from crime c
left join victim v on c.crimeid=v.crimeid
left join suspect s on c.crimeid=s.crimeid;

/* 15. Find incidents where the suspect is older than any victim.*/
select c.* from crime c 
join suspect s on c.crimeid=s.crimeid
join victim v on c.crimeid=v.crimeid
where s.age>v.age;

/* 16. Find suspects involved in multiple incidents: */

insert into suspect values(15, 5, 'Robber 2', 'Gold thief', 'International thefts', 38);

select name, count(*) as Incidents
from suspect
group by name
having incidents>1;

/*17. List incidents with no suspects involved. */
select c.* 
from crime c
join suspect s on c.crimeid=s.crimeid
where s.name='Unknown';

/* 18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'.*/

select * from crime 
where incidenttype in ('homicide', 'robbery')
and exists (
select 1 from crime where incidenttype = 'homicide')
and not exists (
select 1 from crime where incidenttype not in ('homicide', 'robbery'));

/*19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.*/
select c.crimeid,
coalesce(s.name, 'No Suspect') as SuspectName, c.incidenttype
from crime c
join suspect s on c.crimeid = s.crimeid;

/*20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'*/
select s.name
from suspect s
join crime c on s.crimeid=c.crimeid
where c.incidenttype in('Robbery','Assault');