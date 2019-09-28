--Info about jockey by horse name
select dbo.jockeys.* from dbo.horses 
	inner join dbo.jockeys on horses.jockey_id = dbo.jockeys.id
		where horses.name = 'Vivien';

--Info about owners how have more than 3 horses
select * from dbo.owners 
	where id in
		(select dbo.horses.owner_id from dbo.horses 
		group by owner_id
		having count(*) > 3);

--Info about winners
select dbo.horses.* from dbo.horses 
	inner join dbo.results on results.horse_id = horses.id
	inner join dbo.competitions on competitions.id = results.competition_id
		where place = 1 and date > '2019-01-01' and date < GETDATE()