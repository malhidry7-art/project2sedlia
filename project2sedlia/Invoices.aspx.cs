using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Invoices : System.Web.UI.Page
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
                LoadInvoicesData();
            }
        }

        private void LoadInvoicesData()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // استعلام لجلب الفواتير مع اسم الكاشير المسؤول من جدول المستخدمين
                string query = @"
                    SELECT i.InvoiceID, u.FullName, i.TotalAmount, i.InvoiceDate 
                    FROM Invoices i
                    INNER JOIN Users u ON i.UserID = u.UserID
                    ORDER BY i.InvoiceDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvInvoices.DataSource = dt;
                        gvInvoices.DataBind();
                    }
                }
            }
        }
    }
}