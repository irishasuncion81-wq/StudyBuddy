Imports MySql.Data.MySqlClient
Imports System.Configuration

Public Class AcceptRequest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
            Return
        End If

        If Not IsPostBack Then
            Dim requesterIdStr = Request.QueryString("requesterId")
            If String.IsNullOrEmpty(requesterIdStr) Then
                Response.Redirect("Requests.aspx")
                Return
            End If

            Dim requesterId As Integer
            If Not Integer.TryParse(requesterIdStr, requesterId) Then
                Response.Redirect("Requests.aspx")
                Return
            End If

            Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
            Dim ok = AcceptFriend(requesterId, currentUserId)

            If Not ok Then
                Response.Write("Failed to accept friend. Check DB and connection string.")
                Return
            End If

            Response.Redirect("~/Chatroom.aspx", True)
        End If
    End Sub

    Private Function AcceptFriend(requesterId As Integer, currentUserId As Integer) As Boolean
        Dim cs = ConfigurationManager.ConnectionStrings("StudyBuddyDB")
        Dim connStr As String = If(cs IsNot Nothing AndAlso Not String.IsNullOrEmpty(cs.ConnectionString),
                                   cs.ConnectionString,
                                   "server=localhost;user id=root;password=;database=study_buddy")

        Try
            Using conn As New MySqlConnection(connStr)
                conn.Open()

                ' Update any existing row in either direction to canonical accepted
                Dim updateSql As String = "
                    UPDATE friends
                    SET Status = 'accepted'
                    WHERE (UserID = @Requester AND FriendID = @CurrentUser)
                       OR (UserID = @CurrentUser AND FriendID = @Requester)
                "
                Dim totalAffected As Integer = 0
                Using updateCmd As New MySqlCommand(updateSql, conn)
                    updateCmd.Parameters.AddWithValue("@Requester", requesterId)
                    updateCmd.Parameters.AddWithValue("@CurrentUser", currentUserId)
                    totalAffected = updateCmd.ExecuteNonQuery()
                End Using

                If totalAffected = 0 Then
                    ' No existing row — insert canonical row requester -> currentUser
                    Dim insertSql As String = "
                        INSERT INTO friends (UserID, FriendID, Status)
                        VALUES (@Requester, @CurrentUser, 'accepted')
                    "
                    Using insertCmd As New MySqlCommand(insertSql, conn)
                        insertCmd.Parameters.AddWithValue("@Requester", requesterId)
                        insertCmd.Parameters.AddWithValue("@CurrentUser", currentUserId)
                        insertCmd.ExecuteNonQuery()
                        totalAffected += 1
                    End Using
                End If

                ' Ensure reverse row (currentUser -> requester) if present is also accepted
                Dim updateReverse As String = "
                    UPDATE friends
                    SET Status = 'accepted'
                    WHERE UserID = @CurrentUser AND FriendID = @Requester
                "
                Using uCmd As New MySqlCommand(updateReverse, conn)
                    uCmd.Parameters.AddWithValue("@Requester", requesterId)
                    uCmd.Parameters.AddWithValue("@CurrentUser", currentUserId)
                    totalAffected += uCmd.ExecuteNonQuery()
                End Using

                Return totalAffected > 0
            End Using
        Catch ex As Exception
            ' Optional: log ex.Message somewhere; for now return False
            Return False
        End Try
    End Function
End Class