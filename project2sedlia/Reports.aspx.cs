using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Reports : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadReportData();
            }
        }

        private void LoadReportData()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 1. جلب إجمالي المبيعات الكلية
                string totalQuery = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices";
                using (SqlCommand cmdTotal = new SqlCommand(totalQuery, conn))
                {
                    decimal totalSales = Convert.ToDecimal(cmdTotal.ExecuteScalar());
                    lblTotalSales.Text = totalSales.ToString("0.00");
                }

                // 2. جلب جدول الفواتير مع اسم الكاشير
                string invoicesQuery = @"
                    SELECT i.InvoiceID, u.FullName, i.TotalAmount, i.InvoiceDate 
                    FROM Invoices i
                    INNER JOIN Users u ON i.UserID = u.UserID
                    ORDER BY i.InvoiceID DESC";

                using (SqlCommand cmdInv = new SqlCommand(invoicesQuery, conn))
                {
                    using (SqlDataAdapter sdaInv = new SqlDataAdapter(cmdInv))
                    {
                        DataTable dtInv = new DataTable();
                        sdaInv.Fill(dtInv);
                        gvInvoices.DataSource = dtInv;
                        gvInvoices.DataBind();
                    }
                }

                // 3. جلب جدول المرتجعات مع اسم الدواء، الكمية، واسم الكاشير
                string returnsQuery = @"
                    SELECT r.ReturnID, r.InvoiceID, u.FullName, m.TradeName, rd.Qty AS ReturnQty, r.TotalRefund, r.ReturnDate 
                    FROM SalesReturns r
                    INNER JOIN Users u ON r.UserID = u.UserID
                    INNER JOIN ReturnDetails rd ON r.ReturnID = rd.ReturnID
                    INNER JOIN Batches b ON rd.BatchID = b.BatchID
                    INNER JOIN Medicines m ON b.MedicineID = m.MedicineID
                    ORDER BY r.ReturnID DESC";

                using (SqlCommand cmdRet = new SqlCommand(returnsQuery, conn))
                {
                    using (SqlDataAdapter sdaRet = new SqlDataAdapter(cmdRet))
                    {
                        DataTable dtRet = new DataTable();
                        sdaRet.Fill(dtRet);
                        gvReturns.DataSource = dtRet;
                        gvReturns.DataBind();
                    }
                }
            }
        }
    }
}