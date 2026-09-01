<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SalesReturn.aspx.cs" Inherits="project2sedlia.SalesReturn" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>مرتجع المبيعات | نظام الصيدلية</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body, html { height: 100%; width: 100%; background-color: #eef2f5; }
        .wrapper { display: flex; min-height: 100vh; width: 100vw; }

        .sidebar { width: 280px; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%); color: #fff; display: flex; flex-direction: column; box-shadow: -4px 0 15px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 30px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 22px; color: #38bdf8; letter-spacing: 1px; }
        .sidebar-menu { display: flex; flex-direction: column; padding: 20px 0; }
        .sidebar-menu a { color: #cbd5e1; padding: 18px 25px; text-decoration: none; font-size: 16px; display: flex; align-items: center; transition: all 0.3s; border-right: 4px solid transparent; }
        .sidebar-menu a i { margin-left: 15px; font-size: 20px; width: 25px; text-align: center; }
        .sidebar-menu a:hover { background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8; }

        .main-content { flex: 1; display: flex; flex-direction: column; padding: 30px 40px; overflow-y: auto; }
        .page-title { margin-bottom: 25px; color: #334155; font-size: 24px; display: flex; align-items: center; gap: 10px; }

        .search-section { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 20px; display: flex; gap: 15px; align-items: center; }
        .search-section input[type="text"] { width: 250px; padding: 12px 15px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 16px; outline: none; }
        .search-section input[type="text"]:focus { border-color: #38bdf8; }
        .btn-action { background: #2563eb; color: white; border: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-action:hover { background: #1d4ed8; }
        
        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); flex: 1; overflow-y: auto; }
        .custom-grid { width: 100%; border-collapse: collapse; text-align: right; }
        .custom-grid th { background: #f8fafc; padding: 15px; color: #475569; border-bottom: 2px solid #e2e8f0; position: sticky; top: 0; }
        .custom-grid td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; }
        
        .msg-error { color: #ef4444; font-weight: bold; margin-top: 10px; display: block; }
        .msg-success { color: #10b981; font-weight: bold; margin-top: 10px; display: block; }
        
        .return-box { margin-top: 20px; text-align: left; }
        .btn-return { background: #10b981; font-size: 18px; padding: 15px 35px; }
        .btn-return:hover { background: #059669; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            
            <nav class="sidebar">
                <div class="sidebar-header">
                    <h2><i class="fa-solid fa-staff-snake"></i> فارما تك</h2>
                </div>
                <div class="sidebar-menu">
                    <a href="Default.aspx"><i class="fa-solid fa-chart-pie"></i> لوحة التحكم</a>
                    <a href="POS.aspx"><i class="fa-solid fa-cart-shopping"></i> نقطة البيع</a>
                    <a href="SalesReturn.aspx" style="background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8;"><i class="fa-solid fa-rotate-left"></i> مرتجع المبيعات</a>
                    <a href="AddMedicine.aspx"><i class="fa-solid fa-pills"></i> إدارة الأدوية</a>
                    <a href="Inventory.aspx"><i class="fa-solid fa-boxes-stacked"></i> المخزون</a>
                    <a href="Invoices.aspx"><i class="fa-solid fa-file-lines"></i> الفواتير</a>
                    <a href="Reports.aspx"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <main class="main-content">
                <h2 class="page-title"><i class="fa-solid fa-rotate-left"></i> شاشة مرتجع المبيعات</h2>

                <div class="search-section">
                    <label style="font-weight: bold; color: #334155;">رقم الفاتورة الأصلية:</label>
                    <asp:TextBox ID="txtInvoiceID" runat="server" placeholder="أدخل رقم الفاتورة..."></asp:TextBox>
                    <asp:Button ID="btnSearchInvoice" runat="server" Text="بحث عن الفاتورة" CssClass="btn-action" OnClick="btnSearchInvoice_Click" />
                </div>

                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <div class="table-container">
                    <h3 style="margin-bottom: 15px; color: #334155;">أصناف الفاتورة (حدد الكمية المراد إرجاعها)</h3>
                    <asp:GridView ID="gvReturnItems" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="TradeName" HeaderText="اسم الدواء" />
                            <asp:BoundField DataField="Price" HeaderText="السعر" DataFormatString="{0:0.00} ريال" />
                            <asp:BoundField DataField="Qty" HeaderText="الكمية المباعة" />
                            <asp:TemplateField HeaderText="الكمية المراد إرجاعها">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReturnQty" runat="server" Text="0" Width="80px" style="padding: 5px; border: 1px solid #ccc; border-radius: 4px; text-align: center;"></asp:TextBox>
                                    <asp:HiddenField ID="hfBatchID" runat="server" Value='<%# Eval("BatchID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="return-box">
                        <asp:Button ID="btnConfirmReturn" runat="server" Text="تأكيد المرتجع وإعادة الكميات للمخزن" CssClass="btn-action btn-return" OnClick="btnConfirmReturn_Click" Visible="false" />
                    </div>
                </div>
            </main>
        </div>
    </form>
</body>
</html>