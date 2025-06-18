using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedDataFromScript : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var sql = System.IO.File.ReadAllText("/app/eventsApp.DB/seedDb.sql");

            /* var basePath = AppDomain.CurrentDomain.BaseDirectory;
             var scriptPath = Path.Combine(basePath, "../eventsApp.DB/seedDb.sql");*/


            migrationBuilder.Sql(sql);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
           
        }
    }
}
