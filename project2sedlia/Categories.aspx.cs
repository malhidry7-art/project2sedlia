using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Categories : System.Web.UI.Page
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
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryID DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvCategories.DataSource = dt;
                        gvCategories.DataBind();
                    }
                }
            }
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            string categoryName = txtCategoryName.Text.Trim();

            if (string.IsNullOrEmpty(categoryName))
            {
                lblMessage.Text = "يرجى إدخال اسم التصنيف.";
                lblMessage.CssClass = "msg error";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "INSERT INTO Categories (CategoryName) VALUES (@CategoryName)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        lblMessage.Text = "تم إضافة التصنيف بنجاح!";
                        lblMessage.CssClass = "msg success";
                        txtCategoryName.Text = "";
                        LoadCategories(); // تحديث الجدول فوراً
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "حدث خطأ أثناء الحفظ: " + ex.Message;
                        lblMessage.CssClass = "msg error";
                    }
                }
            }
        }
    }
}