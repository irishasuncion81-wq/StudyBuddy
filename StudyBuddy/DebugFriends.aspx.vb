Imports MySql.Data.MySqlClient
Imports System.Configuration
Imports System.Text

Public Class DebugFriends
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Response.ContentType = "text/plain"

        If Session("UserID") Is Nothing Then
            Response.Write("Session UserID: <null>" & vbCrLf)
            Return
        End If

        Dim meId = Convert.ToInt32(Session("UserID"))
        Response.Write("Session UserID: " & meId & vbCrLf & vbCrLf)

        Dim cs = ConfigurationManager.ConnectionStrings("StudyBuddyDB")
        Dim connStr As String = If(cs IsNot Nothing AndAlso Not String.IsNullOrEmpty(cs.ConnectionString),
                                   cs.ConnectionString,
                                   "server=localhost;user id=root;password=;database=study_buddy")
        Response.Write("Using connection string: " & connStr & vbCrLf & vbCrLf)

        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' Show rows in friends table for this user
            Dim sql As String = "
                SELECT UserID, FriendID, Status, LENGTH(IFNULL(Status,'')) AS LenStatus
                FROM friends
                WHERE UserID = :me OR FriendID = :me
                ORDER BY UserID, FriendID;
            "
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue(":me", meId)
                Using rdr = cmd.ExecuteReader()
                    While rdr.Read()
                        Response.Write(String.Format("friends row -> UserID={0}, FriendID={1}, Status='{2}', Len={3}" & vbCrLf,
                                                     rdr("UserID").ToString(),
                                                     rdr("FriendID").ToString(),
                                                     rdr("Status").ToString(),
                                                     rdr("LenStatus").ToString()))
                    End While
                End Using
            End Using

            Response.Write(vbCrLf & "Rows matching normalized accepted check:" & vbCrLf)
            Dim normSql As String = "
                SELECT
                  CASE WHEN f.UserID = :me THEN f.FriendID ELSE f.UserID END AS FriendUserID,
                  f.Status
                FROM friends f
                WHERE (f.UserID = :me OR f.FriendID = :me)
                  AND LOWER(TRIM(IFNULL(f.Status,''))) = 'accepted';
            "
            Using cmd2 As New MySqlCommand(normSql, conn)
                cmd2.Parameters.AddWithValue(":me", meId)
                Using rdr2 = cmd2.ExecuteReader()
                    If Not rdr2.HasRows Then
                        Response.Write("  <no rows>" & vbCrLf)
                    Else
                        While rdr2.Read()
                            Response.Write(String.Format("  FriendUserID={0}, Status='{1}'" & vbCrLf,
                                                         rdr2("FriendUserID").ToString(),
                                                         rdr2("Status").ToString()))
                        End While
                    End If
                End Using
            End Using
        End Using
    End Sub
End Class