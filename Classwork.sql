create database Library
use library

create table Books
(
	Id int primary key identity,
	Name nvarchar(255) not null check(Len(name) between 2 and 100),
	PageCount int not null check(PageCount>10)
)
create table Authors
(
	Id int primary key identity,
	Name nvarchar(255) not null,
	SurName nvarchar(255)
)
alter table Books add AuthorId int foreign key references Authors(Id)

Create View  BookDetails  as
Select b.Id,b.Name,b.PageCount,(a.Name+' '+ISNULL(a.SurName,'')) as 'AuthorFullName' from Books b
join Authors a on b.AuthorId=a.Id

Create Procedure FindBookName @name nvarchar(255)
as
Begin
Select  distinct AuthorFullName from BookDetails where BookDetails.Name like '%'+@name+'%' or BookDetails.AuthorFullName like '%'+@name+'%'
end

Alter Procedure FindBookName @name nvarchar(255)
as
Begin
Select * from BookDetails where BookDetails.Name like '%'+@name+'%' or BookDetails.AuthorFullName like '%'+@name+'%'
end

exec FindBookName 'Ni'

Create Procedure InsertAuthors @name nvarchar(255),@surname nvarchar(255)
as
begin
Insert Into Authors Values (@name,@surname)
end



exec InsertAuthors 'Vusal', 'Imanov'

Create Procedure UpdateAuthors  @name nvarchar(255),@surname nvarchar(255)
as 
begin 
	Update Authors 
	Set Name=@name,SurName=@surname
end

Create Procedure DeleteAuthors @id int 
as
begin 
Delete from Authors where Id=@id 
end

Create View GetAuthorDetail as
Select a.Id,(a.Name+''+ ISNULL(a.SurName,'')) as FullName,COUNT(*) as BooksCount ,Max(b.PageCount) as MaxPageCount from Authors a
Join Books b on  b.AuthorId=a.Id
group by a.Id,a.Name,a.SurName

