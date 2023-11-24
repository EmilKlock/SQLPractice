USE [master]
GO
/****** Object:  StoredProcedure [dbo].[customerManagement]    Script Date: 24/11/2023 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Emil Klock
-- Create date: 2023.11.21
-- Description:	table management
-- =============================================
ALTER PROCEDURE [dbo].[customerManagement] 
	-- Add the parameters for the stored procedure here
	@Action varchar(15),
	@p1 varchar(255) = null, -- Labeled per @Action
	@p2 varchar(255) = null, -- Labeled per @Action
	@p3 varchar(255) = null, -- Labeled per @Action
	@p4 varchar(255) = null, -- Labeled per @Action
	@p5 varchar(255) = null	 -- Labeled per @Action
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF @Action = 'InsertUsr' -- 'InsertUsr' Name Phonenumber Time Country
	BEGIN
		DECLARE @iusrID int = dbo.customerGetID(@p1, @p2, @p4)
		IF @iusrID IS Null
		BEGIN
			PRINT 'Got here'
			INSERT INTO CustomerTable
			VALUES (@p1, CAST(@p2 as int), CAST(@p3 as datetime), @p4)
		END
		ELSE
		BEGIN
			PRINT 'User for ' + @p1 + ' already exist with CustomerID: ' + CAST(@iusrID as varchar(255))
		END
	END
	ELSE IF @Action = 'DeleteUsr' -- 'DeleteUsr' CustomerID
	BEGIN
		DECLARE @delUsrIDName varchar(255) = dbo.customerGetName(@p1)
		IF @delUsrIDName IS NOT NULL
		BEGIN
			DELETE FROM CustomerTable WHERE CustomerID = CAST(@p1 as int)
		END
		ELSE
		BEGIN
			PRINT 'UserID: ' + @p1 + ' does not exist'
		END
	END
	ELSE IF @Action = 'UpdateUsr' -- 'UpdateUsr' CustomerID Name* Phonenumber* Time* Country* | *Optional null or updated value
	BEGIN
		DECLARE @upUsrID varchar(255) = dbo.customerGetName(@p1)
		IF @upUsrID IS NOT NULL
		BEGIN
			UPDATE CustomerTable
			SET Name = ISNULL(@p2, Name),
				Phonenumber = ISNULL(@p3, Phonenumber),
				Time = ISNULL(CAST(@p4 as datetime), Time),
				Country = ISNULL(@p5, Country)
			WHERE CustomerID = CAST(@p1 as int)
		END
		ELSE
		BEGIN
			PRINT 'UserID: ' + @p1 + ' does not exist'
		END

	END
	ELSE IF @Action = 'GetUsr' -- 'GetUsr' CustomerID
	BEGIN
		--SELECT *
		--FROM CustomerTable
		--ORDER BY Name ASC
		--OFFSET @p1 ROWS
		--FETCH NEXT 1 ROW ONLY
		SELECT CustomerID
		FROM CustomerTable
		WHERE Name = @p1
	END
	ELSE IF @Action = 'Phone' -- 'Phone' Phonenumber
	BEGIN
		SELECT *
		FROM CustomerTable
		WHERE Phonenumber = CAST(@p1 as int)
	END
	ELSE IF @Action = 'InsertAdr' --'InsertAdr' City PostalCode Street StreetNumberChar
	BEGIN
		DECLARE @iadrID int = dbo.adressGetID(@p1, @p2, @p3, @p4)
		IF @iadrID IS NULL
		BEGIN
			INSERT INTO AdressTable
			VALUES (@p1, @p2, @p3, @p4)
		END
		ELSE
		BEGIN
			PRINT 'Adress already exsist: ' + @p1 + ', ' + @p2 + ', ' + @p3 + ' ' + @p4 + CHAR(13) + 'with AdressID: ' + CAST(@iadrID as varchar(255))
		END
	END
	ELSE IF @Action = 'DeleteAdr' -- 'DeleteAdr' AdressID
	BEGIN
		DECLARE @dadrName varchar(255) = dbo.adressGetAdr(@p1)
		IF @dadrName IS NOT NULL
		BEGIN
			DELETE FROM AdressTable WHERE AdressID = CAST(@p1 as int)
		END
		ELSE
		BEGIN
			PRINT 'AdressID: ' + @p1 + ' does not exist.'
		END

	END
	ELSE IF @Action = 'UpdateAdr' -- 'UpdateAdr' AdressID City* PostalCode* Street* StreetNumberChar* | *Optional null or updated value
	BEGIN
		DECLARE @uadrName varchar(255) = dbo.adressGetAdr(@p1)
		IF @uadrName IS NOT NULL
		BEGIN
			UPDATE AdressTable
			SET	City = ISNULL(@p2, City),
				PostalCode = ISNULL(CAST(@p3 as int), PostalCode),
				Street = ISNULL(@p4, Street),
				StreetNumberChar = ISNULL(@p5, StreetNumberChar)
			WHERE AdressID = CAST(@p1 as int)
		END
		ELSE
		BEGIN
			PRINT 'AdressID: ' + @p1 + ' does not exist.'
		END

	END
	ELSE IF @Action = 'GetAdr' -- 'GetAdr' AdressID
	BEGIN
		--SELECT *
		--FROM AdressTable
		--ORDER BY City ASC
		--OFFSET @p1 ROWS
		--FETCH NEXT 1 ROW ONLY
		SELECT AdressID
		FROM AdressTable 
		WHERE City = @p1
	END
	ELSE IF @Action = 'LinkUsrAdr' -- 'LinkUsrAdr' CustomerID AdressID
	BEGIN
		IF dbo.customerGetName(@p1) IS NULL
		BEGIN
			PRINT 'CustomerID: ' + @p1 + ' does not exist.'
		END
		ELSE IF dbo.adressGetAdr(@p2) IS NULL
		BEGIN
			PRINT 'AdressID: ' + @p2 + ' does not exist.'
		END
		ELSE
		BEGIN
			INSERT INTO CustomerAdressRelation
			VALUES (@p1, @p2)
		END
	END
	ELSE IF @Action = 'UnLinkUsrAdr' -- 'UnLinkUsrAdr' RelationID
	BEGIN
		IF dbo.relationGetID(@p1) IS NOT NULL
		BEGIN
			DELETE FROM CustomerAdressRelation
			WHERE RelationID = @p1
		END
		ELSE
		BEGIN
			PRINT 'RelationID: ' + @p1 + ' does not exist.'
		END
	END
END

