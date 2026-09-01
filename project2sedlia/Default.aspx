<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="project2sedlia.Default" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>لوحة التحكم | نظام الصيدلية الذكي</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body, html { height: 100%; width: 100%; background-color: #eef2f5; }
        .wrapper { display: flex; min-height: 100vh; width: 100vw; }

        .sidebar { width: 280px; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%); color: #fff; display: flex; flex-direction: column; box-shadow: -4px 0 15px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 30px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 22px; color: #38bdf8; letter-spacing: 1px; }
        .sidebar-menu { display: flex; flex-direction: column; padding: 20px 0; overflow-y: auto; }
        .sidebar-menu a { color: #cbd5e1; padding: 16px 25px; text-decoration: none; font-size: 15px; display: flex; align-items: center; transition: 0.3s; border-right: 4px solid transparent; }
        .sidebar-menu a i { margin-left: 15px; font-size: 18px; width: 25px; text-align: center; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8; }

        .main-content { flex: 1; display: flex; flex-direction: column; padding: 30px 40px; overflow-y: auto; }
        
        .top-navbar { background: #ffffff; padding: 20px 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .top-navbar h3 { color: #334155; font-weight: 600; }
        .user-profile { display: flex; align-items: center; color: #475569; font-weight: bold; }
        .user-profile i { font-size: 24px; color: #38bdf8; margin-left: 10px; }

        .dashboard-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .card { background: #ffffff; border-radius: 15px; padding: 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 10px 25px rgba(0,0,0,0.04); position: relative; overflow: hidden; }
        .card::before { content: ''; position: absolute; top: 0; right: 0; width: 5px; height: 100%; }
        .card-sales::before { background-color: #10b981; }
        .card-invoices::before { background-color: #3b82f6; }
        .card-stock::before { background-color: #f59e0b; }
        .card-expired::before { background-color: #ef4444; }

        .card-info h4 { color: #64748b; font-size: 15px; margin-bottom: 10px; font-weight: normal; }
        .card-info .number { font-size: 28px; color: #1e293b; font-weight: bold; }
        .card-icon { font-size: 40px; opacity: 0.2; }
        .card-sales .card-icon { color: #10b981; }
        .card-invoices .card-icon { color: #3b82f6; }
        .card-stock .card-icon { color: #f59e0b; }
        .card-expired .card-icon { color: #ef4444; }

        .quick-actions-panel { background: #ffffff; border-radius: 15px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.04); }
        .quick-actions-panel h3 { color: #334155; margin-bottom: 25px; }
        .action-buttons { display: flex; gap: 15px; flex-wrap: wrap; }
        .btn { padding: 14px 24px; border: none; border-radius: 8px; font-size: 15px; font-weight: bold; color: #fff; cursor: pointer; display: inline-flex; align-items: center; text-decoration: none; transition: 0.3s; }
        .btn i { margin-left: 10px; }
        .btn-pos { background: linear-gradient(135deg, #10b981, #059669); }
        .btn-add { background: linear-gradient(135deg, #3b82f6, #2563eb); }
        .btn-restock { background: linear-gradient(135deg, #f59e0b, #d97706); }
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
                    <a href="Default.aspx" class="active"><i class="fa-solid fa-chart-pie"></i> لوحة التحكم</a>
                    <a href="POS.aspx"><i class="fa-solid fa-cart-shopping"></i> نقطة البيع</a>
                    <a href="AddMedicine.aspx"><i class="fa-solid fa-pills"></i> إدارة الأدوية</a>
                    <a href="Inventory.aspx"><i class="fa-solid fa-boxes-stacked"></i> المخزون</a>
                    <a href="Restock.aspx"><i class="fa-solid fa-boxes-packing"></i> توريد شحنة جديدة</a>
                    <a href="Reports.aspx"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <main class="main-content">
                
                <header class="top-navbar">
                    <h3>نظرة عامة على النظام</h3>
                    <div class="user-profile">
                        <asp:Label ID="lblUserName" runat="server" Text="المستخدم"></asp:Label>
                        <i class="fa-solid fa-circle-user"></i>
                    </div>
                </header>

                <!-- البطاقات الإحصائية التفاعلية -->
                <div class="dashboard-cards">
                    
                    <div class="card card-sales">
                        <div class="card-info">
                            <h4>إجمالي مبيعات اليوم</h4>
                            <div class="number"><asp:Label ID="lblDailySales" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <i class="fa-solid fa-money-bill-wave card-icon"></i>
                    </div>

                    <a href="Reports.aspx" style="text-decoration: none; color: inherit;">
                        <div class="card card-invoices" style="cursor: pointer; transition: 0.3s;" title="انقر لعرض سجل الفواتير الكامل">
                            <div class="card-info">
                                <h4>الفواتير المنجزة</h4>
                                <div class="number"><asp:Label ID="lblInvoicesCount" runat="server" Text="0"></asp:Label></div>
                            </div>
                            <i class="fa-solid fa-receipt card-icon"></i>
                        </div>
                    </a>

                    <a href="Inventory.aspx" style="text-decoration: none; color: inherit;">
                        <div class="card card-stock" style="cursor: pointer; transition: 0.3s;" title="انقر لعرض المخزون وتفاصيل النواقص">
                            <div class="card-info">
                                <h4>نواقص المخزون</h4>
                                <div class="number"><asp:Label ID="lblLowStock" runat="server" Text="0"></asp:Label></div>
                            </div>
                            <i class="fa-solid fa-box-open card-icon"></i>
                        </div>
                    </a>

                    <a href="Inventory.aspx" style="text-decoration: none; color: inherit;">
                        <div class="card card-expired" style="cursor: pointer; transition: 0.3s;" title="انقر لمراجعة تواريخ صلاحية الأدوية">
                            <div class="card-info">
                                <h4>أدوية قاربت على الانتهاء</h4>
                                <div class="number"><asp:Label ID="lblExpired" runat="server" Text="0"></asp:Label></div>
                            </div>
                            <i class="fa-solid fa-triangle-exclamation card-icon"></i>
                        </div>
                    </a>

                </div>

                <!-- الإجراءات السريعة -->
                <div class="quick-actions-panel">
                    <h3>إجراءات سريعة</h3>
                    <div class="action-buttons">
                        <asp:Button ID="btnGoToPOS" runat="server" Text="فتح شاشة الكاشير" CssClass="btn btn-pos" OnClick="btnGoToPOS_Click" />
                        <asp:Button ID="btnAddMed" runat="server" Text="إضافة دواء جديد" CssClass="btn btn-add" OnClick="btnAddMed_Click" />
                        <a href="Restock.aspx" class="btn btn-restock">توريد شحنة جديدة <i class="fa-solid fa-boxes-packing"></i></a>
                    </div>
                </div>

            </main>
        </div>
    </form>
</body>
</html>