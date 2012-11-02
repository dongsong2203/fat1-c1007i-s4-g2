Use SHOPDVDS
GO
Create View showAllCategory
as
Select * from Categories

GO
CREATE PROCEDURE pagingShowAllAlbum
@PageIndex INT, 
@PageSize INT 
AS 
BEGIN
	WITH AlbumRecords AS ( 
		SELECT ROW_NUMBER() OVER (ORDER BY AlbumDateCreate) AS RowIndex, 
			AlbumID, AlbumName, AlbumImage, AlbumPrice 
		FROM Album WHERE AlbumStatus = 'TRUE' AND AlbumID != 1
	) , GetTotalRowCount AS ( 
		SELECT MAX(RowIndex) AS TotalRowCount 
		FROM AlbumRecords 
	) 
	SELECT AlbumID, AlbumName, AlbumPrice, AlbumImage, TotalRowCount 
	FROM AlbumRecords, GetTotalRowCount 
	WHERE (RowIndex BETWEEN (@PageIndex - 1) * @PageSize + 1 AND @PageIndex*@PageSize) 
END

GO 
CREATE PROCEDURE pagingShowAllAlbumById
@PageIndex INT, 
@PageSize INT,
@pId INT
AS 
BEGIN
	WITH AlbumRecords AS ( 
		SELECT ROW_NUMBER() OVER (ORDER BY AlbumDateCreate) AS RowIndex, 
			AlbumID, AlbumName, AlbumImage, AlbumPrice 
		FROM Album WHERE AlbumStatus = 'TRUE' AND CateID = @pId AND AlbumID != 1
	) , GetTotalRowCount AS ( 
		SELECT MAX(RowIndex) AS TotalRowCount 
		FROM AlbumRecords 
	) 
	SELECT AlbumID, AlbumName, AlbumPrice, AlbumImage, TotalRowCount 
	FROM AlbumRecords, GetTotalRowCount 
	WHERE (RowIndex BETWEEN (@PageIndex - 1) * @PageSize + 1 AND @PageIndex*@PageSize) 
END

GO
CREATE PROCEDURE showInforAlbum
@AlbumID	INT
AS
SELECT Album.AlbumID, Album.CateID, Album.AlbumName, Album.AlbumPrice, Album.AlbumDateCreate, Album.AlbumStatus, Album.AlbumImage, Album.Quantity, Categories.CateName, Album.AlbumDetails
FROM Album left join Categories on Album.CateID = Categories.CateID WHERE AlbumID = @AlbumID


GO
CREATE PROCEDURE listDataSotre
@AlbummID	INT
AS
SELECT * FROM DataStore WHERE AlbumID = @AlbummID


GO
CREATE PROCEDURE getSupplierID
@ALbumID	INT
AS
SELECT SupID FROM Album WHERE AlbumID = @ALbumID


GO
CREATE PROCEDURE showNameSupplier
@SupplierId	INT
AS
SELECT SupName FROM Supplier WHERE SupID = @SupplierId

GO
CREATE PROCEDURE getAlbumById
@AlbumId	INT
AS
SELECT * FROM Album WHERE AlbumID = @AlbumId

GO
--change UserAccount = UserId
CREATE PROCEDURE loadUserInforFromData
@UserId		NVARCHAR(20)
AS
SELECT * FROM Users WHERE UserID = @UserId

GO
--change UserAccount = UserId
CREATE PROCEDURE saveUserInforIntoData
@UserId		NVARCHAR(20),
@UserName	NVARCHAR(30),
@Phone		NVARCHAR(20),
@Address	NVARCHAR(200)
AS
UPDATE Users SET UserName = @UserName, UserFone = @Phone, Address = @Address WHERE UserID = @UserId

GO

CREATE PROCEDURE Ordering
@UserId		NVARCHAR(20),
@OrderDate	NVARCHAR(30),
@ShipName	NVARCHAR(30),
@ShipAddress NVARCHAR(100)
AS
INSERT INTO Orders(UserID,OrderDate,ShipName,ShipAddress,ShipStatus) 
VALUES(@UserId, GETDATE(), @ShipName, @ShipAddress,0)

