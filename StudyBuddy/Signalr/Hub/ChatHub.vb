Imports Microsoft.AspNet.SignalR

Namespace StudyBuddy
    Public Class ChatHub
        Inherits Hub

        Public Sub SendMessage(roomId As String, senderId As String, receiverId As String, message As String)
            Clients.Group(roomId).receiveMessage(senderId, message)
        End Sub

        Public Sub JoinRoom(roomId As String)
            Groups.Add(Context.ConnectionId, roomId)
        End Sub
    End Class
End Namespace