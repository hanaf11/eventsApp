using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class KarteChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Slika",
                table: "Karte");

            migrationBuilder.AddColumn<bool>(
                name: "NumerisanjeSjedista",
                table: "TipKarte",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NumerisanjeSjedista",
                table: "TipKarte");

            migrationBuilder.AddColumn<byte[]>(
                name: "Slika",
                table: "Karte",
                type: "varbinary(max)",
                nullable: true);
        }
    }
}
