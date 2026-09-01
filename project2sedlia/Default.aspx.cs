using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Default : System.Web.UI.Page
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
                if (Session["FullName"] != null)
                {
                    lblUserName.Text = Session["FullName"].ToString();
                }

                LoadDashboardStats();
            }
        }

        private void LoadDashboardStats()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 1. إجمالي مبيعات اليوم
                string dailySalesQuery = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices WHERE CAST(InvoiceDate AS DATE) = CAST(GETDATE() AS DATE)";
                using (SqlCommand cmd1 = new SqlCommand(dailySalesQuery, conn))
                {
                    decimal dailySales = Convert.ToDecimal(cmd1.ExecuteScalar());
                    lblDailySales.Text = dailySales.ToString("0.00");
                }

                // 2. عدد الفواتير المنجزة الكلية
                string invoicesCountQuery = "SELECT COUNT(*) FROM Invoices";
                using (SqlCommand cmd2 = new SqlCommand(invoicesCountQuery, conn))
                {
                    int count = Convert.ToInt32(cmd2.ExecuteScalar());
                    lblInvoicesCount.Text = count.ToString();
                }

                // 3. نواقص المخزون (الكمية أقل من أو تساوي 5)
                string lowStockQuery = "SELECT COUNT(*) FROM Batches WHERE Quantity <= 5";
                using (SqlCommand cmd3 = new SqlCommand(lowStockQuery, conn))
                {
                    int lowStockCount = Convert.ToInt32(cmd3.ExecuteScalar());
                    lblLowStock.Text = lowStockCount.ToString();
                }

                // 4. الأدوية التي قاربت على الانتهاء (خلال 90 يوماً القادمة)
                string expiredQuery = "SELECT COUNT(*) FROM Batches WHERE ExpiryDate <= DATEADD(day, 90, GETDATE()) AND ExpiryDate >= GETDATE()";
                using (SqlCommand cmd4 = new SqlCommand(expiredQuery, conn))
                {
                    int expiredCount = Convert.ToInt32(cmd4.ExecuteScalar());
                    lblExpired.Text = expiredCount.ToString();
                }
            }
        }

        protected void btnGoToPOS_Click(object sender, EventArgs e)
        {
            Response.Redirect("POS.aspx");
        }

        protected void btnAddMed_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddMedicine.aspx");
        }
    }
}