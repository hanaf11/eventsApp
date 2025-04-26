using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUlaziTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UlazStavke");

            migrationBuilder.DropTable(
                name: "Ulazi");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Ulazi",
                columns: table => new
                {
                    UlazID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DobavljacID = table.Column<int>(type: "int", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    BrojFakture = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    IznosRacuna = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Napomena = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    PDV = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ulazi", x => x.UlazID);
                    table.ForeignKey(
                        name: "FK_Ulazi_Dobavljaci",
                        column: x => x.DobavljacID,
                        principalTable: "Dobavljaci",
                        principalColumn: "DobavljacID");
                    table.ForeignKey(
                        name: "FK_Ulazi_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "UlazStavke",
                columns: table => new
                {
                    UlazStavkaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TipKarteID = table.Column<int>(type: "int", nullable: false),
                    UlazID = table.Column<int>(type: "int", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    KarteInfo = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UlazStavke", x => x.UlazStavkaID);
                    table.ForeignKey(
                        name: "FK_UlazStavke_TipKarte",
                        column: x => x.TipKarteID,
                        principalTable: "TipKarte",
                        principalColumn: "TipKarteID");
                    table.ForeignKey(
                        name: "FK_UlazStavke_Ulazi",
                        column: x => x.UlazID,
                        principalTable: "Ulazi",
                        principalColumn: "UlazID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Ulazi_DobavljacID",
                table: "Ulazi",
                column: "DobavljacID");

            migrationBuilder.CreateIndex(
                name: "IX_Ulazi_KorisnikID",
                table: "Ulazi",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_UlazStavke_TipKarteID",
                table: "UlazStavke",
                column: "TipKarteID");

            migrationBuilder.CreateIndex(
                name: "IX_UlazStavke_UlazID",
                table: "UlazStavke",
                column: "UlazID");
        }
    }
}
