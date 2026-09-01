using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class InvoiceDetails : System.Web.UI.Page
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
                if (Request.QueryString["id"] != null)
                {
                    int invoiceId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadInvoiceHeader(invoiceId);
                    LoadInvoiceItems(invoiceId);
                }
                else
                {
                    Response.Redirect("Invoices.aspx");
                }
            }
        }

        private void LoadInvoiceHeader(int invoiceId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT i.InvoiceID, u.FullName, i.TotalAmount, i.InvoiceDate 
                    FROM Invoices i
                    INNER JOIN Users u ON i.UserID = u.UserID
                    WHERE i.InvoiceID = @InvoiceID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblInvoiceID.Text = reader["InvoiceID"].ToString();
                            lblCashier.Text = reader["FullName"].ToString();
                            lblDate.Text = Convert.ToDateTime(reader["InvoiceDate"]).ToString("yyyy-MM-dd HH:mm");
                            lblTotal.Text = Convert.ToDecimal(reader["TotalAmount"]).ToString("0.00");
                        }
                    }
                }
            }
        }

        private void LoadInvoiceItems(int invoiceId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // الاستعلام الصحيح 100% بناءً على جداولك (InvoiceDetails مرتبط بـ Batches ومنه إلى Medicines)
                string query = @"
                    SELECT m.TradeName, b.SellPrice AS Price, id.Qty, id.SubTotal 
                    FROM InvoiceDetails id
                    INNER JOIN Batches b ON id.BatchID = b.BatchID
                    INNER JOIN Medicines m ON b.MedicineID = m.MedicineID
                    WHERE id.InvoiceID = @InvoiceID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvInvoiceItems.DataSource = dt;
                        gvInvoiceItems.DataBind();
                    }
                }
            }
        }
    }
}