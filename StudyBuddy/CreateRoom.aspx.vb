Imports MySql.Data.MySqlClient

Public Class CreateRoom
    Inherits System.Web.UI.Page

    Protected connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Optional: Show selected room title if needed
            If Session("SelectedRoom") IsNot Nothing Then
                ' If lblRoomTitle exists on this page, uncomment below
                ' lblRoomTitle.Text = "You’re now in " & Session("SelectedRoom").ToString()
            End If

            Dim roomIdStr As String = Request.QueryString("roomId")
            Dim roomId As Integer
            If Integer.TryParse(roomIdStr, roomId) Then
                LoadRoomDetails(roomId)
                LoadRoomMembers(roomId)
            End If

            LoadUsers()
            LoadAvailableRooms()
        End If
    End Sub

    Private Sub LoadRoomDetails(roomId As Integer)
        ' Optional: Load room name, description, etc.
    End Sub

    Private Sub LoadRoomMembers(roomId As Integer)
        ' Optional: Load members into Active Friends panel
    End Sub

    Private Sub LoadUsers()
        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim query As String = "SELECT UserID, CONCAT(FirstName, ' ', LastName) AS FullName FROM users WHERE UserID <> @UserID"
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@UserID", Session("UserID"))
                Using reader As MySqlDataReader = cmd.ExecuteReader()
                    rptUsers.DataSource = reader
                    rptUsers.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub JoinRoom_Click(sender As Object, e As EventArgs)
        Dim roomName As String = CType(sender, LinkButton).CommandArgument
        Dim userId As Integer = Convert.ToInt32(Session("UserID"))
        Dim roomId As Integer

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' Check if room exists for this user
            Dim checkQuery As String = "SELECT RoomID FROM rooms WHERE RoomName = @RoomName"
            Using checkCmd As New MySqlCommand(checkQuery, conn)
                checkCmd.Parameters.AddWithValue("@RoomName", roomName)
                Dim result = checkCmd.ExecuteScalar()

                If result IsNot Nothing Then
                    roomId = Convert.ToInt32(result)
                Else
                    ' Create new room
                    Dim insertQuery As String = "INSERT INTO rooms (RoomName, CreatorID, CreatedAt) VALUES (@RoomName, @UserID, NOW())"
                    Using insertCmd As New MySqlCommand(insertQuery, conn)
                        insertCmd.Parameters.AddWithValue("@RoomName", roomName)
                        insertCmd.Parameters.AddWithValue("@UserID", userId)
                        insertCmd.ExecuteNonQuery()
                        roomId = Convert.ToInt32(insertCmd.LastInsertedId)
                    End Using

                    ' Add user to RoomMembers
                    Dim memberQuery As String = "INSERT INTO RoomMembers (RoomID, UserID) VALUES (@RoomID, @UserID)"
                    Using memberCmd As New MySqlCommand(memberQuery, conn)
                        memberCmd.Parameters.AddWithValue("@RoomID", roomId)
                        memberCmd.Parameters.AddWithValue("@UserID", userId)
                        memberCmd.ExecuteNonQuery()
                    End Using
                End If
            End Using
        End Using

        ' Save session and redirect to chat
        Session("RoomID") = roomId
        Session("SelectedRoom") = roomName
        Session("FriendID") = Nothing
        Response.Redirect("Chatroom.aspx")
    End Sub

    Private Sub LoadAvailableRooms()
        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim query As String = "SELECT DISTINCT RoomName FROM rooms"
            Using cmd As New MySqlCommand(query, conn)
                Using reader As MySqlDataReader = cmd.ExecuteReader()
                    rptAvailableRooms.DataSource = reader
                    rptAvailableRooms.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub btnCreateRoom_Click(sender As Object, e As EventArgs)
        Dim roomName As String = txtRoomName.Text.Trim()
        Dim selectedIds As String = hfSelectedUsers.Value
        Dim roomId As Integer

        If String.IsNullOrEmpty(roomName) OrElse String.IsNullOrEmpty(selectedIds) Then
            ' Optional: Show error message
            Exit Sub
        End If

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' Step 1: Insert room
            Dim insertRoomQuery As String = "INSERT INTO rooms (RoomName, CreatedAt) VALUES (@RoomName, NOW())"
            Using cmdRoom As New MySqlCommand(insertRoomQuery, conn)
                cmdRoom.Parameters.AddWithValue("@RoomName", roomName)
                cmdRoom.ExecuteNonQuery()
                roomId = Convert.ToInt32(cmdRoom.LastInsertedId)
            End Using

            ' Step 2: Add creator to RoomMembers
            Dim creatorId As Integer = Convert.ToInt32(Session("UserID"))
            Dim insertCreatorQuery As String = "INSERT INTO RoomMembers (RoomID, UserID) VALUES (@RoomID, @UserID)"
            Using cmdCreator As New MySqlCommand(insertCreatorQuery, conn)
                cmdCreator.Parameters.AddWithValue("@RoomID", roomId)
                cmdCreator.Parameters.AddWithValue("@UserID", creatorId)
                cmdCreator.ExecuteNonQuery()
            End Using

            ' Step 3: Add selected users to RoomMembers
            Dim userIds As String() = selectedIds.Split(","c)
            For Each id As String In userIds
                Dim insertMemberQuery As String = "INSERT INTO RoomMembers (RoomID, UserID) VALUES (@RoomID, @UserID)"
                Using cmdMember As New MySqlCommand(insertMemberQuery, conn)
                    cmdMember.Parameters.AddWithValue("@RoomID", roomId)
                    cmdMember.Parameters.AddWithValue("@UserID", Convert.ToInt32(id))
                    cmdMember.ExecuteNonQuery()
                End Using
            Next
        End Using

        ' Redirect to chatroom with roomId
        Response.Redirect("Chatroom.aspx?roomId=" & roomId)
    End Sub
End Class