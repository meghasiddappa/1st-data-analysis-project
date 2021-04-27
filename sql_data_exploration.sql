--git commit
select * from Track t 
where (MediaTypeId = 1 & GenreId = 1);


--Number of employees who are artist  
select * from Employee e, Artist a 
where e.EmployeeId = a.ArtistId;

-- maximum amount of tracks sold
select SUM(Quantity), TrackId 
from InvoiceLine il 
group by TrackId 
order by 1 DESC ;


 -- top selling albums
SELECT a.AlbumId, a.Title, il.InvoiceLineId, SUM(il.Quantity) 
from Track t
inner join InvoiceLine il on il.TrackId = t.TrackId
inner join Album a on a.AlbumId = t.AlbumId
group by t.TrackId 
order by SUM(il.Quantity) desc;

--top selling track
select il.TrackId, SUM(il.Quantity) 
from InvoiceLine il
group by il.TrackId 
order by SUM(il.Quantity) desc; 


select t.Name, t.AlbumId, t.GenreId, t.TrackId, g.Name, a.ArtistId, a2.Name 
from Track t, Genre g, Album a, Artist a2 ;

-- top selling genre
SELECT SUM(il.Quantity), g.Name 
from Track t
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.Name 
order by SUM(il.Quantity)  DESC ;

-- each genre top selling artist
SELECT SUM(il.Quantity), g.Name,a2.Name 
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.Name 
order by SUM(il.Quantity)  DESC ;




-- top cost album name and its genre with total nuber of sold.

SELECT SUM(il.Quantity), g.Name gene_name,il.UnitPrice*SUM(il.Quantity), a2.name artist_name,t.Name track_name 
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by t.AlbumId 
order by il.UnitPrice*SUM(il.Quantity)  DESC ;


-- genre and there price in each genre with perticular artist 
SELECT  g.Name genere_name, a2.name artist_name,SUM(il.Quantity), il.UnitPrice*SUM(il.Quantity)
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.name, t.AlbumId 
order by 1, il.UnitPrice*SUM(il.Quantity)  DESC ;


-- ranking the genre   [using rank function]
SELECT  g.Name genere_name, a2.name artist_name,SUM(il.Quantity), il.UnitPrice*SUM(il.Quantity),
rank()
over(PARTITION by g.Name
order by il.UnitPrice*SUM(il.Quantity) DESC) val 
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.name, t.AlbumId 
order by 1, il.UnitPrice*SUM(il.Quantity)  DESC ;

--display only top 3 ranks 
SELECT * from(
SELECT  g.Name genere_name, a2.name artist_name,SUM(il.Quantity), il.UnitPrice*SUM(il.Quantity),
DENSE_RANK()
over(PARTITION by g.Name
order by il.UnitPrice*SUM(il.Quantity) DESC) val
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.name, t.AlbumId 
order by 1, il.UnitPrice*SUM(il.Quantity)  DESC )RN
where RN.val <= 3;


--with clause for top 2 artist in each genre 
with dataset as (SELECT  g.Name genere_name, a2.name artist_name,SUM(il.Quantity), il.UnitPrice*SUM(il.Quantity),
DENSE_RANK()
over(PARTITION by g.Name
order by il.UnitPrice*SUM(il.Quantity) DESC) val
from Track t 
inner join Artist a2 on a2.ArtistId = a3.ArtistId 
inner join Album a3 on a3.AlbumId = t.AlbumId 
inner join Genre g on t.GenreId = g.GenreId 
inner join InvoiceLine il  on t.TrackId  = il.TrackId
group by g.name, t.AlbumId 
order by 1, il.UnitPrice*SUM(il.Quantity)  DESC)
select * from dataset
where val <= 2 ;
 

--count of tracks and details of each artist
SELECT a2.Name, count(t.Name), g.Name, mt.Name 
FROM Track t
inner join Artist a2 on a2.ArtistId = a.ArtistId 
inner join Album a on a.AlbumId = t.AlbumId 
inner join Genre g on g.GenreId = t.GenreId 
inner join MediaType mt on mt.MediaTypeId = t.MediaTypeId 
group by a2.name
order by COUNT(t.name) desc;


--different genre names with there playlist
select g.Name genre_name, p.Name  play_name
from Track t
left join Genre g on t.GenreId = g.GenreId 
LEFT join PlaylistTrack pt on pt.TrackId = t.TrackId 
left join Playlist p on p.PlaylistId = pt.playlistid 
group by p.Name;


--employees who sold most number of tracks
select e.FirstName emp_name, t.Name track_name, sum(il.Quantity) 
from Customer c 
inner join Employee e on e.EmployeeId = c.SupportRepId 
INNER join Invoice i on i.CustomerId  = c.CustomerId 
inner join InvoiceLine il on il.InvoiceId = i.InvoiceId 
inner join Track t on t.TrackId = il.InvoiceLineId 
group by e.FirstName
order by sum(il.Quantity) ;










