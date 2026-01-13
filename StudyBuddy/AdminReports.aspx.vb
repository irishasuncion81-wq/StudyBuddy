Imports MySql.Data.MySqlClient
Imports System.Data

Public Class AdminReports
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then LoadReports()
    End Sub

    Private Sub LoadReports()
        Using conn As New MySqlConnection(connStr)
            ' Join query para makuha ang content ng post at detalye ng report
            Dim query As String = "SELECT r.ReportID, r.PostID, p.Content, p.UserName AS Author, r.Reason, r.ReportedBy " &
                                 "FROM post_reports r JOIN buddy_board p ON r.PostID = p.PostID " &
                                 "WHERE r.Status = 'Pending' ORDER BY r.ReportDate DESC"
            Dim cmd As New MySqlCommand(query, conn)
            Dim dt As New DataTable()
            conn.Open()
            dt.Load(cmd.ExecuteReader())
            gvReports.DataSource = dt
            gvReports.DataBind()
        End Using
    End Sub

    Protected Sub gvReports_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim arg As String = e.CommandArgument.ToString()

        Using conn As New MySqlConnection(connStr)
            conn.Open()
            If e.CommandName = "DeletePost" Then
                Dim ids As String() = arg.Split("|"c)
                Dim postId As String = ids(0)
                Dim reportId As String = ids(1)

                ' Burahin ung post sa main board
                Dim cmdPost As New MySqlCommand("DELETE FROM buddy_board WHERE PostID = @pid", conn)
                cmdPost.Parameters.AddWithValue("@pid", postId)
                cmdPost.ExecuteNonQuery()

                ' I-mark ang report as Reviewed/Resolved
                Dim cmdRep As New MySqlCommand("UPDATE post_reports SET Status = 'Resolved' WHERE ReportID = @rid", conn)
                cmdRep.Parameters.AddWithValue("@rid", reportId)
                cmdRep.ExecuteNonQuery()

            ElseIf e.CommandName = "DismissReport" Then
                Dim reportId As String = arg
                Dim cmdDismiss As New MySqlCommand("UPDATE post_reports SET Status = 'Dismissed' WHERE ReportID = @rid", conn)
                cmdDismiss.Parameters.AddWithValue("@rid", reportId)
                cmdDismiss.ExecuteNonQuery()
            End If
        End Using

        LoadReports()
    End Sub
End Class