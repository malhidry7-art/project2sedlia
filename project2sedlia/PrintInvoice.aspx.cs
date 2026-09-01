using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class PrintInvoice : System.Web.UI.Page
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
                // استقبال رقم الفاتورة المرسل من شاشة الكاشير
                if (Request.QueryString["id"] != null)
                {
                    string invoiceId = Request.QueryString["id"];
                    LoadInvoiceDetails(invoiceId);
                }
            }
        }

        private void LoadInvoiceDetails(string invoiceId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 1. جلب بيانات الفاتورة الرئيسية (التاريخ، الإجمالي، اسم الكاشير)
                string invoiceQuery = @"
                    SELECT i.InvoiceID, i.InvoiceDate, i.TotalAmount, u.FullName 
                    FROM Invoices i
                    INNER JOIN Users u ON i.UserID = u.UserID
                    WHERE i.InvoiceID = @InvoiceID";

                using (SqlCommand cmd = new SqlCommand(invoiceQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();
                            lblInvoiceID.Text = reader["InvoiceID"].ToString();
                            lblDate.Text = Convert.ToDateTime(reader["InvoiceDate"]).ToString("yyyy-MM-dd HH:mm");
                            lblCashier.Text = reader["FullName"].ToString();
                            lblTotalAmount.Text = Convert.ToDecimal(reader["TotalAmount"]).ToString("0.00");
                        }
                    }
                }

                // 2. جلب أصناف الفاتورة لعرضها في جدول الطباعة المصغر
                string detailsQuery = @"
                    SELECT m.TradeName, d.Qty, d.SubTotal 
                    FROM InvoiceDetails d
                    INNER JOIN Batches b ON d.BatchID = b.BatchID
                    INNER JOIN Medicines m ON b.MedicineID = m.MedicineID
                    WHERE d.InvoiceID = @InvoiceID";

                using (SqlCommand cmdDetails = new SqlCommand(detailsQuery, conn))
                {
                    cmdDetails.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmdDetails))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvPrintItems.DataSource = dt;
                        gvPrintItems.DataBind();
                    }
                }
            }
        }
    }
}