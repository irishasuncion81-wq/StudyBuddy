<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="StudyBuddy.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>StudyBuddy Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #dfffe9, #eafaf7);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0; /* Added to prevent scrolling */
        }
        .login {
            background: white;
            border-radius: 15px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
            padding: 40px;
            width: 320px;
            text-align: center;
        }
        .login h1 {
            color: #1c6d5a;
            margin-bottom: 5px;
        }
        .login p {
            color: #4c8f82;
            margin-bottom: 20px;
        }
        .textbox {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border-radius: 8px;
            border: 1px solid #ccc;
            box-sizing: border-box; /* Ensures padding doesn't break width */
        }
        .btn {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            border: none;
            border-radius: 25px;
            background-color: #3cbf9a;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #34a986;
        }
        .links {
            margin-top: 20px;
            font-size: 14px;
            color: #1c6d5a;
        }
        .links a {
            color: #1c6d5a;
            text-decoration: none;
            font-weight: bold;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .separator {
            margin: 0 5px;
            color: #ccc;
        }
        .logo {
            width: 170px;
            height: auto;
            display: block;
            margin: 0 auto 20px;
        }
        .gender-role {
            text-align: left;
            margin: 10px 0;
        }
        label {
            font-weight: bold;
            color: #1c6d5a;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login">
            <img src="STUDYBUDDY.png" alt="StudyBuddy Logo" class="logo" />
            <h1>StudyBuddy</h1>
            <p>Study With Buddy Is Good For Everybody</p>

            <h2>Welcome</h2>

            <asp:TextBox ID="txtUsername" runat="server" CssClass="textbox" Placeholder="Username"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password" Placeholder="Password"></asp:TextBox>

            <asp:Button ID="btnLogin" runat="server" CssClass="btn" Text="Login" OnClick="btnLogin_Click" />

            <div class="links">
                <a href="ForgotPassword.aspx">Forgot Password?</a>
                <span class="separator">|</span>
                <a href="Register.aspx">Create Account</a>
            </div>
        </div>
    </form>
</body>
</html>