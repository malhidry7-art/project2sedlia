<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddMedicine.aspx.cs" Inherits="project2sedlia.AddMedicine" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>إضافة دواء جديد | نظام الصيدلية</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: #eef2f5; height: 100vh; display: flex; overflow: hidden; }
        
        /* القائمة الجانبية الجديدة */
        .pharmacy-sidebar {
            width: 260px;
            background-color: #1e293b;
            color: #fff;
            height: 100vh;
            position: fixed;
            top: 0;
            right: 0;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            background-color: #0f172a;
            border-bottom: 1px solid #334155;
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 18px;
            color: #38bdf8;
        }

        .menu-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-list li a {
            display: block;
            padding: 12px 20px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 15px;
            transition: all 0.3s ease;
            border-bottom: 1px solid rgba(255,255,255,0.03);
        }

        .menu-list li a:hover {
            background-color: #334155;
            color: #ffffff;
            padding-right: 25px;
        }

        .sub-menu {
            list-style: none;
            padding: 0;
            margin: 0;
            background-color: #0f172a;
            display: none;
        }

        .menu-list li.dropdown:hover .sub-menu {
            display: block;
        }

        .sub-menu li a {
            padding: 10px 35px;
            font-size: 13px;
            color: #94a3b8;
        }

        .sub-menu li a:hover {
            color: #38bdf8;
            background-color: #1e293b;
        }

        /* حاوية المحتوى الرئيسي لكي لا تختفي تحت القائمة الجانبية */
        .main-content {
            margin-right: 260px;
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
        }

        /* الشريط العلوي */
        .top-bar { background: #1e293b; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .top-bar a { color: #38bdf8; text-decoration: none; font-weight: bold; font-size: 16px; transition: 0.3s; }
        .top-bar a:hover { color: #fff; }

        /* حاوية النموذج */
        .form-container { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px; }
        .form-card { background: white; width: 100%; max-width: 800px; border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        .form-header { margin-bottom: 30px; color: #1e293b; border-bottom: 2px solid #f1f5f9; padding-bottom: 15px; }
        
        /* شبكة الإدخال */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full-width { grid-column: span 2; }
        
        .form-group label { margin-bottom: 8px; color: #475569; font-weight: bold; font-size: 14px; }
        .form-control { padding: 12px 15px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 16px; outline: none; transition: 0.3s; }
        .form-control:focus { border-color: #38bdf8; box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.1); }

        /* الأزرار والرسائل */
        .btn-save { background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; padding: 15px; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer; width: 100%; margin-top: 30px; transition: 0.3s; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3); }
        .msg { display: block; text-align: center; margin-top: 20px; font-weight: bold; font-size: 16px; }
        .msg.success { color: #10b981; }
        .msg.error { color: #ef4444; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- القائمة الجانبية المرتبة بالأيقونات -->
        <div class="pharmacy-sidebar">
            <div class="sidebar-header">
                <h3>صيدلية الباش مهندس</h3>
            </div>
            <ul class="menu-list">
                <li><a href="Default.aspx"><i class="fa-solid fa-house"></i> لوحة التحكم</a></li>
                
                <!-- المبيعات -->
                <li class="dropdown">
                    <a href="#"><i class="fa-solid fa-cart-shopping"></i> المبيعات ▾</a>
                    <ul class="sub-menu">
                        <li><a href="POS.aspx">بيع جديد</a></li>
                        <li><a href="Invoices.aspx">الفواتير</a></li>
                    </ul>
                </li>

                <!-- الأدوية -->
                <li class="dropdown">
                    <a href="#"><i class="fa-solid fa-pills"></i> الأدوية ▾</a>
                    <ul class="sub-menu">
                        <li><a href="AddMedicine.aspx">إضافة دواء</a></li>
                        <li><a href="Categories.aspx">التصنيفات</a></li>
                    </ul>
                </li>

                <!-- التقارير -->
                <li><a href="Reports.aspx"><i class="fa-solid fa-chart-pie"></i> التقارير المالية</a></li>

                <!-- تسجيل الخروج -->
                <li><a href="Login.aspx"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a></li>
            </ul>
        </div>

        <!-- المحتوى الرئيسي -->
        <div class="main-content">
            <div class="top-bar">
                <h2><i class="fa-solid fa-pills"></i> إضافة دواء جديد للمخزون</h2>
                <a href="Default.aspx"><i class="fa-solid fa-arrow-right"></i> العودة للوحة التحكم</a>
            </div>

            <div class="form-container">
                <div class="form-card">
                    <h3 class="form-header">البيانات الأساسية وتفاصيل الشحنة الأولى</h3>
                    
                    <div class="form-grid">
                        <!-- بيانات الدواء الأساسية -->
                        <div class="form-group">
                            <label>الباركود (Barcode)</label>
                            <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control" placeholder="امسح الباركود أو اكتبه يدوياً" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>التصنيف الطبي</label>
                            <asp:DropDownList ID="ddlCategories" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        <div class="form-group full-width">
                            <label>الاسم التجاري للدواء</label>
                            <asp:TextBox ID="txtTradeName" runat="server" CssClass="form-control" placeholder="مثال: Panadol Advance 500mg" required="true"></asp:TextBox>
                        </div>

                        <!-- تفاصيل الشحنة والمخزون -->
                        <div class="form-group">
                            <label>الكمية المدخلة</label>
                            <asp:TextBox ID="txtQty" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>تاريخ الصلاحية (Expiry Date)</label>
                            <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control" placeholder="YYYY-MM-DD" required="true" dir="ltr" style="text-align: left;"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>سعر الشراء (ريال)</label>
                            <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>سعر البيع (ريال)</label>
                            <asp:TextBox ID="txtSellPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" required="true"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnSave" runat="server" Text="حفظ الدواء في قاعدة البيانات" CssClass="btn-save" OnClick="btnSave_Click" />
                    <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>
                </div>
            </div>
        </div>
       
    </form>
</body>
</html>