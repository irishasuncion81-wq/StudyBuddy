<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdminReports.aspx.vb" Inherits="StudyBuddy.AdminReports" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>StudyBuddy | Reported Content</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('STUDYBUDDY.png');
            background-size: 600px;
            background-position: center;   
            background-attachment: fixed;  
            background-repeat: no-repeat;
            margin: 0;
            padding: 20px;
            color: #333;
            background-color: #f0f4f3;
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
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
            backdrop-filter: blur(5px); 
        }

        h2 {
            color: #1c6d5a;
            font-size: 24px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .report-table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 8px;
            margin-top: 20px;
        }

        .report-table th {
            background: #f4f7f6;
            color: #1c6d5a;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #3cbf9a;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
        }

        .report-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            background-color: #fff;
        }

        .report-table tr:hover td {
            background-color: #f9fffb;
        }

        .btn-action {
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 11px;
            transition: all 0.2s;
            color: white;
            text-transform: uppercase;
        }

        .btn-delete { background: #e53935; margin-right: 5px; }
        .btn-dismiss { background: #757575; }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            opacity: 0.9;
        }

        .post-preview {
            background: #fff9c4; 
            padding: 12px; 
            border-radius: 5px; 
            border-left: 4px solid #fbc02d;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="nav">
            <a href="AdminDashboard.aspx" title="Home">🏠︎</a>
            <a href="AdminReview.aspx" title="Reviews">🗂</a>
            <a href="AdminChatLogs.aspx" title="Chat Logs">🗫</a>
            <a href="AdminReports.aspx" title="Buddy Board Reports">🚩</a>
            <a href="AdminUsers.aspx" title="Users">👤</a>
            <a href="Login.aspx" title="Logout">Logout</a>
        </div>

        <div class="admin-container">
            <h2>🚩 Reported Buddy Board Posts</h2>
            <p style="color: #666; margin-bottom: 25px;">Review posts flagged by the community for moderation.</p>

            <asp:GridView ID="gvReports" runat="server" AutoGenerateColumns="False" 
                CssClass="report-table" OnRowCommand="gvReports_RowCommand">
                <Columns>
                    <asp:BoundField DataField="ReportID" HeaderText="ID" ItemStyle-Width="50px" />
                    
                    <asp:TemplateField HeaderText="Post Content">
                        <ItemTemplate>
                            <div class="post-preview">
                                <strong><%# Eval("Author") %>:</strong><br />
                                <%# Eval("Content") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Reason" HeaderText="Reason" ItemStyle-ForeColor="#e53935" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="ReportedBy" HeaderText="Reported By" />
                    
                    <asp:TemplateField HeaderText="Moderation">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="Delete Post" CommandName="DeletePost" 
                                CommandArgument='<%# Eval("PostID") & "|" & Eval("ReportID") %>' 
                                CssClass="btn-action btn-delete" OnClientClick="return confirm('Permanently delete this post and resolve the report?');" />
                            
                            <asp:Button runat="server" Text="Dismiss" CommandName="DismissReport" 
                                CommandArgument='<%# Eval("ReportID") %>' 
                                CssClass="btn-action btn-dismiss" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>