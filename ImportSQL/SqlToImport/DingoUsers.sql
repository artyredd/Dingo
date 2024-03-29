CREATE DATABASE DingoUsers;
GO
USE [DingoUsers]
GO
/****** Object:  Table [dbo].[Avatars]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Avatars](
	[Id] [nvarchar](450) NOT NULL,
	[Avatar] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FriendsLists]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FriendsLists](
	[Id] [varchar](450) NOT NULL,
	[FriendsList] [varchar](max) NULL,
	[RequestList] [varchar](max) NULL,
	[BlockedList] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OAuth]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OAuth](
	[Id] [nvarchar](450) NOT NULL,
	[OAuth] [nvarchar](450) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfo](
	[Id] [nvarchar](450) NOT NULL,
	[DisplayName] [nvarchar](450) NOT NULL,
	[UniqueIdentifier] [smallint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[VirtualStatus] [tinyint] NOT NULL,
	[LastVirtualStatus] [tinyint] NOT NULL,
	[AvatarPath] [nvarchar](512) NULL,
	[NameHash] [nvarchar](32) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Avatars] ADD  DEFAULT (NULL) FOR [Avatar]
GO
ALTER TABLE [dbo].[FriendsLists] ADD  CONSTRAINT [DF_FriendsLists_FriendsList]  DEFAULT ('[]') FOR [FriendsList]
GO
ALTER TABLE [dbo].[FriendsLists] ADD  CONSTRAINT [DF_FriendsLists_RequestList]  DEFAULT ('[]') FOR [RequestList]
GO
ALTER TABLE [dbo].[FriendsLists] ADD  CONSTRAINT [DF_FriendsLists_BlockedList]  DEFAULT ('[]') FOR [BlockedList]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ((0)) FOR [UniqueIdentifier]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ((0)) FOR [VirtualStatus]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ((0)) FOR [LastVirtualStatus]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ('/Images/DefaultAvatar.png') FOR [AvatarPath]
GO
ALTER TABLE [dbo].[UserInfo] ADD  DEFAULT ('') FOR [NameHash]
GO
/****** Object:  StoredProcedure [dbo].[ChangeDisplayName]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ChangeDisplayName] 
	@Id nvarchar(450), 
	@DisplayName nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update [dbo].[UserInfo] Set DisplayName = @DisplayName WHERE Id=@id;

	DECLARE @UniqueId NVARCHAR(32);

	SET @UniqueId = CONVERT(NVARCHAR(32), (SELECT UniqueIdentifier from [DingoUsers].[dbo].[UserInfo] WHERE Id=@id));

	DECLARE @NameHash NVARCHAR(32);

	SET @NameHash = HASHBYTES('SHA2_256', LOWER(CONCAT(@DisplayName,'#',@UniqueId)));

	Update [DingoUsers].[dbo].[UserInfo] Set NameHash = @NameHash WHERE Id=@id;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateNewUser]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateNewUser]
	@Id nvarchar(450)
AS
	Insert into [dbo].[FriendsLists] (Id)
	VALUES (@Id);
	Insert into [dbo].[Avatars] (Id)
	VALUEs (@Id);
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUser] 
	@Id nvarchar(450)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE from [dbo].[UserInfo] where Id=@Id;
	DELETE from [dbo].[FriendsLists] where Id=@Id;
	DELETE from [dbo].[OAuth] where Id=@Id;
	DELETE from [dbo].[Avatars] where Id=@Id;
END
GO
/****** Object:  StoredProcedure [dbo].[FindIdByNameHash]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindIdByNameHash]
	@NameHash NVARCHAR(32)
AS
	SET NOCOUNT ON;

	SELECT Id FROM [dbo].[UserInfo] where NameHash = @NameHash;

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetAvatar]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAvatar]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT Avatar from [dbo].[Avatars] WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetBlockedList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBlockedList] @Id nvarchar(450)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select BlockedList from [dbo].[FriendsLists] where Id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[GetDisplayName]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDisplayName] @Id nvarchar(450)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DisplayName from UserInfo where Id = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[GetFriend]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFriend]
	@Id nvarchar (450)
AS
	SELECT Id, DisplayName, Status, VirtualStatus, AvatarPath, UniqueIdentifier
	from [DingoUsers].[dbo].[UserInfo] where Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetFriendsList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFriendsList] @Id nvarchar(450)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select FriendsList from [dbo].[FriendsLists] where Id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[GetLastVirtualStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLastVirtualStatus]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON
	SELECT LastVirtualStatus FROM [dbo].[UserInfo] WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetOAuth]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOAuth]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON;

	SELECT OAuth from [dbo].[OAuth] where Id=@Id;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetRequestList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRequestList] @Id nvarchar(450)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select RequestList from [dbo].[FriendsLists] where Id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[GetStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStatus]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON
	SELECT Status FROM [dbo].[UserInfo] WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetUniqueIdentifiersWithDisplayName]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUniqueIdentifiersWithDisplayName]
	@DisplayName nvarchar(450)
AS
	SELECT UniqueIdentifier 
	from [DingoUsers].[dbo].[UserInfo] where DisplayName = @DisplayName
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetVirtualStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVirtualStatus]
	@Id nvarchar(450)
AS
	SET NOCOUNT ON
	SELECT VirtualStatus FROM [dbo].[UserInfo] WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SearchForFriend]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchForFriend]
	@DisplayName nvarchar(450)
AS
	SELECT Id,UniqueIdentifier from [DingoUsers].[dbo].[UserInfo] where DisplayName = @DisplayName
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetAvatar]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetAvatar]
	@Id nvarchar(450),
	@Avatar nvarchar(MAX)
AS
	SET NOCOUNT ON;

	IF EXISTS(SELECT Avatar from [dbo].[Avatars] WHERE Id = @Id)
		BEGIN
			UPDATE Avatars
			SET Avatar = @Avatar
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[Avatars] (Id ,Avatar)
			VALUES (@Id, @Avatar)
		END

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetBlockedList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetBlockedList] 
	@Id nvarchar(450),
	@BlockedList nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update [DingoUsers].[dbo].[FriendsLists] Set BlockedList=@BlockedList WHERE Id=@id;
END
GO
/****** Object:  StoredProcedure [dbo].[SetDisplayName]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetDisplayName] @Id nvarchar(450), @DisplayName nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO UserInfo (Id,DisplayName) VALUES (@Id,@DisplayName)
END
GO
/****** Object:  StoredProcedure [dbo].[SetFriendsList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetFriendsList]
	@Id nvarchar(450),
	@FriendsList nvarchar(max)
AS
	Update [DingoUsers].[dbo].[FriendsLists] Set FriendsList=@FriendsList WHERE Id=@id;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetLastVirtualStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetLastVirtualStatus]
	@Id nvarchar(450),
	@Status tinyint
AS
	SET NOCOUNT ON
	UPDATE [dbo].[UserInfo]
	SET LastVirtualStatus = @Status WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetOAuth]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetOAuth]
	@Id nvarchar(450),
	@OAuth nvarchar(450)
AS
	SET NOCOUNT ON;

	INSERT INTO [dbo].[OAuth]
	(Id,OAuth)
	VALUES (@Id,@OAuth);
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetRequestList]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetRequestList] 
	@Id nvarchar(450),
	@RequestList nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update [DingoUsers].[dbo].[FriendsLists] Set RequestList=@RequestList WHERE Id=@id;
END
GO
/****** Object:  StoredProcedure [dbo].[SetStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetStatus]
	@Id nvarchar(450),
	@Status tinyint
AS
	SET NOCOUNT ON
	UPDATE [dbo].[UserInfo]
	SET Status = @Status WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetUniqueIdentifier]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetUniqueIdentifier]
	@Id nvarchar(450),
	@UniqueIdentifier smallint
AS
	Update [DingoUsers].[dbo].[UserInfo]
	SET [UniqueIdentifier] = @UniqueIdentifier
	WHERE Id = @Id

	DECLARE @DisplayName NVARCHAR(100);

	SET @DisplayName = CONVERT(NVARCHAR(100), (SELECT DisplayName from [DingoUsers].[dbo].[UserInfo] WHERE Id=@id));

	DECLARE @NameHash NVARCHAR(32);

	SET @NameHash = HASHBYTES('SHA2_256', LOWER(CONCAT(@DisplayName,'#',@UniqueIdentifier)));

	Update [DingoUsers].[dbo].[UserInfo] Set NameHash = @NameHash WHERE Id=@id;

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetVirtualStatus]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetVirtualStatus]
	@Id nvarchar(450),
	@Status tinyint
AS
	SET NOCOUNT ON
	UPDATE [dbo].[UserInfo]
	SET VirtualStatus = @Status WHERE Id = @Id
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[UniqueIdentifierAvailable]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UniqueIdentifierAvailable]
	@DisplayName nvarchar(450),
	@UniqueIdentifier smallint
AS
	SET NOCOUNT ON;

	SELECT UniqueIdentifier from [dbo].[UserInfo] where DisplayName = @DisplayName AND UniqueIdentifier = @UniqueIdentifier;
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[UpdateOAuth]    Script Date: 4/7/2021 9:57:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateOAuth]
	@Id nvarchar(450),
	@OAuth nvarchar(450)
AS
	SET NOCOUNT ON;

	UPDATE [dbo].[OAuth] SET OAuth = @OAuth where Id = @Id;
RETURN 0
GO
