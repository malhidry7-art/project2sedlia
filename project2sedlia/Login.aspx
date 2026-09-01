<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="project2sedlia.Login" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>تسجيل الدخول - نظام الصيدلية</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0px 8px 15px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
        }
        .login-card h2 {
            margin-bottom: 30px;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }
        .btn-login {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(40, 167, 69, 0.3); /* تأثير 3D للزر */
        }
        .btn-login:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        .error-message {
            color: red;
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <h2>تسجيل الدخول</h2>
            
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Placeholder="اسم المستخدم"></asp:TextBox>
            
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="كلمة المرور"></asp:TextBox>
            
            <asp:Button ID="btnLogin" runat="server" Text="دخول" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblError" runat="server" CssClass="error-message"></asp:Label>
        </div>
    </form>
</body>
</html>