using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class NarudzbeChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IznosBezPDV",
                table: "Narudzbe");

            migrationBuilder.RenameColumn(
                name: "Status",
                table: "Narudzbe",
                newName: "Email");

            migrationBuilder.RenameColumn(
                name: "IznosSaPDV",
                table: "Narudzbe",
                newName: "Cijena");

            migrationBuilder.AddColumn<string>(
                name: "Grad",
                table: "Narudzbe",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Ime",
                table: "Narudzbe",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "PostanskiBroj",
                table: "Narudzbe",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Prezime",
                table: "Narudzbe",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Telefon",
                table: "Narudzbe",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Grad",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "Ime",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "PostanskiBroj",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "Prezime",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "Telefon",
                table: "Narudzbe");

            migrationBuilder.RenameColumn(
                name: "Email",
                table: "Narudzbe",
                newName: "Status");

            migrationBuilder.RenameColumn(
                name: "Cijena",
                table: "Narudzbe",
                newName: "IznosSaPDV");

            migrationBuilder.AddColumn<decimal>(
                name: "IznosBezPDV",
                table: "Narudzbe",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);
        }
    }
}
