<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="project2sedlia.AccessDenied" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <title>عذراً - ليس لديك صلاحية</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body, html { height: 100%; width: 100%; background-color: #f3f4f6; }
        .wrapper { display: flex; min-height: 100vh; width: 100vw; }

        /* القائمة الجانبية */
        .sidebar { width: 280px; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%); color: #fff; display: flex; flex-direction: column; box-shadow: -4px 0 15px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 30px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 22px; color: #38bdf8; letter-spacing: 1px; }
        .sidebar-menu { display: flex; flex-direction: column; padding: 20px 0; }
        .sidebar-menu a { color: #cbd5e1; padding: 18px 25px; text-decoration: none; font-size: 16px; display: flex; align-items: center; transition: all 0.3s; border-right: 4px solid transparent; }
        .sidebar-menu a i { margin-left: 15px; font-size: 20px; width: 25px; text-align: center; }
        .sidebar-menu a:hover { background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8; }

        /* المحتوى الرئيسي ووسم توسيط بطاقة الخطأ */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
            overflow-y: auto;
        }

        .card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 450px;
            width: 100%;
        }

        .icon {
            font-size: 60px;
            color: #ef4444;
            margin-bottom: 20px;
        }

        h2 {
            color: #1f2937;
            margin-bottom: 10px;
        }

        p {
            color: #6b7280;
            margin-bottom: 30px;
            font-size: 15px;
        }

        .btn {
            background-color: #2563eb;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s;
        }

        .btn:hover {
            background-color: #1d4ed8;
        }
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
                    <a href="Reports.aspx"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <!-- محتوى صفحة الخطأ -->
            <main class="main-content">
                <div class="card">
                    <div class="icon">🚫</div>
                    <h2>عذراً، الوصول مرفوض!</h2>
                    <p>لا تملك الصلاحية اللازمة لعرض هذه الصفحة. هذه الصفحة مخصصة لمدير النظام (Admin) فقط.</p>
                    <a href="POS.aspx" class="btn">العودة إلى نقطة البيع</a>
                </div>
            </main>

        </div>
    </form>
</body>
</html>