<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Invoices.aspx.cs" Inherits="project2sedlia.Invoices" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>سجل الفواتير | نظام الصيدلية الذكي</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body, html { height: 100%; width: 100%; background-color: #eef2f5; }
        .wrapper { display: flex; min-height: 100vh; width: 100vw; }

        /* القائمة الجانبية الموحدة */
        .sidebar { width: 280px; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%); color: #fff; display: flex; flex-direction: column; box-shadow: -4px 0 15px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 30px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 22px; color: #38bdf8; letter-spacing: 1px; }
        .sidebar-menu { display: flex; flex-direction: column; padding: 20px 0; }
        .sidebar-menu a { color: #cbd5e1; padding: 18px 25px; text-decoration: none; font-size: 16px; display: flex; align-items: center; transition: all 0.3s; border-right: 4px solid transparent; }
        .sidebar-menu a i { margin-left: 15px; font-size: 20px; width: 25px; text-align: center; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8; }

        /* المحتوى الرئيسي */
        .main-content { flex: 1; display: flex; flex-direction: column; padding: 30px 40px; overflow-y: auto; }
        
        .page-title { margin-bottom: 25px; color: #334155; font-size: 24px; display: flex; align-items: center; gap: 10px; }

        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); flex: 1; overflow-y: auto; }
        .custom-grid { width: 100%; border-collapse: collapse; text-align: right; }
        .custom-grid th { background: #f8fafc; padding: 15px; color: #475569; border-bottom: 2px solid #e2e8f0; position: sticky; top: 0; }
        .custom-grid td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; }
        .custom-grid tr:hover { background-color: #f8fafc; }
        
        .btn-details { background-color: #3b82f6; color: white; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 14px; transition: 0.3s; display: inline-block; }
        .btn-details:hover { background-color: #2563eb; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            
            <!-- القائمة الجانبية -->
            <nav class="sidebar">
                <div class="sidebar-header">
                    <h2><i class="fa-solid fa-staff-snake"></i> فارما تك</h2>
                </div>
                <div class="sidebar-menu">
                    <a href="Default.aspx"><i class="fa-solid fa-chart-pie"></i> لوحة التحكم</a>
                    <a href="POS.aspx"><i class="fa-solid fa-cart-shopping"></i> نقطة البيع</a>
                    <a href="AddMedicine.aspx"><i class="fa-solid fa-pills"></i> إدارة الأدوية</a>
                    <a href="Inventory.aspx"><i class="fa-solid fa-boxes-stacked"></i> المخزون</a>
                    <a href="Invoices.aspx" class="active"><i class="fa-solid fa-file-lines"></i> الفواتير</a>
                    <a href="Reports.aspx"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <!-- محتوى الصفحة -->
            <main class="main-content">
                <h2 class="page-title"><i class="fa-solid fa-file-lines"></i> إدارة وعرض الفواتير السابقة</h2>

                <div class="table-container">
                    <h3 style="margin-bottom: 15px; color: #334155;">قائمة الفواتير الصادرة</h3>
                    <asp:GridView ID="gvInvoices" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" EmptyDataText="لا توجد فواتير مسجلة حالياً.">
                        <Columns>
                            <asp:BoundField DataField="InvoiceID" HeaderText="رقم الفاتورة" />
                            <asp:BoundField DataField="FullName" HeaderText="الكاشير المسؤول" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="إجمالي المبلغ" DataFormatString="{0:0.00} ريال" />
                            <asp:BoundField DataField="InvoiceDate" HeaderText="وقت الإصدار" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:TemplateField HeaderText="الإجراءات">
                                <ItemTemplate>
                                    <a href='<%# "InvoiceDetails.aspx?id=" + Eval("InvoiceID") %>' class="btn-details">
                                        <i class="fa-solid fa-eye"></i> التفاصيل
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </main>
        </div>
    </form>
</body>
</html>