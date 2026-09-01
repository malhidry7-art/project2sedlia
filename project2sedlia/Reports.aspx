<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="project2sedlia.Reports" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>تقارير النظام | نظام الصيدلية</title>
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

        .stats-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .stats-info h3 { font-size: 16px; color: #64748b; margin-bottom: 8px; }
        .stats-info .number { font-size: 28px; font-weight: bold; color: #10b981; }

        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 30px; }
        .section-title { font-size: 18px; color: #334155; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
        .custom-grid { width: 100%; border-collapse: collapse; text-align: right; }
        .custom-grid th { background: #f8fafc; padding: 15px; color: #475569; border-bottom: 2px solid #e2e8f0; }
        .custom-grid td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; }
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
                    <a href="SalesReturn.aspx"><i class="fa-solid fa-rotate-left"></i> مرتجع المبيعات</a>
                    <a href="AddMedicine.aspx"><i class="fa-solid fa-pills"></i> إدارة الأدوية</a>
                    <a href="Inventory.aspx"><i class="fa-solid fa-boxes-stacked"></i> المخزون</a>
                    <a href="Invoices.aspx"><i class="fa-solid fa-file-lines"></i> الفواتير</a>
                    <a href="Reports.aspx" style="background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8;"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <main class="main-content">
                <h2 class="page-title"><i class="fa-solid fa-file-invoice-dollar"></i> تقارير مبيعات ومرتجعات النظام</h2>

                <!-- إجمالي مبيعات النظام -->
                <div class="stats-card">
                    <div class="stats-info">
                        <h3>إجمالي مبيعات النظام الكلية</h3>
                        <div class="number"><asp:Label ID="lblTotalSales" runat="server" Text="0.00"></asp:Label> ريال</div>
                    </div>
                    <i class="fa-solid fa-chart-line" style="font-size: 40px; color: #10b981; opacity: 0.3;"></i>
                </div>

                <!-- جدول سجل الفواتير -->
                <div class="table-container">
                    <h3 class="section-title"><i class="fa-solid fa-list"></i> سجل الفواتير المسجلة</h3>
                    <asp:GridView ID="gvInvoices" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="InvoiceID" HeaderText="رقم الفاتورة" />
                            <asp:BoundField DataField="FullName" HeaderText="الكاشير المسؤول" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="إجمالي المبلغ" DataFormatString="{0:0.00} ريال" />
                            <asp:BoundField DataField="InvoiceDate" HeaderText="تاريخ ووقت الفاتورة" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- جدول سجل المرتجعات المسجلة (مع تفاصيل الدواء) -->
                <div class="table-container">
                    <h3 class="section-title" style="color: #ef4444;"><i class="fa-solid fa-rotate-left"></i> سجل المرتجعات المسجلة</h3>
                    <asp:GridView ID="gvReturns" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="ReturnID" HeaderText="رقم المرتجع" />
                            <asp:BoundField DataField="InvoiceID" HeaderText="رقم الفاتورة الأصلية" />
                            <asp:BoundField DataField="TradeName" HeaderText="اسم الدواء المرتجع" />
                            <asp:BoundField DataField="ReturnQty" HeaderText="الكمية المرتجعة" />
                            <asp:BoundField DataField="FullName" HeaderText="الكاشير المسؤول" />
                            <asp:BoundField DataField="TotalRefund" HeaderText="المبلغ المردود" DataFormatString="{0:0.00} ريال" />
                            <asp:BoundField DataField="ReturnDate" HeaderText="تاريخ ووقت المرتجع" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        </Columns>
                    </asp:GridView>
                </div>

            </main>
        </div>
    </form>
</body>
</html>