GO
CREATE PROCEDURE OrderingDetail
@OrderId	INT,
@ALbumID	INT,
@Price		DECIMAL,
@Quantity	INT
AS
INSERT INTO OrderDetails VALUES( @OrderId, @ALbumID, @Price, @Quantity, 0)

GO
CREATE VIEW returnLastOrderId
AS
SELECT TOP 1 OrderId FROM Orders ORDER BY OrderId DESC

GO

CREATE PROCEDURE listOrderByUserId
@UserId		INT
AS
SELECT * FROM Orders WHERE UserId = @UserId ORDER BY DESC

GO
--change
CREATE PROCEDURE listOrderDetailByOrderId
@OrderId	INT
AS
SELECT OD.UnitPrice, OD.Quantity FROM OrderDetails AS OD WHERE OD.OrderID = @OrderId

GO
CREATE PROCEDURE showOrderDetailsById
@OrderId	INT
AS
SELECT OD.Album, OD.UnitPrice, OD.Quantity, OD.Discount, A.AlbumName FROM OrderDetails AS OD
INNER JOIN Album AS A ON OD.Album = A.AlbumID WHERE OD.OrderID = @OrderId

GO
CREATE PROCEDURE changeStatusOrder
@OrderId	INT
AS
UPDATE Orders SET ShipStatus = 3 WHERE OrderID = @OrderId AND ShipStatus = 0

GO
CREATE PROCEDURE showCollectionCateById
@UserId		INT
AS
SELECT * FROM CollectionCate WHERE UserID = @UserId

GO
CREATE PROCEDURE addDataStoteIntoMyList
@CollectionId	INT,
@DataId			INT
AS
INSERT INTO CollectionUser  VALUES(@CollectionId, @DataId, NULL)

GO
CREATE PROCEDURE checkExistDataStore
@CollectionId	INT,
@DataId			INT
AS
SELECT * FROM CollectionUser WHERE CollectionCate = @CollectionId AND DataID = @DataId

GO
CREATE PROCEDURE insertNewPlaylist
@CateName		NVARCHAR(50),
@UserId			INT
AS
INSERT INTO CollectionCate VALUES(@CateName, @UserId, GETDATE())

GO
CREATE PROCEDURE listCollectionCateNew
@UserId			INT
AS
SELECT TOP 1 * FROM CollectionCate WHERE UserID = @UserId ORDER BY DateCreate DESC

/*Co the la moi chua chac *_^ */
GO
CREATE PROCEDURE showInforFromData
@UserId			INT
AS
SELECT * FROM Users WHERE UserID = @UserId

GO
CREATE PROCEDURE deleteCollectionCateById
@CollectionId	INT
AS
DELETE FROM CollectionUser WHERE CollectionCate = @CollectionId
DELETE FROM CollectionCate WHERE CollecCateID = @CollectionId

GO
CREATE PROCEDURE showDataStoreById
@DataStoreId	INT
AS
SELECT * FROM DataStore WHERE DataID = @DataStoreId

GO
CREATE PROCEDURE listCollectionUserByPlaylistId
@CollectionUserId	INT,
AS
SELECT * FROM CollectionUser WHERE CollectionCate = @CollectionUserId

GO
CREATE PROCEDURE listCollectionCateById
@CollectionCateId	INT,
@UserId				INT
AS
SELECT * FROM CollectionCate WHERE CollecCateID = @CollectionCateId AND UserID = @UserId

GO
CREATE PROCEDURE checkLogin
@UserName			NVARCHAR(20),
@Pass				NVARCHAR(70)
AS
SELECT * FROM Users WHERE UserAccount = @UserName AND UserPassword = @Pass

GO
CREATE PROCEDURE deleteDataStoreInPlaylist
@PlaylistId			INT,
@DataStoreId		INT
AS
DELETE FROM CollectionUser WHERE CollectionCate = @PlaylistId AND DataID = @DataStoreId

EXECUTE checkLogin 'vanthuc', 'u+ebIiMqslo='