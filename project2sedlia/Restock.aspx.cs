using System;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Restock : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadMedicinesDropdown();
            }
        }

        private void LoadMedicinesDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT MedicineID, TradeName, Barcode FROM Medicines";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlMedicines.DataSource = reader;
                    ddlMedicines.DataTextField = "TradeName";
                    ddlMedicines.DataValueField = "MedicineID";
                    ddlMedicines.DataBind();
                }
            }
        }

        protected void btnRestock_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    INSERT INTO Batches (MedicineID, Quantity, PurchasePrice, SellPrice, ExpiryDate) 
                    VALUES (@MedicineID, @Qty, @PurchasePrice, @SellPrice, @ExpiryDate)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MedicineID", ddlMedicines.SelectedValue);
                    cmd.Parameters.AddWithValue("@Qty", Convert.ToInt32(txtAddQty.Text));
                    cmd.Parameters.AddWithValue("@PurchasePrice", Convert.ToDecimal(txtNewPurchase.Text));
                    cmd.Parameters.AddWithValue("@SellPrice", Convert.ToDecimal(txtNewSell.Text));
                    cmd.Parameters.AddWithValue("@ExpiryDate", Convert.ToDateTime(txtNewExpiry.Text));

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        lblMsg.Text = "تم توريد الشحنة وزيادة المخزون بنجاح!";
                        lblMsg.ForeColor = System.Drawing.Color.Green;
                        txtAddQty.Text = "";
                    }
                    catch (Exception ex)
                    {
                        lblMsg.Text = "خطأ أثناء التوريد: " + ex.Message;
                        lblMsg.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }
    }
}