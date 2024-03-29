USE DingoMessages
GO
/****** Object:  Table EncryptionStates    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE EncryptionStates(
	Id nvarchar(450) NOT NULL,
	EncryptionClientState LONGTEXT NULL,
	X509IdentityKey nvarchar(1000) NULL,
	PrivateIdentityKey nvarchar(1000) NULL,
	Bundles LONGTEXT NULL
) ON PRIMARY TEXTIMAGE_ON PRIMARY
GO
/****** Object:  Table Messages    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE Messages(
	Id nvarchar(450) NOT NULL,
	Messages LONGTEXT NOT NULL
) ON PRIMARY TEXTIMAGE_ON PRIMARY
GO
ALTER TABLE Messages ADD  DEFAULT ('') FOR Messages
GO
/****** Object:  StoredProcedure CreateUser    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE CreateUser
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;
	INSERT INTO Messages
	(Id,Messages)
	VAlUES
	(@Id,'')
RETURN 0
GO
/****** Object:  StoredProcedure DeleteUser    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeleteUser
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	DELETE from Messages where Id=@Id; 
	DELETE from EncryptionStates where Id= @Id;
RETURN 0
GO
/****** Object:  StoredProcedure GetBundles    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetBundles
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT Bundles from EncryptionStates WHERE Id = @Id

RETURN 0
GO
/****** Object:  StoredProcedure GetEncryptionState    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE GetEncryptionState
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT EncryptionClientState from EncryptionStates WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure GetIdentityKeys    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetIdentityKeys
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT X509IdentityKey, PrivateIdentityKey 
	from EncryptionStates 
	WHERE Id = @Id;
RETURN 0
GO
/****** Object:  StoredProcedure GetMessages    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetMessages
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT Messages from Messages where Id=@Id;
RETURN 0
GO
/****** Object:  StoredProcedure SetBundles    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetBundles
	@Id nvarchar(450),
	@Bundles nvarchar(1000)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT Bundles from EncryptionStates WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET Bundles = @Bundles
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO EncryptionStates (Id ,Bundles)
			VALUES (@Id, @Bundles)
		END

RETURN 0
GO
/****** Object:  StoredProcedure SetEncryptionState    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SetEncryptionState
	@Id nvarchar(450),
	@EncryptionClientState LONGTEXT

AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT EncryptionClientState from EncryptionStates WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET EncryptionClientState = @EncryptionClientState
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO EncryptionStates (Id, EncryptionClientState)
			VALUES (@Id, @EncryptionClientState)
		END

RETURN 0
GO
/****** Object:  StoredProcedure SetIdentityKeys    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetIdentityKeys
	@Id nvarchar(450),
	@X509IdentityKey nvarchar(1000),
	@PrivateIdentityKey nvarchar(1000)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT X509IdentityKey, PrivateIdentityKey from EncryptionStates WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET X509IdentityKey = @X509IdentityKey, PrivateIdentityKey = @PrivateIdentityKey
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO EncryptionStates (Id, X509IdentityKey,PrivateIdentityKey)
			VALUES (@Id, @X509IdentityKey,@PrivateIdentityKey)
		END

RETURN 0
GO
/****** Object:  StoredProcedure SetMessages    Script Date: 4/3/2021 1:59:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetMessages
	@Id nvarchar(450),
	@Messages LONGTEXT
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT Messages from Messages WHERE Id = @Id)
		BEGIN
			UPDATE Messages
			SET Messages = @Messages 
			where Id =@id;
		END
	ELSE
		BEGIN
			INSERT INTO Messages (Id ,Messages)
			VALUES (@Id, @Messages)
		END

RETURN 0
GO
