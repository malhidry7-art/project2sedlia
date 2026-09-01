<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintInvoice.aspx.cs" Inherits="project2sedlia.PrintInvoice" %>

<!DOCTYPE html>
<html dir="rtl">
<head runat="server">
    <title>طباعة الفاتورة</title>
    <style>
        body {
            font-family: 'Courier New', Courier, monospace; /* خط مناسب للفواتير الحرارية */
            width: 80mm; /* عرض الورق الحراري القياسي */
            margin: 0 auto;
            padding: 10px;
            background: #fff;
            color: #000;
        }
        .invoice-header {
            text-align: center;
            border-bottom: 1px dashed #000;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .invoice-header h2 { margin: 0 0 5px 0; font-size: 20px; }
        .invoice-header p { margin: 2px 0; font-size: 12px; }
        
        .invoice-info {
            font-size: 12px;
            margin-bottom: 10px;
            border-bottom: 1px dashed #000;
            padding-bottom: 5px;
        }
        .invoice-info div { display: flex; justify-content: space-between; margin-bottom: 3px; }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 10px;
        }
        .items-table th, .items-table td {
            padding: 5px 2px;
            text-align: right;
            border-bottom: 1px solid #ddd;
        }
        .items-table th { border-bottom: 1px solid #000; }

        .invoice-total {
            border-top: 1px dashed #000;
            padding-top: 8px;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .invoice-footer {
            text-align: center;
            font-size: 11px;
            border-top: 1px dashed #000;
            padding-top: 10px;
        }

        /* إخفاء الزر عند الطباعة الفعلية */
        @media print {
            .no-print { display: none; }
        }
        .btn-print {
            width: 100%;
            padding: 10px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
    </style>
</head>
<body onload="window.print();"> <!-- تفتح نافذة الطباعة تلقائياً بمجرد فتح الصفحة -->
    <form id="form1" runat="server">
        <div class="invoice-header">
            <h2>صيدلية فارما تك</h2>
            <p>إدارة الأدوية والمستلزمات الطبية</p>
            <p>هاتف: 012345678</p>
        </div>

        <div class="invoice-info">
            <div><span>رقم الفاتورة:</span> <span><asp:Label ID="lblInvoiceID" runat="server"></asp:Label></span></div>
            <div><span>التاريخ:</span> <span><asp:Label ID="lblDate" runat="server"></asp:Label></span></div>
            <div><span>الكاشير:</span> <span><asp:Label ID="lblCashier" runat="server"></asp:Label></span></div>
        </div>

        <asp:GridView ID="gvPrintItems" runat="server" AutoGenerateColumns="False" CssClass="items-table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="TradeName" HeaderText="الصنف" />
                <asp:BoundField DataField="Qty" HeaderText="الكمية" />
                <asp:BoundField DataField="SubTotal" HeaderText="المبلغ" DataFormatString="{0:0.00}" />
            </Columns>
        </asp:GridView>

        <div class="invoice-total">
            <span>الإجمالي النهائي:</span>
            <span><asp:Label ID="lblTotalAmount" runat="server"></asp:Label> ريال</span>
        </div>

        <div class="invoice-footer">
            <p>شكراً لزيارتكم، نتمنى لكم الشفاء العاجل</p>
            <p>البضاعة المباعة تسترجع وتستبدل خلال 3 أيام بشرط سلامتها</p>
        </div>

        <div style="margin-top: 20px;">
            <button type="button" class="btn-print no-print" onclick="window.print();">إعادة الطباعة</button>
            <div style="text-align: center; margin-top: 10px;" class="no-print">
                <a href="POS.aspx" style="color: #2563eb; text-decoration: none; font-size: 14px; font-family: 'Segoe UI', Tahoma, sans-serif;">&larr; العودة لشاشة الكاشير</a>
            </div>
        </div>
    </form>
</body>
</html>