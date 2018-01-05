--Q1
SELECT Gender, COUNT(*)
FROM User
GROUP BY Gender;

--Q2
SELECT U.Name, U.LastName, G.Description
FROM User U, GroupInfo G, Friendship F
WHERE G.Owner=U.UserId AND F.Follower=U.UserId AND F.Followee IN --could have specified F.Followee=2
		(SELECT F2.Followee
		FROM Friendship F2, User U2
		WHERE U2.UserId=2 AND F2.Followee=U2.UserID);

/* Checking if soln. is correct*/
SELECT U.Name, U.LastName, G.Description, U.Userid, F.Followee
FROM User U, GroupInfo G, Friendship F
WHERE G.Owner=U.Userid AND F.Follower=U.Userid;
		
--Q3
SELECT U.UserId, U.Name, U.LastName, G.Description
FROM User U, GroupInfo G
Where U.UserId=G.Owner;

--Q4
SELECT U.Userid 
FROM (Friendship F LEFT OUTER JOIN User U ON U.UserID=F.Followee)
GROUP BY F.Followee
HAVING COUNT(*)>2;

--Check
select *
From User, Friendship
WHere User.Userid=Friendship.Followee
Order by Followee

--Q5
SELECT U.LastName
FROM User U, ObjectType OT, Object O
WHERE OT.Type='Image' AND OT.ObjectTypeID=O.ObjectType AND O.ObjOwner=U.UserId
INTERSECT
SELECT U.LastName
FROM User U, ObjectType OT, Object O
WHERE OT.Type='Video' AND OT.ObjectTypeID=O.ObjectType AND O.ObjOwner=U.UserId;

--Testing another option for Q5
SELECT Q3.LastName 
	FROM 
	(SELECT Q1.LastName, Q1.'Image.Count', Q2.'Video.Count', Q1.'Image.Count' + Q2.'Video.Count' AS 'Tot_Count'
	FROM 
			(SELECT U.LastName, COUNT(*) AS 'Image.Count'
			FROM User U, ObjectType OT, Object O
			WHERE OT.Type='Image' AND OT.ObjectTypeID=O.ObjectType AND O.ObjOwner=U.UserId
			GROUP BY U.LastName) as Q1,
			(SELECT U2.LastName, COUNT(*) AS 'Video.Count'
			FROM User U2, ObjectType OT2, Object O2
			WHERE OT2.Type='Video' AND OT2.ObjectTypeID=O2.ObjectType AND O2.ObjOwner=U2.UserId
			GROUP BY U2.LastName) AS Q2
			WHERE Q1.LastName = Q2.LastName
		GROUP BY Q1.LastName
		HAVING Q1.'Image.Count' >0 AND Q2.'Video.Count'>0) AS Q3


--check
select *
from User U, ObjectType OT, Object O
WHERE  U.Userid=O.ObjOwner AND O.ObjectType=OT.ObjectTypeID
order by U.LastName

--Q6
SELECT U.LastName, COUNT(*) 'No.Likes'
FROM User U, ActivityType AT, Activity A
WHERE U.UserId=A.UserId AND A.ActType=AT.ActID AND AT.ActDescription='Like'
GROUP BY  U.LastName
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC;

--Check
SELECT *
FROM User U, ActivityType AT, Activity A
WHERE AT.ActId=A.ActType AND A.UserId=U.UserId

--Q7
SELECT COUNT(*) 
FROM (SELECT DISTINCT O.ObjectType
			FROM Object O, User U
			WHERE O.ObjOwner=U.UserId AND U.UserId=4);

--Check
SELECT *
FROM Object O, User U, ObjectType OT
WHERE O.ObjOwner=U.UserId AND U.UserId=4 