<%@ Page Title="Admin Review" Language="VB" AutoEventWireup="true" CodeBehind="AdminReview.aspx.vb" Inherits="StudyBuddy.AdminReview" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StudyBuddy | Review Approvals</title>

    <style>
        /* Modern Base Styles (Consistent with Dashboard) */
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

        /* Pill Navigation Bar */
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

        /* Main Container Card */
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
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Modern Gridview Styling */
        .grid {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 8px;
            margin-top: 10px;
        }

        .grid th {
            background: #f4f7f6;
            color: #1c6d5a;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #3cbf9a;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
        }

        .grid td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .grid tr:hover td {
            background-color: #f9fffb;
        }

        /* Action Links and Buttons */
        .view-link {
            color: #1c6d5a;
            font-weight: bold;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .view-link:hover {
            color: #3cbf9a;
            text-decoration: underline;
        }

        .btn-action {
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 12px;
            transition: all 0.2s;
            color: white;
        }

        .btn-approve {
            background: #43a047;
        }

        .btn-approve:hover {
            background: #2e7d32;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 160, 71, 0.3);
        }

        .btn-reject {
            background: #e53935; 
        }

        .btn-reject:hover {
            background: #c62828;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(229, 57, 53, 0.3);
        }

        .upload-status {
            margin-top: 20px;
            display: block;
            font-weight: 600;
            color: #1c6d5a;
            padding: 10px;
            background: #e8f5e9;
            border-radius: 6px;
            text-align: center;
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

        <div class="admin-card">
            <h2>📂 Pending Reviewer Approvals</h2>
            
            <asp:GridView
                ID="gvPending"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="grid"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="filename" HeaderText="File Name" />
                    <asp:BoundField DataField="uploaded_by" HeaderText="Uploader" />
                    <asp:BoundField DataField="upload_date"
                        HeaderText="Date Uploaded"
                        DataFormatString="{0:MMM dd, yyyy}" />

                    <asp:TemplateField HeaderText="Preview">
                        <ItemTemplate>
                            <asp:HyperLink
                                runat="server"
                                CssClass="view-link"
                                NavigateUrl='<%# "~/Uploads/" & Eval("filename") %>'
                                Text="👁 View File"
                                Target="_blank" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <div style="display: flex; gap: 8px;">
                                <asp:Button
                                    ID="btnApprove"
                                    runat="server"
                                    CssClass="btn-action btn-approve"
                                    Text="Approve"
                                    CommandArgument='<%# Eval("id") %>'
                                    OnClick="btnApprove_Click" />

                                <asp:Button
                                    ID="btnReject"
                                    runat="server"
                                    CssClass="btn-action btn-reject"
                                    Text="Reject"
                                    CommandArgument='<%# Eval("id") %>'
                                    OnClick="btnReject_Click" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

            <asp:Label ID="lblStatus" runat="server" CssClass="upload-status" Visible="false" />
        </div>

    </form>
</body>
</html>