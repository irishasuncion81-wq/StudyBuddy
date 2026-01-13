Imports System.Configuration
Imports System.Data
Imports Microsoft.VisualBasic.ApplicationServices
Imports MySql.Data.MySqlClient
Imports Org.BouncyCastle.Tls
Imports Microsoft.AspNet.SignalR

Public Class Chatroom
    Inherits System.Web.UI.Page

    Private connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        UpdateUserLastSeen(Convert.ToInt32(Session("UserID")))

        If Not IsPostBack Then
            LoadFriends()
            LoadUserGroups()
            PopulateMemberSelection()
        End If

        ' Restore Label for BOTH Friend and Group 
        If Session("FriendID") IsNot Nothing AndAlso Convert.ToInt32(Session("FriendID")) > 0 Then
            ' Para sa Private Chat
            Dim fID As Integer = Convert.ToInt32(Session("FriendID"))
            lblFriendName.Text = "Chatting with: " & GetUserName(fID)
            phChatBox.Visible = True
            phChatInput.Visible = True
        ElseIf Session("RoomID") IsNot Nothing AndAlso Convert.ToInt32(Session("RoomID")) > 0 Then
            ' Para sa Group Chat
            If Session("GroupName") IsNot Nothing Then
                lblFriendName.Text = Session("GroupName").ToString()
                phChatBox.Visible = True
                phChatInput.Visible = True
            End If
        End If

        If Session("RoomID") IsNot Nothing Then
            LoadMessages()
        End If

        CheckUserBanStatus()
    End Sub

    Protected Sub btnBackToList_Click(sender As Object, e As EventArgs)

        phChatInput.Visible = False
        lblFriendName.Text = "Select a buddy to chat"

        rptMessages.DataSource = Nothing
        rptMessages.DataBind()

        Response.Redirect("Chatroom.aspx")
    End Sub

    ' LOADING LOGIC 
    Private Sub LoadFriends()
        Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)
            Dim query As String = "SELECT DISTINCT CASE WHEN f.FromUserID = @UID THEN f.ToUserID ELSE f.FromUserID END AS FriendUserID, " &
                "CONCAT(r.FirstName, ' ', r.LastName) AS FullName, r.ProfilePicture, " &
                "IF(TIMESTAMPDIFF(SECOND, r.last_seen, NOW()) <= 60, 'Online', 'Offline') AS OnlineStatus " &
                "FROM friendrequests f INNER JOIN register r ON r.UserID = CASE WHEN f.FromUserID = @UID THEN f.ToUserID ELSE f.FromUserID END " &
                "WHERE (f.FromUserID = @UID OR f.ToUserID = @UID) AND f.Status = 'Accepted' ORDER BY FullName ASC"
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@UID", currentUserId)
                conn.Open()
                rptFriends.DataSource = cmd.ExecuteReader()
                rptFriends.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadUserGroups()
        Dim currentUserID As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "SELECT r.RoomID, r.RoomName, r.RoomImage " &
                   "FROM rooms r " &
                   "INNER JOIN roommembers rm ON r.RoomID = rm.RoomID " &
                   "WHERE rm.UserID = @UID AND r.is_group = 1"

            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UID", currentUserID)
                conn.Open()
                rptGroups.DataSource = cmd.ExecuteReader()
                rptGroups.DataBind()
            End Using
        End Using
    End Sub

    Private Sub PopulateMemberSelection()
        Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)
            Dim query As String = "SELECT DISTINCT CASE WHEN f.FromUserID = @UID THEN f.ToUserID ELSE f.FromUserID END AS FriendUserID, " &
                "CONCAT(r.FirstName, ' ', r.LastName) AS FullName FROM friendrequests f " &
                "INNER JOIN register r ON r.UserID = CASE WHEN f.FromUserID = @UID THEN f.ToUserID ELSE f.FromUserID END " &
                "WHERE (f.FromUserID = @UID OR f.ToUserID = @UID) AND f.Status = 'Accepted'"
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@UID", currentUserId)
                conn.Open()
                cblMembers.DataSource = cmd.ExecuteReader()
                cblMembers.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadMessages()
        If Session("RoomID") Is Nothing Then Exit Sub

        Using conn As New MySqlConnection(connStr)
            Dim query As String = "SELECT m.SenderID, m.Content, m.TimeStamp, " &
                             "CONCAT(r.FirstName, ' ', r.LastName) AS SenderName, " &
                             "r.ProfilePicture " &
                             "FROM messages m " &
                             "INNER JOIN register r ON m.SenderID = r.UserID " &
                             "WHERE m.RoomID = @RID ORDER BY m.TimeStamp ASC"

            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RID", Session("RoomID"))
                conn.Open()

                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())

                lastDisplayedDate = ""

                rptMessages.DataSource = dt
                rptMessages.DataBind()
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ScrollKey", "scrollToBottom();", True)
    End Sub

    ' CLICK EVENTS 
    Protected Sub Friend_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim receiverId As Integer = Convert.ToInt32(btn.CommandArgument)
        Dim friendName As String = btn.CommandName ' Kunin ang FullName mula sa CommandName

        ' I-save sa Session para sa persistence
        Session("FriendID") = receiverId
        Session("FriendName") = friendName
        Session("RoomID") = Nothing
        Session("GroupName") = Nothing

        ' I-update ang Label
        lblFriendName.Text = "Chatting with: " & friendName
        Dim senderId As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim roomId As Integer = GetExistingRoom(senderId, receiverId, conn)
            Session("RoomID") = roomId
        End Using

        If Session("RoomID") = 0 Then
            rptMessages.DataSource = Nothing
            rptMessages.DataBind()
        Else
            LoadMessages()
        End If

        phChatInput.Visible = True
        phChatBox.Visible = True
    End Sub

    Protected Sub Group_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim roomId As Integer = Convert.ToInt32(btn.CommandArgument)

        Session("RoomID") = Convert.ToInt32(btn.CommandArgument)
        Session("FriendID") = 0


        Session("GroupName") = btn.CommandName
        lblFriendName.Text = btn.CommandName
        btnShowMembers.Visible = True '"See Members" button
        LoadGroupMembers(roomId)
        LoadAddableBuddies(roomId)

        phChatInput.Visible = True
        phChatBox.Visible = True
        LoadMessages()
    End Sub

    ' CREATE GROUP LOGIC
    Protected Sub btnCreateRoom_Click(sender As Object, e As EventArgs)
        Dim creatorID As Integer = Convert.ToInt32(Session("UserID"))
        Dim roomName As String = txtNewRoomName.Text.Trim()
        Dim fileName As String = "STUDYBUDDY.png"

        If fuGroupPhoto.HasFile Then
            Try
                Dim ext As String = System.IO.Path.GetExtension(fuGroupPhoto.FileName).ToLower()
                If ext = ".jpg" Or ext = ".png" Or ext = ".jpeg" Then
                    fileName = "group_" & Guid.NewGuid().ToString().Substring(0, 8) & ext
                    Dim path As String = Server.MapPath("~/Uploads/") & fileName
                    fuGroupPhoto.SaveAs(path)
                End If
            Catch ex As Exception
            End Try
        End If

        If String.IsNullOrEmpty(roomName) Then Exit Sub

        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Using trans = conn.BeginTransaction()
                Try
                    ' Create Room 
                    Dim sqlRoom As String = "INSERT INTO rooms (RoomName, is_group, CreatedBy, RoomImage) VALUES (@Name, 1, @UID, @Img); SELECT LAST_INSERT_ID();"
                    Dim newRoomID As Integer

                    Using cmd = New MySqlCommand(sqlRoom, conn, trans)
                        cmd.Parameters.AddWithValue("@Name", roomName)
                        cmd.Parameters.AddWithValue("@UID", creatorID)
                        cmd.Parameters.AddWithValue("@Img", fileName)
                        newRoomID = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using

                    ' Add creator to room 
                    Dim sqlMember As String = "INSERT INTO roommembers (RoomID, UserID) VALUES (@RID, @UID)"
                    Using cmdMe = New MySqlCommand(sqlMember, conn, trans)
                        cmdMe.Parameters.AddWithValue("@RID", newRoomID)
                        cmdMe.Parameters.AddWithValue("@UID", creatorID)
                        cmdMe.ExecuteNonQuery()
                    End Using

                    ' add chosen user
                    For Each item As ListItem In cblMembers.Items
                        If item.Selected Then
                            Using cmdFriend = New MySqlCommand(sqlMember, conn, trans)
                                cmdFriend.Parameters.AddWithValue("@RID", newRoomID)
                                cmdFriend.Parameters.AddWithValue("@UID", item.Value)
                                cmdFriend.ExecuteNonQuery()
                            End Using
                        End If
                    Next

                    trans.Commit()
                    Response.Redirect("Chatroom.aspx")

                Catch ex As Exception
                    Try
                        If trans IsNot Nothing AndAlso trans.Connection IsNot Nothing Then
                            trans.Rollback()
                        End If
                    Catch rollbackEx As Exception

                    End Try

                    Response.Write("<script>alert('Error: " & ex.Message.Replace("'", "") & "');</script>")
                End Try
            End Using
        End Using
    End Sub

    ' SEND MESSAGE & PENALTY 
    Protected Sub btnSend_Click(sender As Object, e As EventArgs)
        ' BASIC VALIDATION
        If Session("UserID") Is Nothing OrElse Session("FriendID") Is Nothing Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a friend to start chatting.');", True)
            Exit Sub
        End If

        ' MESSAGE CONTENT VALIDATION
        Dim messageText As String = txtMessage.Text.Trim()
        If String.IsNullOrEmpty(messageText) Then Exit Sub

        ' Character Limit Check
        Dim msg As String = txtMessage.Text.Trim()

        If msg.Length > 50 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Message is too long!');", True)
            Return
        End If

        ' INITIALIZE VARIABLES
        Dim senderId As Integer = Convert.ToInt32(Session("UserID"))
        Dim targetUserId As Integer = Convert.ToInt32(Session("FriendID"))
        Dim senderName As String = If(Session("UserName") IsNot Nothing, Session("UserName").ToString(), "Someone")

        Dim roomId As Integer = 0
        If Session("RoomID") IsNot Nothing Then
            roomId = Convert.ToInt32(Session("RoomID"))
        End If

        Try
            Using conn As New MySqlConnection(connStr)
                conn.Open()

                ' ROOM CREATION ON DEMAND 
                If roomId = 0 Then
                    ' Create new room
                    Dim sqlNewRoom As String = "INSERT INTO rooms (RoomName, is_group) VALUES ('Private Chat', 0); SELECT LAST_INSERT_ID();"
                    Using cmdNew = New MySqlCommand(sqlNewRoom, conn)
                        roomId = Convert.ToInt32(cmdNew.ExecuteScalar())
                    End Using

                    ' add 2 users to roommembers
                    Dim sqlMembers As String = "INSERT INTO roommembers (RoomID, UserID) VALUES (@RID, @UID)"

                    ' Add Sender (You)
                    Using cmdU1 = New MySqlCommand(sqlMembers, conn)
                        cmdU1.Parameters.AddWithValue("@RID", roomId)
                        cmdU1.Parameters.AddWithValue("@UID", senderId)
                        cmdU1.ExecuteNonQuery()
                    End Using

                    ' Add Receiver (Friend)
                    Using cmdU2 = New MySqlCommand(sqlMembers, conn)
                        cmdU2.Parameters.AddWithValue("@RID", roomId)
                        cmdU2.Parameters.AddWithValue("@UID", targetUserId)
                        cmdU2.ExecuteNonQuery()
                    End Using

                    Session("RoomID") = roomId
                End If

                ' PROFANITY & FILTERING LOGIC 
                Dim userRole As String = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "User")
                Dim flagged As Boolean = False
                Dim reason As String = ""
                Dim warningLevel As Integer = 0

                If userRole <> "Admin" Then
                    Dim profanityWords As String() = {"putangina", "puta", "tangina", "gago", "gaga", "punyeta", "lintik", "bwisit", "leche", "gagu", "piste", "pisti"}
                    Dim bullyingWords As String() = {"ulol", "tarantado", "hayop", "animal", "siraulo", "baliw", "buang", "tanga", "bobo", "inutil", "basura", "kupal", "epal", "pabida", "salot", "tukmol", "pangit"}
                    Dim harassmentWords As String() = {"kantot", "iyot", "jakol", "tamod", "pokpok", "malandi", "manyakis", "bayag", "betlog", "burat", "titi", "pepe", "kipay", "puke", "dede", "suso"}

                    Dim normalizedMsg As String = messageText.ToLower() _
                    .Replace("@", "a").Replace("4", "a").Replace("0", "o") _
                    .Replace("3", "e").Replace("!", "i").Replace("1", "i") _
                    .Replace("$", "s").Replace("7", "t").Replace("*", "") _
                    .Replace(" ", "").Replace(".", "").Replace("-", "").Replace("_", "")

                    ' Check Harassment
                    For Each word In harassmentWords
                        If normalizedMsg.Contains(word) Then
                            flagged = True : warningLevel = 3 : reason = "Harassment detected" : Exit For
                        End If
                    Next

                    ' Check Bullying
                    If Not flagged Then
                        For Each word In bullyingWords
                            If normalizedMsg.Contains(word) Then
                                flagged = True : warningLevel = 2 : reason = "Bullying detected" : Exit For
                            End If
                        Next
                    End If

                    ' Check Profanity
                    If Not flagged Then
                        For Each word In profanityWords
                            If normalizedMsg.Contains(word) Then
                                flagged = True : warningLevel = 1 : reason = "Profanity detected" : Exit For
                            End If
                        Next
                    End If
                End If

                ' INSERT THE MESSAGE
                Dim sqlInsert = "INSERT INTO messages (RoomID, SenderID, Content, TimeStamp, is_flagged, flag_reason) " &
                            "VALUES (@RoomID, @SenderID, @Content, NOW(), @flagged, @reason)"

                Using cmdMsg = New MySqlCommand(sqlInsert, conn)
                    cmdMsg.Parameters.AddWithValue("@RoomID", roomId)
                    cmdMsg.Parameters.AddWithValue("@SenderID", senderId)
                    cmdMsg.Parameters.AddWithValue("@Content", messageText)
                    cmdMsg.Parameters.AddWithValue("@flagged", flagged)
                    cmdMsg.Parameters.AddWithValue("@reason", If(flagged, reason, DBNull.Value))
                    cmdMsg.ExecuteNonQuery()
                End Using

                ' NOTIFICATION LOGIC 
                If Not flagged Then
                    If Session("RoomID") IsNot Nothing Then
                        Dim currentRoomID As Integer = Convert.ToInt32(Session("RoomID"))

                        Dim sqlGetMembers As String = "SELECT UserID FROM roommembers WHERE RoomID = @RID AND UserID <> @UID"

                        Using connNotif As New MySqlConnection(connStr)
                            connNotif.Open()
                            Dim members As New List(Of Integer)
                            Using cmdMem = New MySqlCommand(sqlGetMembers, connNotif)
                                cmdMem.Parameters.AddWithValue("@RID", currentRoomID)
                                cmdMem.Parameters.AddWithValue("@UID", senderId)
                                Using reader = cmdMem.ExecuteReader()
                                    While reader.Read()
                                        members.Add(reader.GetInt32(0))
                                    End While
                                End Using
                            End Using

                            For Each memID In members
                                Dim notifMsg As String = ""
                                If Session("FriendID") IsNot Nothing AndAlso Convert.ToInt32(Session("FriendID")) > 0 Then
                                    notifMsg = "You received a new message from " & senderName
                                Else
                                    notifMsg = senderName & " sent a message in " & Session("GroupName").ToString()
                                End If

                                Dim sqlInsertNotif As String = "INSERT INTO notifications (UserID, Message, IsRead, DateCreated) VALUES (@UID, @Msg, 0, NOW())"
                                Using cmdIns = New MySqlCommand(sqlInsertNotif, connNotif)
                                    cmdIns.Parameters.AddWithValue("@UID", memID)
                                    cmdIns.Parameters.AddWithValue("@Msg", notifMsg)
                                    cmdIns.ExecuteNonQuery()
                                End Using
                            Next
                        End Using
                    End If
                End If

                ' PENALTY LOGIC
                If flagged AndAlso userRole <> "Admin" Then
                    ApplyAutoPenalty(senderId, warningLevel, reason, conn)
                End If

                txtMessage.Text = ""
                LoadMessages()

                phChatBox.Visible = True
                phChatInput.Visible = True

                If Session("FriendID") IsNot Nothing AndAlso Convert.ToInt32(Session("FriendID")) > 0 Then
                    lblFriendName.Text = "Chatting with: " & GetUserName(Convert.ToInt32(Session("FriendID")))
                ElseIf Session("GroupName") IsNot Nothing Then
                    lblFriendName.Text = Session("GroupName").ToString()
                    btnShowMembers.Visible = True
                End If

            End Using
        Catch ex As Exception
        End Try

        LoadMessages()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ScrollKey", "scrollToBottom();", True)
    End Sub


    ' --- 4. HELPERS (MAHALAGA) ---
    Private Function GetExistingRoom(user1 As Integer, user2 As Integer, conn As MySqlConnection) As Integer
        Dim sqlCheck As String = "SELECT rm1.RoomID FROM roommembers rm1 " &
                             "JOIN roommembers rm2 ON rm1.RoomID = rm2.RoomID " &
                             "JOIN rooms r ON rm1.RoomID = r.RoomID " &
                             "WHERE r.is_group = 0 AND rm1.UserID = @U1 AND rm2.UserID = @U2 LIMIT 1"

        Using cmdCheck As New MySqlCommand(sqlCheck, conn)
            cmdCheck.Parameters.AddWithValue("@U1", user1)
            cmdCheck.Parameters.AddWithValue("@U2", user2)
            Dim result = cmdCheck.ExecuteScalar()

            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                Return Convert.ToInt32(result)
            End If
        End Using
        Return 0
    End Function

    Private Function GetUserName(id As Integer) As String
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "SELECT CONCAT(FirstName, ' ', LastName) FROM register WHERE UserID = @ID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", id)
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                Return If(result IsNot Nothing, result.ToString(), "Unknown User")
            End Using
        End Using
    End Function

    Private Sub UpdateUserLastSeen(userId As Integer)
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "UPDATE register SET last_seen = NOW() WHERE UserID = @ID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", userId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub CheckUserBanStatus()
        Dim userId As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "SELECT ban_until FROM register WHERE UserID = @ID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", userId)
                conn.Open()
                Dim banUntil = cmd.ExecuteScalar()
                If banUntil IsNot DBNull.Value AndAlso Convert.ToDateTime(banUntil) > DateTime.Now Then
                    Session.Abandon()
                    Response.Redirect("Login.aspx?msg=You are banned until " & Convert.ToDateTime(banUntil).ToString())
                End If
            End Using
        End Using
    End Sub
    Private Sub ApplyAutoPenalty(userID As Integer, level As Integer, reason As String, conn As MySqlConnection)
        Dim banMsg As String = ""
        Dim sqlUpdate As String = ""

        If level = 1 Then
            sqlUpdate = "UPDATE register SET warning_count = warning_count + 1 WHERE UserID = @UID AND UserType <> 'Admin'; " &
                    "UPDATE register SET ban_until = DATE_ADD(NOW(), INTERVAL 1 DAY), warning_count = 0 " &
                    "WHERE UserID = @UID AND warning_count >= 3 AND UserType <> 'Admin';"
            banMsg = "System: Your message was flagged as profanity. 3 strikes will result in a 24h ban. Please be nice to your buddy :)"

        ElseIf level = 2 Then
            sqlUpdate = "UPDATE register SET ban_until = DATE_ADD(NOW(), INTERVAL 3 DAY), warning_count = 0 " &
                    "WHERE UserID = @UID AND UserType <> 'Admin'"
            banMsg = "System: Restricted for 3 days due to Bullying. Please be nice to your buddy :)"

        ElseIf level = 3 Then
            sqlUpdate = "UPDATE register SET ban_until = DATE_ADD(NOW(), INTERVAL 5 DAY), warning_count = 0 " &
                    "WHERE UserID = @UID AND UserType <> 'Admin'"
            banMsg = "System: Restricted for 5 days due to Harassment. Please spread kindness."
        End If

        If String.IsNullOrEmpty(sqlUpdate) Then Exit Sub


        Using cmd = New MySqlCommand(sqlUpdate, conn)
            cmd.Parameters.AddWithValue("@UID", userID)
            cmd.ExecuteNonQuery()
        End Using

        Dim sqlNotify = "INSERT INTO notifications (UserID, Message, IsRead) VALUES (@UID, @Msg, 0)"
        Using cmdNotify = New MySqlCommand(sqlNotify, conn)
            cmdNotify.Parameters.AddWithValue("@UID", userID)
            cmdNotify.Parameters.AddWithValue("@Msg", banMsg)
            cmdNotify.ExecuteNonQuery()
        End Using
    End Sub

    ' LEAVE LOGIC
    Protected Sub LeaveGroup_Command(sender As Object, e As CommandEventArgs)
        Dim roomId As Integer = Convert.ToInt32(e.CommandArgument)
        Dim userId As Integer = Convert.ToInt32(Session("UserID"))
        ExecuteDeleteMember(roomId, userId)
        LoadUserGroups()
        lblFriendName.Text = "Select a buddy to chat"
        phChatInput.Visible = False
    End Sub

    ' KICK LOGIC
    Protected Sub KickMember_Command(sender As Object, e As CommandEventArgs)
        Dim data As String() = e.CommandArgument.ToString().Split("|"c)
        Dim roomId As Integer = Convert.ToInt32(data(0))
        Dim targetUserId As Integer = Convert.ToInt32(data(1))

        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "DELETE FROM roommembers WHERE RoomID = @RID AND UserID = @UID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@RID", roomId)
                cmd.Parameters.AddWithValue("@UID", targetUserId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadGroupMembers(roomId)
    End Sub

    ' HELPER FUNCTIONS
    Private Sub ExecuteDeleteMember(roomId As Integer, userId As Integer)
        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim sql = "DELETE FROM roommembers WHERE RoomID = @RID AND UserID = @UID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@RID", roomId)
                cmd.Parameters.AddWithValue("@UID", userId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ' check if the current user is the admin of the group
    Public Function IsUserAdmin(roomId As Object) As Boolean
        If roomId Is Nothing OrElse Session("UserID") Is Nothing Then Return False

        Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
        Dim targetRoomId As Integer = Convert.ToInt32(roomId)

        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "SELECT CreatedBy FROM rooms WHERE RoomID = @RID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@RID", targetRoomId)
                conn.Open()
                Dim dbValue = cmd.ExecuteScalar()

                If dbValue IsNot DBNull.Value AndAlso Convert.ToInt32(dbValue) = currentUserId Then
                    Return True
                End If
            End Using
        End Using
        Return False
    End Function

    Private Sub LoadGroupMembers(roomId As Integer)
        Using conn As New MySqlConnection(connStr)
            Dim query = "SELECT rm.RoomID, rm.UserID, CONCAT(r.FirstName, ' ', r.LastName) as FullName " &
                        "FROM roommembers rm INNER JOIN register r ON rm.UserID = r.UserID " &
                        "WHERE rm.RoomID = @RID"
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RID", roomId)
                conn.Open()
                rptGroupMembers.DataSource = cmd.ExecuteReader()
                rptGroupMembers.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadAddableBuddies(roomId As Integer)
        Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
        Using conn As New MySqlConnection(connStr)

            Dim query As String = "SELECT DISTINCT r.UserID, CONCAT(r.FirstName, ' ', r.LastName) AS FullName " &
                                  "FROM register r " &
                                  "INNER JOIN friendrequests f ON (r.UserID = f.ToUserID OR r.UserID = f.FromUserID) " &
                                  "WHERE ((f.FromUserID = @UID AND f.ToUserID = r.UserID) OR (f.ToUserID = @UID AND f.FromUserID = r.UserID)) " &
                                  "AND f.Status = 'Accepted' AND r.UserID <> @UID " &
                                  "AND r.UserID NOT IN (SELECT UserID FROM roommembers WHERE RoomID = @RID)"

            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@UID", currentUserId)
                cmd.Parameters.AddWithValue("@RID", roomId)
                conn.Open()

                ddlAddBuddies.DataSource = cmd.ExecuteReader()
                ddlAddBuddies.DataTextField = "FullName"
                ddlAddBuddies.DataValueField = "UserID"
                ddlAddBuddies.DataBind()
            End Using
        End Using
        ddlAddBuddies.Items.Insert(0, New ListItem("-- Select Buddy --", "0"))
    End Sub

    Protected Sub btnAddMember_Click(sender As Object, e As EventArgs)
        If ddlAddBuddies.SelectedValue = "0" OrElse Session("RoomID") Is Nothing OrElse Session("GroupName") Is Nothing Then
            Exit Sub
        End If

        Dim roomId As Integer = Convert.ToInt32(Session("RoomID"))
        Dim newMemberId As Integer = Convert.ToInt32(ddlAddBuddies.SelectedValue)
        Dim groupName As String = Session("GroupName").ToString()
        Dim adminName As String = GetUserName(Convert.ToInt32(Session("UserID")))

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' I-INSERT ANG BAGONG MEMBER SA GROUP
            Dim sqlMember As String = "INSERT INTO roommembers (RoomID, UserID) VALUES (@RID, @UID)"
            Using cmdMember As New MySqlCommand(sqlMember, conn)
                cmdMember.Parameters.AddWithValue("@RID", roomId)
                cmdMember.Parameters.AddWithValue("@UID", newMemberId)
                cmdMember.ExecuteNonQuery()
            End Using

            ' I-INSERT ANG NOTIFICATION PARA SA IN-ADD NA MEMBER
            Dim sqlNotif As String = "INSERT INTO notifications (UserID, Message, IsRead, DateCreated) VALUES (@UID, @Msg, 0, NOW())"
            Using cmdNotif As New MySqlCommand(sqlNotif, conn)
                cmdNotif.Parameters.AddWithValue("@UID", newMemberId)
                cmdNotif.Parameters.AddWithValue("@Msg", adminName & " added you to the group: " & groupName)
                cmdNotif.ExecuteNonQuery()
            End Using
        End Using

        LoadGroupMembers(roomId)
        LoadAddableBuddies(roomId)

        ddlAddBuddies.SelectedIndex = 0
    End Sub

    Public lastDisplayedDate As String = ""

    Public Function ShowDateSeparator(ByVal timeStamp As Object) As String
        If timeStamp Is Nothing OrElse IsDBNull(timeStamp) Then Return ""

        Dim msgDate As String = Convert.ToDateTime(timeStamp).ToString("MMMM dd, yyyy")

        If msgDate <> lastDisplayedDate Then
            lastDisplayedDate = msgDate
            Return $"<div class='date-separator'><span>{msgDate}</span></div>"
        End If

        Return ""
    End Function
End Class
