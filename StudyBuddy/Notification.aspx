<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="Notification.aspx.vb" Inherits="StudyBuddy.Notification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .notification-card {
            width: 95%;
            max-width: 1100px;
            margin: 30px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            overflow: hidden;
        }
        .notification-header {
            background-color: #4b8241;
            color: white;
            padding: 20px;
            margin: 0;
            font-weight: 600;
        }
        .notification-item {
            padding: 20px 25px 20px 55px !important; /* Space para sa red dot */
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
            display: block;
            position: relative;
            text-decoration: none !important;
            color: #333 !important;
        }
        .notification-item:hover {
            background-color: #f8f9fa;
        }

        /* ETO ANG RED DOT LOGIC */
        .notification-item.unread::before {
            content: "";
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            width: 12px;
            height: 12px;
            background-color: #dc3545 !important; /* Pula */
            border-radius: 50%;
            box-shadow: 0 0 8px rgba(220, 53, 69, 0.5);
            z-index: 10;
        }
        .notification-item.unread {
            background-color: #f0f7ff !important; /* Light blue tint */
            font-weight: 500;
        }
        
        .notif-text {
            margin-bottom: 5px;
            font-size: 1.05rem;
        }
        .notif-time {
            font-size: 0.85rem;
            color: #888;
        }
        .no-notif {
            padding: 60px;
            text-align: center;
            color: #adb5bd;
        }
    </style>

    <div class="container-fluid">
        <div class="notification-card">
            <h3 class="notification-header"><i class="fas fa-bell me-2"></i>Notifications</h3>
            
            <asp:Repeater ID="rptNotifications" runat="server" OnItemCommand="rptNotifications_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkNotif" runat="server" 
                        CommandName="Navigate" 
                        CommandArgument='<%# Eval("NotificationID") & "|" & Eval("Message") %>'
                        CssClass='<%# If(Eval("IsRead").ToString() = "0" Or Eval("IsRead").ToString().ToLower() = "false", "notification-item unread", "notification-item") %>'>
                        
                        <p class="notif-text">
                            <%# Eval("Message") %>
                        </p>
                        <span class="notif-time">
                            <i class="far fa-clock"></i> <%# Eval("DateCreated", "{0:MMM dd, yyyy - hh:mm tt}") %>
                        </span>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>

            <asp:PlaceHolder ID="phNoNotif" runat="server" Visible="false">
                <div class="no-notif">
                    <i class="fas fa-bell-slash fa-3x mb-3"></i>
                    <h4>No notifications yet!</h4>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>