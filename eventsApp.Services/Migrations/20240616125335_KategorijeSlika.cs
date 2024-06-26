using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class KategorijeSlika : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<byte[]>(
                name: "Slika",
                table: "Kategorije",
                type: "varbinary(max)",
                nullable: false,
                defaultValue: new byte[0]);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Slika",
                table: "Kategorije");
        }
    }
}
