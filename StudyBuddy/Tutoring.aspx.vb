Imports MySql.Data.MySqlClient

Partial Class Tutoring
    Inherits System.Web.UI.Page

    Dim connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    ' 🔄 Auto refresh every 3 seconds
    Protected Sub RefreshTimer_Tick(sender As Object, e As EventArgs)
        If Session("UserID") Is Nothing Then Exit Sub

        LoadUsers()
    End Sub


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        If Not IsPostBack Then
            LoadUsers()
        End If
    End Sub

    ' LOAD USERS 
    Private Sub LoadUsers(Optional searchTerm As String = "")
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            Dim q As String = "
            SELECT r.UserID,
                   r.UserName,
                   CONCAT(r.FirstName,' ',r.LastName) AS FullName,
                   r.Role,
                   r.ProfilePicture, 
                   (SELECT Status FROM friendrequests 
                    WHERE FromUserID = @Current AND ToUserID = r.UserID 
                    LIMIT 1) AS SentStatus,
                   (SELECT Status FROM friendrequests 
                    WHERE FromUserID = r.UserID AND ToUserID = @Current 
                    LIMIT 1) AS ReceivedStatus
            FROM register r
            WHERE r.UserID <> @Current 
            AND r.Role <> 'Admin'  
            AND r.UserID NOT IN (
                SELECT CASE 
                    WHEN FromUserID = @Current THEN ToUserID 
                    ELSE FromUserID 
                END
                FROM friendrequests 
                WHERE (FromUserID = @Current OR ToUserID = @Current) 
                AND Status = 'Accepted'
            )"

            'SEARCH LOGIC
            If Not String.IsNullOrEmpty(searchTerm) Then
                q &= " AND (r.UserName LIKE @search OR r.FirstName LIKE @search OR r.LastName LIKE @search)"
            End If

            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@Current", currentUserId)

                If Not String.IsNullOrEmpty(searchTerm) Then
                    cmd.Parameters.AddWithValue("@search", "%" & searchTerm & "%")
                End If

                Dim dt As New DataTable()
                Dim da As New MySqlDataAdapter(cmd)

                Try
                    conn.Open()
                    da.Fill(dt)

                    rptUsers.DataSource = dt
                    rptUsers.DataBind()
                Catch ex As Exception
                End Try
            End Using
        End Using
    End Sub

    ' ADD FRIEND 
    Protected Sub AddFriend_Click(sender As Object, e As EventArgs)
        Dim targetId As Integer = CInt(CType(sender, LinkButton).CommandArgument)
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' prevent duplicates
            Dim checkQ As String = "
                SELECT COUNT(*) FROM friendrequests
                WHERE (FromUserID=@A AND ToUserID=@B)
                   OR (FromUserID=@B AND ToUserID=@A)
            "

            Using chk As New MySqlCommand(checkQ, conn)
                chk.Parameters.AddWithValue("@A", currentUserId)
                chk.Parameters.AddWithValue("@B", targetId)
                If CInt(chk.ExecuteScalar()) > 0 Then Exit Sub
            End Using

            Dim insQ As String = "
                INSERT INTO friendrequests (FromUserID, ToUserID, Status)
                VALUES (@From,@To,'Pending')
            "

            Using cmd As New MySqlCommand(insQ, conn)
                cmd.Parameters.AddWithValue("@From", currentUserId)
                cmd.Parameters.AddWithValue("@To", targetId)
                cmd.ExecuteNonQuery()
            End Using

            InsertNotification(conn, targetId,
            "You received a friend request from " & GetUserName(currentUserId))
        End Using

        LoadUsers()
    End Sub

    ' CANCEL FRIEND REQUEST
    Protected Sub CancelRequest_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim targetUserId As Integer = CInt(btn.CommandArgument)
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim q As String = "DELETE FROM friendrequests WHERE FromUserID = @Current AND ToUserID = @Target AND Status = 'Pending'"
            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@Current", currentUserId)
                cmd.Parameters.AddWithValue("@Target", targetUserId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadUsers()
    End Sub


    ' ACCEPT 
    Protected Sub AcceptRequest_Click(sender As Object, e As EventArgs)
        Dim currentUserId As Integer = CInt(Session("UserID"))

        ' Validate sender argument
        Dim lb As LinkButton = TryCast(sender, LinkButton)
        If lb Is Nothing OrElse String.IsNullOrEmpty(lb.CommandArgument) Then
            Exit Sub
        End If

        Dim senderId As Integer
        If Not Integer.TryParse(lb.CommandArgument, senderId) Then
            Exit Sub
        End If

        ' do not allow accepting yourself
        If senderId = currentUserId Then
            Exit Sub
        End If

        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim tx = conn.BeginTransaction()
            Try
                ' Update the pending request from the nagrerequest
                Dim q As String = "
                UPDATE friendrequests
                SET Status='Accepted'
                WHERE FromUserID=@Sender AND ToUserID=@Current AND Status='Pending'
            "
                Using cmd As New MySqlCommand(q, conn, tx)
                    cmd.Parameters.AddWithValue("@Sender", senderId)
                    cmd.Parameters.AddWithValue("@Current", currentUserId)
                    Dim affected = cmd.ExecuteNonQuery()
                    If affected = 0 Then
                        tx.Rollback()
                        Exit Sub
                    End If
                End Using

                Dim updateReverse As String = "
                UPDATE friendrequests
                SET Status='Accepted'
                WHERE FromUserID=@Current AND ToUserID=@Sender
            "
                Using urCmd As New MySqlCommand(updateReverse, conn, tx)
                    urCmd.Parameters.AddWithValue("@Sender", senderId)
                    urCmd.Parameters.AddWithValue("@Current", currentUserId)
                    urCmd.ExecuteNonQuery()
                End Using

                ' Notifications
                InsertNotification(conn, senderId, GetUserName(currentUserId) & " accepted your friend request!")
                InsertNotification(conn, currentUserId, "You are now friends with " & GetUserName(senderId))

                tx.Commit()
            Catch ex As Exception
                Try
                    tx.Rollback()
                Catch
                End Try

                Exit Sub
            End Try
        End Using

        LoadUsers()
    End Sub

    ' REJECT 
    Protected Sub RejectRequest_Click(sender As Object, e As EventArgs)
        Dim senderId As Integer = CInt(CType(sender, LinkButton).CommandArgument)
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            Dim q As String = "
                DELETE FROM friendrequests
                WHERE FromUserID=@Sender AND ToUserID=@Current AND Status='Pending'
            "

            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@Sender", senderId)
                cmd.Parameters.AddWithValue("@Current", currentUserId)
                cmd.ExecuteNonQuery()
            End Using

            InsertNotification(conn, senderId,
            GetUserName(currentUserId) & " rejected your friend request.")
        End Using

        LoadUsers()
    End Sub

    ' LEAVE
    Protected Sub LeaveBuddy_Click(sender As Object, e As EventArgs)
        Dim buddyId As Integer = CInt(CType(sender, LinkButton).CommandArgument)
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            Dim q As String = "
                DELETE FROM friendrequests
                WHERE ((FromUserID=@A AND ToUserID=@B)
                    OR (FromUserID=@B AND ToUserID=@A))
                AND Status='Accepted'
            "

            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@A", currentUserId)
                cmd.Parameters.AddWithValue("@B", buddyId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadUsers()
    End Sub

    ' HELPERS
    Private Sub InsertNotification(conn As MySqlConnection, uid As Integer, msg As String)
        Dim q As String = "INSERT INTO notifications (UserID, Message) VALUES (@U,@M)"
        Using cmd As New MySqlCommand(q, conn)
            cmd.Parameters.AddWithValue("@U", uid)
            cmd.Parameters.AddWithValue("@M", msg)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Function GetUserName(uid As Integer) As String
        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim q As String = "SELECT CONCAT(FirstName,' ',LastName) FROM register WHERE UserID=@ID"
            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@ID", uid)
                Return CStr(cmd.ExecuteScalar())
            End Using
        End Using
    End Function

    ' Search Button Click
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        Dim keyword As String = txtSearch.Text.Trim()

        LoadUsers(keyword)
    End Sub

    ' Clear Button Click
    Protected Sub btnClear_Click(sender As Object, e As EventArgs)
        txtSearch.Text = ""
        LoadUsers("")
    End Sub

End Class
