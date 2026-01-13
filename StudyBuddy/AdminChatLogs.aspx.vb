Imports MySql.Data.MySqlClient
Imports System.Configuration
Imports System.Data

Public Class AdminChatLogs
    Inherits System.Web.UI.Page

    Private connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindFlaggedMessages()
        End If
    End Sub

    Private Sub BindFlaggedMessages()
        Dim query As String = "SELECT MessageID, SenderID, RoomID, Content, TimeStamp, flag_reason " &
                         "FROM messages WHERE is_flagged = 1 ORDER BY TimeStamp DESC"

        Using conn As New MySqlConnection(connStr)
            Using cmd As New MySqlCommand(query, conn)
                Try
                    Dim dt As New DataTable()
                    Dim adapter As New MySqlDataAdapter(cmd)
                    adapter.Fill(dt)

                    gvFlaggedMessages.DataSource = dt
                    gvFlaggedMessages.DataBind()
                Catch ex As Exception
                    Response.Write("Error: " & ex.Message)
                End Try
            End Using
        End Using
    End Sub

    Protected Sub gvFlaggedMessages_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim senderID As Integer = Convert.ToInt32(gvFlaggedMessages.DataKeys(index).Values("SenderID"))
        Dim messageID As Integer = Convert.ToInt32(gvFlaggedMessages.DataKeys(index).Values("MessageID"))

        Select Case e.CommandName
            Case "WarnLvl1"
                ProcessPenalty(senderID, 1, "Warning #1: Unintentional bad language. 3 strikes = 24h ban.")
            Case "WarnLvl2"
                ProcessPenalty(senderID, 2, "Warning #2: Bullying detected. 3 days ban applied.")
            Case "WarnLvl3"
                ProcessPenalty(senderID, 3, "Warning #3: Harassment detected. 5 days ban applied.")
        End Select

        UnflagMessage(messageID)
        BindFlaggedMessages()
    End Sub

    Private Sub ProcessPenalty(userID As Integer, level As Integer, adminNote As String)
        Using conn As New MySqlConnection(connStr)
            conn.Open()

            If level = 1 Then
                ' Dagdagan ang warning count ng user
                Dim updateCountSql As String = "UPDATE register SET warning_count = warning_count + 1 WHERE UserID = @UID"
                Using cmdCount As New MySqlCommand(updateCountSql, conn)
                    cmdCount.Parameters.AddWithValue("@UID", userID)
                    cmdCount.ExecuteNonQuery()
                End Using

                ' I-check kung pang-3rd strike na 
                Dim checkCountSql As String = "SELECT warning_count FROM register WHERE UserID = @UID"
                Dim currentStrikes As Integer = 0
                Using cmdCheck As New MySqlCommand(checkCountSql, conn)
                    cmdCheck.Parameters.AddWithValue("@UID", userID)
                    currentStrikes = Convert.ToInt32(cmdCheck.ExecuteScalar())
                End Using

                ' If 3 strikes , apply 24-hour ban and reset count
                If currentStrikes >= 3 Then
                    adminNote = "Warning #1 (Strike 3): Automatic 24-hour chat restriction applied."
                    Dim banSql As String = "UPDATE register SET ban_until = DATE_ADD(NOW(), INTERVAL 1 DAY), warning_count = 0 WHERE UserID = @UID"
                    Using cmdBan As New MySqlCommand(banSql, conn)
                        cmdBan.Parameters.AddWithValue("@UID", userID)
                        cmdBan.ExecuteNonQuery()
                    End Using
                Else
                    adminNote = $"Warning #1: Please avoid bad language. (Strike {currentStrikes}/3)"
                End If

            ElseIf level = 2 Then
                ' Level 2: Bullying - 3 Days Ban
                Dim sqlLvl2 As String = "UPDATE register SET ban_until = DATE_ADD(NOW(), INTERVAL 3 DAY) WHERE UserID = @UID"
                Using cmd As New MySqlCommand(sqlLvl2, conn)
                    cmd.Parameters.AddWithValue("@UID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            End If

            ' Mag-insert ng notification para alam ng user kung bakit sila blocked
            Dim notifySql As String = "INSERT INTO notifications (UserID, Message, IsRead) VALUES (@UID, @Msg, 0)"
            Using cmdNotify As New MySqlCommand(notifySql, conn)
                cmdNotify.Parameters.AddWithValue("@UID", userID)
                cmdNotify.Parameters.AddWithValue("@Msg", adminNote)
                cmdNotify.ExecuteNonQuery()
            End Using
        End Using

        ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('{adminNote}');", True)
    End Sub

    Private Sub UnflagMessage(msgID As Integer)
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "UPDATE messages SET is_flagged = 0 WHERE MessageID = @MID"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@MID", msgID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

End Class