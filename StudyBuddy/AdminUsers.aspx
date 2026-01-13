<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdminUsers.aspx.vb" Inherits="StudyBuddy.AdminUsersaspx" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StudyBuddy | User Management</title>
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
            max-width: 1100px;
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

        .admin-card {
            background: #ffffffb4;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
        }

        h2 {
            color: #1c6d5a;
            font-size: 24px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        p {
            color: #666;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 8px;
            margin-top: 10px;
        }

        .user-table th {
            background: #f4f7f6;
            color: #1c6d5a;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #3cbf9a;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
        }

        .user-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .user-table tr:hover td {
            background-color: #f9fffb;
        }

        .role-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            background: #e8f5e9;
            color: #2e7d32;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 6px;
            font-weight: bold;
            font-size: 12px;
            transition: background 0.2s, transform 0.2s;
        }

        .btn-danger:hover {
            background-color: #d32f2f;
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(244, 67, 54, 0.3);
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <div class="nav">
            <a href="AdminDashboard.aspx" title="Home">🏠︎</a>
            <a href="AdminReview.aspx" title="Reviews">🗂</a>
            <a href="AdminChatLogs.aspx" title="Chat Logs">🗫</a>
            <a href="AdminReports.aspx" title="Buddy Board Reports">🚩</a> <a href="AdminUsers.aspx" title="Users">👤</a>
            <a href="Login.aspx" title="Logout">Logout</a>
        </div>

        <div class="admin-card">
            <h2>👥 User Management</h2>
            <p>Monitor and manage account access for Students and Tutors.</p>

            <asp:GridView ID="gvAllUsers" runat="server" AutoGenerateColumns="False" 
                OnRowCommand="gvAllUsers_RowCommand" CssClass="user-table">
                <Columns>
                    <asp:BoundField DataField="UserID" HeaderText="User ID" ItemStyle-Width="100px" />
                    
                    <asp:TemplateField HeaderText="User Profile">
                        <ItemTemplate>
                            <span style="font-weight: 600;"><%# Eval("UserName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Account Role">
                        <ItemTemplate>
                            <span class="role-badge"><%# Eval("Role") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("status") %>' 
                                ForeColor='<%# If(Eval("status").ToString() = "Active", System.Drawing.Color.SeaGreen, System.Drawing.Color.DarkGray) %>'
                                Font-Bold="true" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Moderation">
                        <ItemTemplate>
                            <asp:Button ID="btnBan" runat="server" Text="⛔ Ban Account" 
                                CommandName="BanUser" 
                                CommandArgument='<%# Eval("UserID") %>' 
                                OnClientClick="return confirm('Are you sure that you want to ban this account? This will restrict their login access.');" 
                                CssClass="btn-danger" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>