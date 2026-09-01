<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POS.aspx.cs" Inherits="project2sedlia.POS" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>نقطة البيع | نظام الصيدلية</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: #eef2f5; height: 100vh; display: flex; overflow: hidden; }
        
        /* القائمة الجانبية الموحدة */
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
            overflow: hidden;
        }

        /* الشريط العلوي */
        .top-bar { background: #1e293b; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .top-bar a { color: #38bdf8; text-decoration: none; font-weight: bold; font-size: 16px; }
        .top-bar a:hover { color: #fff; }

        /* منطقة العمل الرئيسية */
        .pos-container { display: flex; flex: 1; padding: 20px; gap: 20px; height: calc(100vh - 60px); overflow: hidden; }

        /* القسم الأيمن: الفاتورة والباركود */
        .invoice-section { flex: 7; background: white; border-radius: 12px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        .search-box { display: flex; gap: 15px; margin-bottom: 20px; }
        .search-box input[type="text"], .search-box input[type="number"] { padding: 15px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 18px; outline: none; transition: 0.3s; }
        .search-box input[type="text"] { flex: 1; }
        .search-box input[type="number"] { width: 110px; text-align: center; font-weight: bold; color: #1e293b; }
        .search-box input[type="text"]:focus, .search-box input[type="number"]:focus { border-color: #38bdf8; }
        
        .btn-add { background: #10b981; color: white; border: none; padding: 0 30px; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-add:hover { background: #059669; }

        /* جدول الفاتورة */
        .grid-container { flex: 1; overflow-y: auto; border: 1px solid #e2e8f0; border-radius: 8px; }
        .invoice-grid { width: 100%; border-collapse: collapse; text-align: right; }
        .invoice-grid th { background: #f8fafc; padding: 15px; color: #475569; position: sticky; top: 0; }
        .invoice-grid td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; }

        /* القسم الأيسر: الإجماليات والدفع */
        .summary-section { flex: 3; background: #1e293b; color: white; border-radius: 12px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between; }
        .summary-title { font-size: 24px; color: #38bdf8; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 15px; margin-bottom: 20px; }
        .summary-row { display: flex; justify-content: space-between; font-size: 20px; margin-bottom: 15px; color: #cbd5e1; }
        .total-amount { font-size: 40px; font-weight: bold; color: #10b981; text-align: center; margin: 30px 0; }
        
        .btn-checkout { background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; border: none; padding: 20px; border-radius: 8px; font-size: 22px; font-weight: bold; cursor: pointer; width: 100%; transition: 0.3s; }
        .btn-checkout:hover { background: linear-gradient(135deg, #2563eb, #1d4ed8); transform: translateY(-3px); }
        .error-msg { color: #ef4444; font-weight: bold; margin-top: 10px; display: block; text-align: center; }
        
        .back-link { display: block; text-align: center; margin-top: 15px; color: #38bdf8; text-decoration: none; font-size: 16px; font-weight: bold; transition: 0.3s; }
        .back-link:hover { color: #ffffff; text-decoration: underline; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- القائمة الجانبية الموحدة -->
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
                        <li><a href="SalesReturn.aspx">مرتجع مبيعات</a></li>
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
                <h2><i class="fa-solid fa-cart-shopping"></i> نقطة البيع (الكاشير)</h2>
                <div style="display: flex; gap: 20px; align-items: center;">
                    <a href="SalesReturn.aspx" style="background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 15px; font-weight: bold; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-rotate-left"></i> مرتجع مبيعات
                    </a>
                    <a href="Default.aspx"><i class="fa-solid fa-arrow-right"></i> العودة للوحة التحكم</a>
                </div>
            </div>

            <div class="pos-container">
                <!-- قسم الفاتورة وإدخال الباركود والكمية -->
                <div class="invoice-section">
                    <div class="search-box">
                        <asp:TextBox ID="txtBarcode" runat="server" placeholder="قم بتمرير الباركود هنا أو اكتب رقم الدواء..." AutoCompleteType="Disabled" autofocus="true"></asp:TextBox>
                        
                        <!-- حقل تحديد الكمية المطلوب بيعها -->
                        <asp:TextBox ID="txtQtyInput" runat="server" TextMode="Number" Text="1" min="1" title="الكمية المطلوبة"></asp:TextBox>
                        
                        <asp:Button ID="btnAddItem" runat="server" Text="إضافة للفاتورة" CssClass="btn-add" OnClick="btnAddItem_Click" />
                    </div>
                    
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-msg"></asp:Label>

                    <div class="grid-container">
                        <asp:GridView ID="gvInvoice" runat="server" AutoGenerateColumns="False" CssClass="invoice-grid" GridLines="None" ShowHeaderWhenEmpty="True">
                            <Columns>
                                <asp:BoundField DataField="Barcode" HeaderText="الباركود" />
                                <asp:BoundField DataField="TradeName" HeaderText="اسم الدواء" />
                                <asp:BoundField DataField="Price" HeaderText="السعر" />
                                <asp:BoundField DataField="Qty" HeaderText="الكمية" />
                                <asp:BoundField DataField="SubTotal" HeaderText="الإجمالي" />
                            </Columns>
                            <EmptyDataTemplate>
                                <div style="text-align:center; padding: 40px; color: #94a3b8; font-size: 18px;">
                                    <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 15px;"></i><br />
                                    الفاتورة فارغة. ابدأ بإضافة الأدوية.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- قسم الدفع والإجمالي -->
                <div class="summary-section">
                    <div>
                        <h3 class="summary-title">ملخص الفاتورة</h3>
                        <div class="summary-row">
                            <span>عدد الأصناف:</span>
                            <asp:Label ID="lblItemsCount" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
                    
                    <div>
                        <div style="color: #cbd5e1; text-align: center; font-size: 18px;">الإجمالي المطلوب</div>
                        <div class="total-amount">
                            <asp:Label ID="lblTotal" runat="server" Text="0.00"></asp:Label> <span style="font-size: 20px;">ريال</span>
                        </div>
                        
                        <asp:Button ID="btnCheckout" runat="server" Text="حفظ وطباعة (F12)" CssClass="btn-checkout" OnClick="btnCheckout_Click" />
                        
                        <a href="Default.aspx" class="back-link">
                            <i class="fa-solid fa-arrow-right"></i> العودة للوحة التحكم
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>