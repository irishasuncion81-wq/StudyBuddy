<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="AdminDashboard.aspx.vb" Inherits="StudyBuddy.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StudyBuddy | Admin Dashboard</title>

    <style>
        /* Modern Reset and Base Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('bg1.jpg');
            margin: 0;
            padding: 20px;
            color: #333;
        }

        /* Container for the whole dashboard */
        form {
            max-width: 1100px;
            margin: 0 auto;
        }

        h2 {
            color: #1c6d5a;
            font-size: 22px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Navigation Bar - Floating Style */
        .nav {
            display: flex;
            justify-content: center;
            background: #1c6d5a; /* Deep StudyBuddy Green */
            padding: 10px;
            border-radius: 50px; /* Pill shape */
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
            background: #3cbf9a; /* Bright Green highlight */
            transform: scale(1.1);
        }

        /* Panels - Card Style */
        .panel {
            background: #ffffff;
            padding: 25px;
            margin-bottom: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
        }

        /* Gridview / Table Styling */
        .grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            overflow: hidden;
            border-radius: 8px;
        }

        .grid th {
            background: #f4f7f6;
            color: #1c6d5a;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #3cbf9a;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
        }

        .grid td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .grid tr:last-child td {
            border-bottom: none;
        }

        .grid tr:hover {
            background-color: #f9fffb;
        }

        /* Stats Cards Section */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .card {
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            border-left: 5px solid #3cbf9a;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card span { /* For the numbers (Labels) */
            display: block;
            font-size: 28px;
            color: #1c6d5a;
            font-weight: bold;
            margin-top: 5px;
        }

        /* Status Colors */
        .status-pill {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
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

        <h2 style="margin-bottom: 30px;">
            Welcome back, 
            <asp:Label ID="lblAdminName" runat="server" Text="Admin" ForeColor="#3cbf9a"></asp:Label> 
            🎓
        </h2>

        <div class="panel">
            <h2>📊 Dashboard Overview</h2>
            <div class="stats">
                <div class="card">
                    Pending Resources
                    <asp:Label ID="lblPendingCount" runat="server" Text="0" />
                </div>
                <div class="card" style="border-left-color: #facc15;">
                    Flagged Chats
                    <asp:Label ID="lblChatCount" runat="server" Text="0" />
                </div>

                <div class="card" style="border-left-color: #e53935;">
                    Buddy Board Reports
                    <asp:Label ID="lblReportCount" runat="server" Text="0" />
                </div>
                <div class="card" style="border-left-color: #3b82f6;">
                    Active Users Today
                    <asp:Label ID="lblActiveUsers" runat="server" Text="0" />
                </div>
            </div>
        </div>

        <div class="panel">
            <h2>📂 Latest Uploads</h2>
            <asp:GridView
                ID="gvResources"
                runat="server"
                AutoGenerateColumns="False" 
                CssClass="grid">
                <Columns>
                    <asp:BoundField DataField="filename" HeaderText="File Name" />
                    <asp:BoundField DataField="uploaded_by" HeaderText="User" />
                    <asp:BoundField DataField="upload_date" HeaderText="Upload Date" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:TemplateField HeaderText="Current Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" 
                                Text='<%# If(CInt(Eval("is_approved")) = 1, "✅ Approved", "⏳ Pending") %>'
                                Font-Bold="true"
                                ForeColor='<%# If(CInt(Eval("is_approved")) = 1, Drawing.Color.SeaGreen, Drawing.Color.DarkOrange) %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="panel">
            <h2>⚠️ Flagged Chat Messages</h2>
            <asp:GridView
                ID="gvChats"
                runat="server"
                AutoGenerateColumns="True"
                CssClass="grid" />
        </div>

        <div class="panel">
            <h2>🚩 Reported Buddy Board Posts</h2>
            <asp:GridView 
                ID="gvReportedPosts" 
                runat="server" 
                AutoGenerateColumns="False" 
                CssClass="grid">
                <Columns>
                    <asp:BoundField DataField="Author" HeaderText="Author" />
                    <asp:BoundField DataField="Content" HeaderText="Post Content" />
                    <asp:BoundField DataField="Reason" HeaderText="Reason" ItemStyle-ForeColor="Red" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="panel">
            <h2>👥 User Management Quick View</h2>
            <asp:GridView
                ID="gvUsers"
                runat="server"
                AutoGenerateColumns="True"
                CssClass="grid" />
        </div>

    </form>
</body>
</html>