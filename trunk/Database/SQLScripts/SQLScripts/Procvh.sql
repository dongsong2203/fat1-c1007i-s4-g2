USE SHOPDVDS
--
GO
CREATE VIEW aShowCategories
AS
SELECT CateID,CateTypeID,CateName,CateStatus FROM Categories
--
GO
CREATE PROC aShowAlbum
@CateID INT
AS
IF @CateID = 0
BEGIN
	SELECT  AlbumID,
		CateID,
		AlbumName,
		AlbumPrice,
		AlbumDateCreate,
		AlbumImage,
		AlbumStatus,
		Quantity
		FROM Album ORDER BY AlbumID DESC
END
IF @CateID != 0
BEGIN
SELECT AlbumID,
		CateID,
		AlbumName,
		AlbumPrice,
		AlbumDateCreate,
		AlbumImage,
		AlbumStatus,
		Quantity
		FROM Album WHERE CateID = @CateID ORDER BY AlbumID DESC
END
exec aShowAlbum '1'
GO
-----
CREATE PROC aShowEditAlbum
@AlbumID INT
AS
SELECT AlbumID,
		Album.CateID,
		AlbumName,
		Categories.CateName,
		AlbumPrice,
		AlbumDateCreate,
		AlbumStatus,
		AlbumImage,
		Quantity,
		AlbumDetails
		FROM Album,Categories
		WHERE AlbumID = @AlbumID AND Album.CateID = Categories.CateID
---
GO
ALTER PROC aShowDataStore
@AlbumID INT
AS
SELECT	DataID,
		AlbumID,
		DataName,
		DataPath,
		DataDescription,
		DataPublic,
		DataStatus,
		DataImage
		FROM DataStore WHERE AlbumID = @AlbumID	 ORDER BY DataID DESC
--
GO
ALTER PROC aShowAllDataStore
@ID int
AS
SELECT	DataID,
		Album.AlbumName,
		SupID,
		DataName,
		DataPath,
		DataDescription,
		DataPublic,
		DataStatus,
		DataImage
		FROM DataStore,Album 
		WHERE DataStore.AlbumID = Album.AlbumID ORDER BY DataID DESC
GO
ALTER PROC aShowAllDataStoreFilter
@ID int
AS
IF @ID = 0
BEGIN
	SELECT	DataID,
		Album.AlbumName,
		SupID,
		DataName,
		DataPath,
		DataDescription,
		DataPublic,
		DataStatus,
		DataImage
		FROM DataStore,Album 
		WHERE DataStore.AlbumID = Album.AlbumID ORDER BY DataID DESC	
END
ELSE
BEGIN
 SELECT	DataID,
		Album.AlbumName,
		SupID,
		DataName,
		DataPath,
		DataDescription,
		DataPublic,
		DataStatus,
		DataImage
		FROM DataStore,Album 
		WHERE DataStore.AlbumID = Album.AlbumID 
		AND Album.AlbumID = @ID ORDER BY DataID DESC	
END
	
	
GO
CREATE PROC aInsertAlbum
	@CateID INT,
	@NameAlbum NVARCHAR(50),
	@AlbumPrice DECIMAL,
	@Quantity INT,
	@AlbumImage NVARCHAR(100),
	@DetailsAlbum NVARCHAR(MAX)
	AS
	INSERT INTO Album(CateID,AlbumName,AlbumPrice,AlbumDateCreate,AlbumStatus,AlbumImage,Quantity,AlbumDetails)
	VALUES(@CateID,@NameAlbum,@AlbumPrice,GETDATE(),'TRUE',@AlbumImage,@Quantity,@DetailsAlbum)
--
GO
CREATE PROC SetPublisAlbum
	@AlbumID INT
	AS
	IF (SELECT Album.AlbumStatus FROM Album WHERE Album.AlbumID = @AlbumID) = 'true'
	BEGIN
		UPDATE Album SET AlbumStatus = 'false' WHERE AlbumID = @AlbumID
	END
	ELSE IF(SELECT Album.AlbumStatus FROM Album WHERE Album.AlbumID = @AlbumID) = 'false'
	BEGIN
		UPDATE Album SET AlbumStatus = 'true' WHERE AlbumID = @AlbumID
	END
--
GO
CREATE PROC aAddDataStoreToList
@AlbumID INT,
@DataID INT
AS
UPDATE DataStore SET AlbumID = @AlbumID WHERE DataID = @DataID
--
GO
CREATE PROC aAddListAlbumToStore
@DataID INT
AS
UPDATE DataStore SET AlbumID = 1 WHERE DataID = @DataID
--
GO
CREATE PROC aUpdateAlbumInfo
@AlbumID INT,
@NameAlbum NVARCHAR(50),
@AlbumPrice DECIMAL,
@AlbumQuantity INT,
@DetailsAlbum NVARCHAR(MAX)
AS
UPDATE Album SET AlbumName = @NameAlbum,
				AlbumPrice = @AlbumPrice,
				Quantity = @AlbumQuantity,
				AlbumDetails = @DetailsAlbum
				WHERE AlbumID = @AlbumID
--
GO
CREATE PROC aShowAlbumCategories
@ID INT
AS
SELECT AlbumID,AlbumName FROM Album ORDER BY AlbumID DESC

EXEC aShowAlbumCategories '1'

GO
CREATE PROC aInserData
@CateAlbumID INT,
@DataName NVARCHAR(100),
@DataPath NVARCHAR(100),
@DataPublish BIT,
@DataImage NVARCHAR(200)
AS
INSERT INTO DataStore(AlbumID,DataName,DataPath,DataDescription,DataPublic,DataStatus,DataImage)
VALUES (@CateAlbumID,@DataName,@DataPath,'',@DataPublish,'true',@DataImage)

GO
CREATE PROC aUpdateUseGuest
@DataID INT
AS
IF(SELECT DataPublic FROM DataStore WHERE DataID = @DataID) = 'true'
BEGIN
	UPDATE DataStore SET DataPublic = 'false' WHERE DataID = @DataID
END
ELSE
BEGIN
	UPDATE DataStore SET DataPublic = 'true' WHERE DataID = @DataID
END

GO
ALTER PROC aGetdataEditData
@DataID INT
AS
SELECT DataID,
		Album.AlbumName,
		SupID,
		DataName,
		DataPath,
		DataDescription,
		DataPublic,
		DataStatus,
		DataImage
		FROM Album,DataStore
		WHERE DataID = @DataID AND DataStore.AlbumID = Album.AlbumID
		
GO
CREATE PROC aUpdateDataStore
@DataID INT,
@DataName NVARCHAR(100),
@DataImage NVARCHAR(200),
@DataPath NVARCHAR(100)
AS
UPDATE DataStore SET DataName = @DataName,
					DataImage = @DataImage,
					DataPath = @DataPath
					WHERE DataID = @DataID