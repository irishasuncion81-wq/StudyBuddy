<%@ Page Title="Admin Chat Logs" Language="VB" AutoEventWireup="true" CodeBehind="AdminChatLogs.aspx.vb" Inherits="StudyBuddy.AdminChatLogs" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StudyBuddy | Flagged Chats</title>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('STUDYBUDDY.png');
            background-size: cover;        
            background-position: center;   
            background-attachment: fixed;  
            background-repeat: no-repeat;
            background-size: 600px;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        form {
            max-width: 1200px;
            margin: 0 auto;
        }

        .nav {
            display: flex;
            justify-content: center;
            background: #1c6d5a; 
            padding: 10px;
            border-radius: 50px;
            gap: 40px;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(28, 109, 90, 0.2);
            position: sticky;
            top: 10px;
            z-index: 1000;
        }

        .nav a {
            display: flex; 
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            color: #ffffff;
            text-decoration: none;
            font-size: 20px;
            transition: all 0.3s ease;
        }

        .nav a:hover {
            background: #3cbf9a;
            transform: scale(1.1);
        }

        /* Container Card */
        .admin-container {
            background: #ffffffb4;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
        }

        h2 {
            color: #1c6d5a;
            font-size: 24px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .grid-chat {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 8px;
        }

        .grid-chat th {
            background: #f4f7f6;
            color: #1c6d5a;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #3cbf9a;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
        }

        .grid-chat td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            background-color: #fff;
        }

        .grid-chat tr:hover td {
            background-color: #f9fffb;
        }

        /* Action Buttons Styling */
        .action-container {
            display: flex;
            gap: 8px; 
            flex-wrap: wrap;
        }

        .btn-action {
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 10px;
            transition: all 0.2s;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-lvl1 { background: #ff9800; } 
        .btn-lvl2 { background: #f44336; } 
        .btn-lvl3 { background: #212121; } 

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            opacity: 0.9;
        }

        .flag-reason {
            display: block;
            margin-top: 5px;
            color: #757575;
            font-style: italic;
            font-size: 12px;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="nav">
            <a href="AdminDashboard.aspx" title="Home">🏠︎</a>
            <a href="AdminReview.aspx" title="Reviews">🗂</a>
            <a href="AdminChatLogs.aspx" title="Chat Logs">🗫</a>
            <a href="AdminReports.aspx" title="Buddy Board Reports">🚩</a> <a href="AdminUsers.aspx" title="Users">👤</a>
            <a href="Login.aspx" title="Logout">Logout</a>
        </div>

        <div class="admin-container">
            <h2>⚠️ Flagged Chat Messages</h2>
            
            <asp:GridView ID="gvFlaggedMessages" runat="server" AutoGenerateColumns="False" 
                CssClass="grid-chat" 
                OnRowCommand="gvFlaggedMessages_RowCommand"
                DataKeyNames="MessageID,SenderID">
                
                <Columns>
                    <asp:BoundField DataField="MessageID" HeaderText="ID" ItemStyle-Width="50px" />
                    <asp:BoundField DataField="SenderID" HeaderText="Sender" ItemStyle-Width="80px" />
                    <asp:BoundField DataField="RoomID" HeaderText="Room" ItemStyle-Width="80px" />
                    
                    <asp:TemplateField HeaderText="Message Details">
                        <ItemTemplate>
                            <span style="font-weight: 600; color: #d32f2f;"><%# Eval("Content") %></span>
                            <span class="flag-reason">Reason: <%# Eval("flag_reason") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="TimeStamp" HeaderText="Detected At" 
                        DataFormatString="{0:MMM dd, hh:mm tt}" ItemStyle-Width="150px" />
            
                    <asp:TemplateField HeaderText="Moderation Controls">
                        <ItemTemplate>
                            <div class="action-container">
                                <asp:Button ID="btnWarn1" runat="server" Text="Warn (Swear)" 
                                    CommandName="WarnLvl1" CommandArgument='<%# Container.DataItemIndex %>' 
                                    CssClass="btn-action btn-lvl1" />
                                
                                <asp:Button ID="btnWarn2" runat="server" Text="Ban 3d (Bully)" 
                                    CommandName="WarnLvl2" CommandArgument='<%# Container.DataItemIndex %>' 
                                    CssClass="btn-action btn-lvl2" 
                                    OnClientClick="return confirm('Ban user for 3 days due to bullying?');" />
                                
                                <asp:Button ID="btnWarn3" runat="server" Text="Ban 5d (Harass)" 
                                    CommandName="WarnLvl3" CommandArgument='<%# Container.DataItemIndex %>' 
                                    CssClass="btn-action btn-lvl3" 
                                    OnClientClick="return confirm('Ban user for 5 days due to harassment?');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>