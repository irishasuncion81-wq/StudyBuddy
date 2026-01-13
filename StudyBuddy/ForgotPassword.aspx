<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ForgotPassword.aspx.vb" Inherits="StudyBuddy.ForgotPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>StudyBuddy - Reset Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #dfffe9, #eafaf7);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .forgot {
            background: white;
            border-radius: 15px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
            padding: 40px;
            width: 350px;
            text-align: center;
        }

        .forgot h2 { color: #1c6d5a; margin-bottom: 10px; }
        .forgot p { color: #4c8f82; font-size: 14px; margin-bottom: 20px; }

        .field {
            position: relative;
            margin-bottom: 15px;
            text-align: left;
        }

        label {
            font-size: 12px;
            font-weight: bold;
            color: #1c6d5a;
            display: block;
            margin-bottom: 5px;
        }

        .textbox {
            width: 100%;
            height: 40px;
            padding: 0 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .btn {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: none;
            border-radius: 25px;
            background-color: #3cbf9a;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover { background-color: #34a986; }

        .eye {
            position: absolute;
            right: 12px;
            top: 32px; /* Adjusted for label */
            cursor: pointer;
            font-size: 18px;
            display: none;
        }

        .eye.hide::after {
            content: "";
            position: absolute;
            top: 9px;
            left: -2px;
            width: 24px;
            height: 2px;
            background: black;
            transform: rotate(-45deg);
        }

        .password-hint {
            font-size: 11px;
            color: #666;
            text-align: left;
            margin-top: 6px;
            line-height: 1.4;
            display: none;
        }

        .links { margin-top: 20px; font-size: 14px; }
        .links a { color: #1c6d5a; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="forgot">
        <h2>Account Recovery</h2>

        <asp:Panel ID="pnlStep1" runat="server">
            <p>Enter your username to begin verification.</p>
            <div class="field">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="textbox" Placeholder="Username" />
            </div>
            <asp:Button ID="btnFindUser" runat="server" CssClass="btn" Text="Next" OnClick="btnFindUser_Click" />
        </asp:Panel>

        <asp:Panel ID="pnlStep2" runat="server" Visible="false">
            <p>Answer your security questions to verify your identity.</p>
        
            <div class="field">
                <label>What is your favorite color?</label>
                <asp:TextBox ID="txtA1" runat="server" CssClass="textbox" Placeholder="Enter your color" />
            </div>

            <div class="field">
                <label>What is your favorite game?</label>
                <asp:TextBox ID="txtA2" runat="server" CssClass="textbox" Placeholder="Enter your game" />
            </div>

            <div class="field">
                <label>What is the name of your pet?</label>
                <asp:TextBox ID="txtA3" runat="server" CssClass="textbox" Placeholder="Enter your pet's name" />
            </div>

            <asp:Button ID="btnVerifyAnswers" runat="server" CssClass="btn" Text="Verify Identity" OnClick="btnVerifyAnswers_Click" />
        </asp:Panel>

        <asp:Panel ID="pnlStep3" runat="server" Visible="false">
            <p>Verification successful. Please enter your new password.</p>
            <div class="field">
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="textbox" TextMode="Password" Placeholder="New Password" />
            </div>
            <div class="field">
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="textbox" TextMode="Password" Placeholder="Confirm New Password" />
            </div>
            <asp:Button ID="btnReset" runat="server" CssClass="btn" Text="Update Password" OnClick="btnReset_Click" />
        </asp:Panel>

        <div class="links">
            <a href="Login.aspx">Back to Login</a>
        </div>
    </div>
</form>

<script>
    function showHintAndEye(input) {
        document.getElementById('passHint').style.display = 'block';
        input.nextElementSibling.style.display = 'block';
    }

    function togglePassword(id, icon) {
        var txt = document.getElementById(id);
        if (txt.type === "password") {
            txt.type = "text";
            icon.classList.add("hide");
        } else {
            txt.type = "password";
            icon.classList.remove("hide");
        }
    }
</script>
</body>
</html>