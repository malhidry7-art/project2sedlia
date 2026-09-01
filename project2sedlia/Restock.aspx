<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Restock.aspx.cs" Inherits="project2sedlia.Restock" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>توريد شحنة جديدة | نظام الصيدلية</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: #eef2f5; height: 100vh; display: flex; flex-direction: column; }
        .top-bar { background: #1e293b; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .top-bar a { color: #38bdf8; text-decoration: none; font-weight: bold; }
        .form-container { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px; }
        .form-card { background: white; width: 100%; max-width: 600px; border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        .form-group { display: flex; flex-direction: column; margin-bottom: 20px; }
        .form-group label { margin-bottom: 8px; color: #475569; font-weight: bold; }
        .form-control { padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 16px; outline: none; }
        .btn-save { background: #10b981; color: white; border: none; padding: 15px; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer; width: 100%; margin-top: 10px; }
        .btn-save:hover { background: #059669; }
        .msg { display: block; text-align: center; margin-top: 15px; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top-bar">
            <h2><i class="fa-solid fa-boxes-packing"></i> توريد كمية لدواء موجود</h2>
            <a href="Default.aspx"><i class="fa-solid fa-arrow-right"></i> العودة للوحة التحكم</a>
        </div>

        <div class="form-container">
            <div class="form-card">
                <div class="form-group">
                    <label>اختر الدواء</label>
                    <asp:DropDownList ID="ddlMedicines" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>الكمية المضافة</label>
                    <asp:TextBox ID="txtAddQty" runat="server" CssClass="form-control" TextMode="Number" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>تاريخ الصلاحية للشحنة الجديدة</label>
                    <asp:TextBox ID="txtNewExpiry" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>سعر الشراء الجديد</label>
                    <asp:TextBox ID="txtNewPurchase" runat="server" CssClass="form-control" TextMode="Number" step="0.01" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>سعر البيع</label>
                    <asp:TextBox ID="txtNewSell" runat="server" CssClass="form-control" TextMode="Number" step="0.01" required="true"></asp:TextBox>
                </div>

                <asp:Button ID="btnRestock" runat="server" Text="إضافة الشحنة للمخزون" CssClass="btn-save" OnClick="btnRestock_Click" />
                <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>