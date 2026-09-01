<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="project2sedlia.Inventory" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>إدارة المخزون والأدوية المنتهية | نظام الصيدلية الذكي</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body, html { height: 100%; width: 100%; background-color: #eef2f5; }
        .wrapper { display: flex; min-height: 100vh; width: 100vw; }

        .sidebar { width: 280px; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%); color: #fff; display: flex; flex-direction: column; box-shadow: -4px 0 15px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 30px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 22px; color: #38bdf8; letter-spacing: 1px; }
        .sidebar-menu { display: flex; flex-direction: column; padding: 20px 0; overflow-y: auto; }
        .sidebar-menu a { color: #cbd5e1; padding: 18px 25px; text-decoration: none; font-size: 16px; display: flex; align-items: center; transition: all 0.3s ease; border-right: 4px solid transparent; }
        .sidebar-menu a i { margin-left: 15px; font-size: 20px; width: 25px; text-align: center; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255,255,255,0.05); color: #fff; border-right: 4px solid #38bdf8; }

        .main-content { flex: 1; display: flex; flex-direction: column; padding: 30px 40px; overflow-y: auto; }
        
        /* شريط البحث والفلاتر */
        .controls-container { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 25px; display: flex; flex-direction: column; gap: 15px; }
        .search-row { display: flex; gap: 15px; align-items: center; }
        .search-row input[type="text"] { flex: 1; padding: 12px 15px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 16px; outline: none; transition: 0.3s; }
        .search-row input[type="text"]:focus { border-color: #38bdf8; }
        
        .filter-row { display: flex; gap: 10px; flex-wrap: wrap; }

        .btn { padding: 10px 20px; border-radius: 8px; font-size: 15px; font-weight: bold; cursor: pointer; border: none; transition: 0.3s; color: white; display: inline-flex; align-items: center; gap: 8px; }
        .btn-search { background: #38bdf8; }
        .btn-search:hover { background: #0284c7; }
        .btn-all { background: #64748b; }
        .btn-all:hover { background: #475569; }
        .btn-expired-filter { background: #ef4444; }
        .btn-expired-filter:hover { background: #dc2626; }
        .btn-lowstock-filter { background: #f59e0b; }
        .btn-lowstock-filter:hover { background: #d97706; }

        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); flex: 1; overflow-y: auto; }
        .custom-grid { width: 100%; border-collapse: collapse; text-align: right; }
        .custom-grid th { background: #f8fafc; padding: 15px; color: #475569; border-bottom: 2px solid #e2e8f0; position: sticky; top: 0; }
        .custom-grid td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; }
        .custom-grid tr:hover { background-color: #f8fafc; }
        
        /* أزرار الإجراءات داخل الجدول */
        .custom-grid a { color: #3b82f6; text-decoration: none; font-weight: bold; margin: 0 5px; }
        .custom-grid a:hover { text-decoration: underline; color: #1d4ed8; }
        .custom-grid input[type="text"] { padding: 5px; border: 1px solid #cbd5e1; border-radius: 5px; width: 80px; }
        
        .btn-delete-row { background: #fee2e2; color: #ef4444; border: 1px solid #fca5a5; padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; transition: 0.2s; }
        .btn-delete-row:hover { background: #ef4444; color: #ffffff; }

        .msg-bar { margin-bottom: 15px; font-weight: bold; font-size: 15px; }
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
                    <a href="AddMedicine.aspx"><i class="fa-solid fa-pills"></i> إدارة الأدوية</a>
                    <a href="Inventory.aspx" class="active"><i class="fa-solid fa-boxes-stacked"></i> المخزون</a>
                    <a href="Restock.aspx"><i class="fa-solid fa-boxes-packing"></i> توريد شحنة جديدة</a>
                    <a href="Reports.aspx"><i class="fa-solid fa-file-invoice-dollar"></i> التقارير</a>
                    <a href="Logout.aspx" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> تسجيل الخروج</a>
                </div>
            </nav>

            <main class="main-content">
                <h2 style="margin-bottom: 20px; color: #334155;">إدارة المخزون والتخلص من الأدوية المنتهية</h2>
                
                <asp:Label ID="lblStatusMsg" runat="server" CssClass="msg-bar"></asp:Label>

                <div class="controls-container">
                    <!-- سطر البحث الفوري التفاعلي -->
                    <div class="search-row">
                        <asp:TextBox ID="txtSearch" runat="server" placeholder="ابحث باسم الدواء أو الباركود..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="بحث" CssClass="btn btn-search" OnClick="btnSearch_Click" />
                    </div>

                    <!-- أزرار الفرز السريع -->
                    <div class="filter-row">
                        <asp:Button ID="btnReset" runat="server" Text="عرض كل المخزون" CssClass="btn btn-all" OnClick="btnReset_Click" />
                        <asp:Button ID="btnFilterExpired" runat="server" Text="الأدوية المنتهية فقط" CssClass="btn btn-expired-filter" OnClick="btnFilterExpired_Click" />
                        <asp:Button ID="btnFilterLowStock" runat="server" Text="نواقص المخزون فقط" CssClass="btn btn-lowstock-filter" OnClick="btnFilterLowStock_Click" />
                    </div>
                </div>

                <div class="table-container">
                    <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" 
                        DataKeyNames="BatchID" 
                        OnRowEditing="gvInventory_RowEditing" 
                        OnRowCancelingEdit="gvInventory_RowCancelingEdit" 
                        OnRowUpdating="gvInventory_RowUpdating"
                        OnRowDeleting="gvInventory_RowDeleting"
                        OnRowDataBound="gvInventory_RowDataBound"
                        EmptyDataText="لا توجد أدوية مطابقة للشروط المحددة.">
                        <Columns>
                            <asp:BoundField DataField="Barcode" HeaderText="الباركود" ReadOnly="True" />
                            <asp:BoundField DataField="TradeName" HeaderText="اسم الدواء" ReadOnly="True" />
                            <asp:BoundField DataField="CategoryName" HeaderText="التصنيف" ReadOnly="True" />
                            
                            <asp:BoundField DataField="Quantity" HeaderText="الكمية" />
                            <asp:BoundField DataField="SellPrice" HeaderText="السعر" DataFormatString="{0:0.00}" />
                            
                            <asp:BoundField DataField="ExpiryDate" HeaderText="الصلاحية" ReadOnly="True" DataFormatString="{0:yyyy-MM-dd}" />
                            
                            <asp:CommandField ShowEditButton="True" EditText="تعديل" UpdateText="حفظ" CancelText="إلغاء" HeaderText="الأسعار والكمية" />

                            <asp:TemplateField HeaderText="إجراءات التالف">
                                <ItemTemplate>
                                    <asp:Button ID="btnDelete" runat="server" Text="إتلاف / حذف" CommandName="Delete" 
                                        CssClass="btn-delete-row" 
                                        OnClientClick="return confirm('هل أنت متأكد من حذف وإبعاد هذا الصنف التالف نهائياً من المخزون؟');" />
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