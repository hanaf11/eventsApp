using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Dobavljaci",
                columns: table => new
                {
                    DobavljacID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),
                    Fax = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: true),
                    Web = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    ZiroRacun = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Napomena = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: false, defaultValueSql: "((1))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Dobavljaci", x => x.DobavljacID);
                });

            migrationBuilder.CreateTable(
                name: "Kategorije",
                columns: table => new
                {
                    KategorijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kategorije", x => x.KategorijaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: false, defaultValueSql: "((1))"),
                    Created = table.Column<DateTime>(type: "datetime", nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Drzava = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnici", x => x.KorisnikID);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloge", x => x.UlogaID);
                });

            migrationBuilder.CreateTable(
                name: "Dogadjaji",
                columns: table => new
                {
                    DogadjajID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    DatumOd = table.Column<DateTime>(type: "datetime", nullable: false),
                    DatumDo = table.Column<DateTime>(type: "datetime", nullable: false),
                    Program = table.Column<string>(type: "text", nullable: true),
                    Naslovna = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    Opis = table.Column<string>(type: "text", nullable: false),
                    Website = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    Lokacija = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    LokacijaSlika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DobavljacID = table.Column<int>(type: "int", nullable: true),
                    KategorijaID = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PodkategorijaID = table.Column<int>(type: "int", nullable: true),
                    Organizator = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Dogadjaji", x => x.DogadjajID);
                    table.ForeignKey(
                        name: "FK_Dogadjaji_Dobavljaci",
                        column: x => x.DobavljacID,
                        principalTable: "Dobavljaci",
                        principalColumn: "DobavljacID");
                    table.ForeignKey(
                        name: "FK_Dogadjaji_Kategorije",
                        column: x => x.KategorijaID,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaID");
                });

            migrationBuilder.CreateTable(
                name: "Podkategorije",
                columns: table => new
                {
                    PodkategorijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KategorijaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Podkategorije", x => x.PodkategorijaID);
                    table.ForeignKey(
                        name: "FK_Podkategorije_Kategorije",
                        column: x => x.KategorijaID,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaID");
                });

            migrationBuilder.CreateTable(
                name: "Narudzbe",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbe = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    Otkazano = table.Column<bool>(type: "bit", nullable: true),
                    Tip = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    IznosBezPDV = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    IznosSaPDV = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Drzava = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Status = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Narudzbe", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FK_Narudzbe_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Pracenje",
                columns: table => new
                {
                    PracenjeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    KategorijaID = table.Column<int>(type: "int", nullable: false),
                    Vrijeme = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pracenje", x => x.PracenjeID);
                    table.ForeignKey(
                        name: "FK_Pracenje_Kategorije",
                        column: x => x.KategorijaID,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaID");
                    table.ForeignKey(
                        name: "FK_Pracenje_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Ulazi",
                columns: table => new
                {
                    UlazID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojFakture = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    IznosRacuna = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    PDV = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    Napomena = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DobavljacID = table.Column<int>(type: "int", nullable: false)
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
                name: "KorisniciUloge",
                columns: table => new
                {
                    KorisnikUlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    UlogaID = table.Column<int>(type: "int", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisniciUloge", x => x.KorisnikUlogaID);
                    table.ForeignKey(
                        name: "FK_KorisniciUloge_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK_KorisniciUloge_Uloge",
                        column: x => x.UlogaID,
                        principalTable: "Uloge",
                        principalColumn: "UlogaID");
                });

            migrationBuilder.CreateTable(
                name: "HistorijaPregleda",
                columns: table => new
                {
                    PregledID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DogadjajID = table.Column<int>(type: "int", nullable: false),
                    Vrijeme = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_HistorijaPregleda", x => x.PregledID);
                    table.ForeignKey(
                        name: "FK_HistorijaPregleda_Dogadjaji",
                        column: x => x.DogadjajID,
                        principalTable: "Dogadjaji",
                        principalColumn: "DogadjajID");
                    table.ForeignKey(
                        name: "FK_HistorijaPregleda_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Komentari",
                columns: table => new
                {
                    KomentarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DogadjajID = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    Vrijeme = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Komentari", x => x.KomentarID);
                    table.ForeignKey(
                        name: "FK_Komentari_Dogadjaji",
                        column: x => x.DogadjajID,
                        principalTable: "Dogadjaji",
                        principalColumn: "DogadjajID");
                    table.ForeignKey(
                        name: "FK_Komentari_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Saving",
                columns: table => new
                {
                    SaveID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DogadjajID = table.Column<int>(type: "int", nullable: false),
                    Vrijeme = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Saving", x => x.SaveID);
                    table.ForeignKey(
                        name: "FK_Saving_Dogadjaji",
                        column: x => x.DogadjajID,
                        principalTable: "Dogadjaji",
                        principalColumn: "DogadjajID");
                    table.ForeignKey(
                        name: "FK_Saving_Korisnici",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Slike",
                columns: table => new
                {
                    SlikaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Opis = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    DogadjajID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Slike", x => x.SlikaID);
                    table.ForeignKey(
                        name: "FK_Slike_Dogadjaji",
                        column: x => x.DogadjajID,
                        principalTable: "Dogadjaji",
                        principalColumn: "DogadjajID");
                });

            migrationBuilder.CreateTable(
                name: "TipKarte",
                columns: table => new
                {
                    TipKarteID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Stanje = table.Column<int>(type: "int", nullable: false),
                    DogadjajID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TipKarte", x => x.TipKarteID);
                    table.ForeignKey(
                        name: "FK_TipKarte_Dogadjaji",
                        column: x => x.DogadjajID,
                        principalTable: "Dogadjaji",
                        principalColumn: "DogadjajID");
                });

            migrationBuilder.CreateTable(
                name: "Karte",
                columns: table => new
                {
                    KartaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sifra = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Sjediste = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    TipKarteID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Karte", x => x.KartaID);
                    table.ForeignKey(
                        name: "FK_Karte_TipKarte",
                        column: x => x.TipKarteID,
                        principalTable: "TipKarte",
                        principalColumn: "TipKarteID");
                });

            migrationBuilder.CreateTable(
                name: "NarudzbaStavke",
                columns: table => new
                {
                    NarudzbaStavkaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NarudzbaID = table.Column<int>(type: "int", nullable: false),
                    TipKarteID = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NarudzbaStavke", x => x.NarudzbaStavkaID);
                    table.ForeignKey(
                        name: "FK_NarudzbaStavke_Narudzbe",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzbe",
                        principalColumn: "NarudzbaID");
                    table.ForeignKey(
                        name: "FK_NarudzbaStavke_TipKarte",
                        column: x => x.TipKarteID,
                        principalTable: "TipKarte",
                        principalColumn: "TipKarteID");
                });

            migrationBuilder.CreateTable(
                name: "UlazStavke",
                columns: table => new
                {
                    UlazStavkaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UlazID = table.Column<int>(type: "int", nullable: false),
                    TipKarteID = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    KarteInfo = table.Column<byte[]>(type: "varbinary(max)", nullable: false)
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
                name: "IX_Dogadjaji_DobavljacID",
                table: "Dogadjaji",
                column: "DobavljacID");

            migrationBuilder.CreateIndex(
                name: "IX_Dogadjaji_KategorijaID",
                table: "Dogadjaji",
                column: "KategorijaID");

            migrationBuilder.CreateIndex(
                name: "IX_HistorijaPregleda_DogadjajID",
                table: "HistorijaPregleda",
                column: "DogadjajID");

            migrationBuilder.CreateIndex(
                name: "IX_HistorijaPregleda_KorisnikID",
                table: "HistorijaPregleda",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Karte_TipKarteID",
                table: "Karte",
                column: "TipKarteID");

            migrationBuilder.CreateIndex(
                name: "IX_Komentari_DogadjajID",
                table: "Komentari",
                column: "DogadjajID");

            migrationBuilder.CreateIndex(
                name: "IX_Komentari_KorisnikID",
                table: "Komentari",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "CS_Email",
                table: "Korisnici",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "CS_KorisnickoIme",
                table: "Korisnici",
                column: "KorisnickoIme",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_KorisnikID",
                table: "KorisniciUloge",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_UlogaID",
                table: "KorisniciUloge",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbaStavke_NarudzbaID",
                table: "NarudzbaStavke",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbaStavke_TipKarteID",
                table: "NarudzbaStavke",
                column: "TipKarteID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbe_KorisnikID",
                table: "Narudzbe",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Podkategorije_KategorijaID",
                table: "Podkategorije",
                column: "KategorijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Pracenje_KategorijaID",
                table: "Pracenje",
                column: "KategorijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Pracenje_KorisnikID",
                table: "Pracenje",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Saving_DogadjajID",
                table: "Saving",
                column: "DogadjajID");

            migrationBuilder.CreateIndex(
                name: "IX_Saving_KorisnikID",
                table: "Saving",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Slike_DogadjajID",
                table: "Slike",
                column: "DogadjajID");

            migrationBuilder.CreateIndex(
                name: "IX_TipKarte_DogadjajID",
                table: "TipKarte",
                column: "DogadjajID");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "HistorijaPregleda");

            migrationBuilder.DropTable(
                name: "Karte");

            migrationBuilder.DropTable(
                name: "Komentari");

            migrationBuilder.DropTable(
                name: "KorisniciUloge");

            migrationBuilder.DropTable(
                name: "NarudzbaStavke");

            migrationBuilder.DropTable(
                name: "Podkategorije");

            migrationBuilder.DropTable(
                name: "Pracenje");

            migrationBuilder.DropTable(
                name: "Saving");

            migrationBuilder.DropTable(
                name: "Slike");

            migrationBuilder.DropTable(
                name: "UlazStavke");

            migrationBuilder.DropTable(
                name: "Uloge");

            migrationBuilder.DropTable(
                name: "Narudzbe");

            migrationBuilder.DropTable(
                name: "TipKarte");

            migrationBuilder.DropTable(
                name: "Ulazi");

            migrationBuilder.DropTable(
                name: "Dogadjaji");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Dobavljaci");

            migrationBuilder.DropTable(
                name: "Kategorije");
        }
    }
}
