CREATE DATABASE DingoMessages;
GO
USE [DingoMessages]
GO
/****** Object:  Table [dbo].[EncryptionStates]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EncryptionStates](
	[Id] [nvarchar](450) NOT NULL,
	[EncryptionClientState] [nvarchar](max) NULL,
	[X509IdentityKey] [nvarchar](1000) NULL,
	[PrivateIdentityKey] [nvarchar](1000) NULL,
	[Bundles] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Messages]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messages](
	[Id] [nvarchar](450) NOT NULL,
	[Messages] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Messages] ADD  DEFAULT ('[]') FOR [Messages]
GO
/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateUser]
	@Id nvarchar(450)
AS
	INSERT INTO [dbo].[Messages]
	(Id,Messages)
	VAlUES
	(@Id,'[]')
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUser]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	DELETE from [dbo].[Messages] where Id=@Id; 
	DELETE from [dbo].[EncryptionStates] where Id= @Id;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetBundles]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBundles]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT Bundles from [dbo].[EncryptionStates] WHERE Id = @Id

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetEncryptionState]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetEncryptionState]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT EncryptionClientState from [dbo].[EncryptionStates] WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetIdentityKeys]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIdentityKeys]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT X509IdentityKey, PrivateIdentityKey 
	from [dbo].[EncryptionStates] 
	WHERE Id = @Id;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetMessages]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMessages]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT Messages from [dbo].[Messages] where Id=@Id;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetBundles]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetBundles]
	@Id nvarchar(450),
	@Bundles nvarchar(1000)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT Bundles from [dbo].[EncryptionStates] WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET Bundles = @Bundles
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[EncryptionStates] (Id ,Bundles)
			VALUES (@Id, @Bundles)
		END

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetEncryptionState]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SetEncryptionState]
	@Id nvarchar(450),
	@EncryptionClientState nvarchar(MAX)

AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT EncryptionClientState from [dbo].[EncryptionStates] WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET EncryptionClientState = @EncryptionClientState
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[EncryptionStates] (Id, EncryptionClientState)
			VALUES (@Id, @EncryptionClientState)
		END

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetIdentityKeys]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetIdentityKeys]
	@Id nvarchar(450),
	@X509IdentityKey nvarchar(1000),
	@PrivateIdentityKey nvarchar(1000)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT X509IdentityKey, PrivateIdentityKey from [dbo].[EncryptionStates] WHERE Id = @Id)
		BEGIN
			UPDATE EncryptionStates
			SET X509IdentityKey = @X509IdentityKey, PrivateIdentityKey = @PrivateIdentityKey
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[EncryptionStates] (Id, X509IdentityKey,PrivateIdentityKey)
			VALUES (@Id, @X509IdentityKey,@PrivateIdentityKey)
		END

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetMessages]    Script Date: 4/7/2021 9:57:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetMessages]
	@Id nvarchar(450),
	@Messages nvarchar(MAX)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT Messages from [dbo].[Messages] WHERE Id = @Id)
		BEGIN
			UPDATE [dbo].[Messages]
			SET Messages = @Messages 
			where Id =@id;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[Messages] (Id ,Messages)
			VALUES (@Id, @Messages)
		END

RETURN 0
GO
