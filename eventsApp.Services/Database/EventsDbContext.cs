using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eventsApp.Services.Database;

public partial class EventsDbContext : DbContext
{
    public EventsDbContext()
    {
    }

    public EventsDbContext(DbContextOptions<EventsDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Dobavljaci> Dobavljacis { get; set; }

    public virtual DbSet<Dogadjaji> Dogadjajis { get; set; }

    public virtual DbSet<HistorijaPregledum> HistorijaPregleda { get; set; }

    public virtual DbSet<Karte> Kartes { get; set; }

    public virtual DbSet<Kategorije> Kategorijes { get; set; }

    public virtual DbSet<Komentari> Komentaris { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<KorisniciUloge> KorisniciUloges { get; set; }

    public virtual DbSet<NarudzbaStavke> NarudzbaStavkes { get; set; }

    public virtual DbSet<Narudzbe> Narudzbes { get; set; }

    public virtual DbSet<Podkategorije> Podkategorijes { get; set; }

    public virtual DbSet<Pracenje> Pracenjes { get; set; }

    public virtual DbSet<Saving> Savings { get; set; }

    public virtual DbSet<Slike> Slikes { get; set; }

    public virtual DbSet<TipKarte> TipKartes { get; set; }

    public virtual DbSet<UlazStavke> UlazStavkes { get; set; }

    public virtual DbSet<Ulazi> Ulazis { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost, 1434; Initial Catalog=eventsDb; User=sa; Password=QWEasd123!; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Dobavljaci>(entity =>
        {
            entity.HasKey(e => e.DobavljacId);

            entity.ToTable("Dobavljaci");

            entity.Property(e => e.DobavljacId).HasColumnName("DobavljacID");
            entity.Property(e => e.Adresa).HasMaxLength(100);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Fax).HasMaxLength(25);
            entity.Property(e => e.Napomena).HasMaxLength(500);
            entity.Property(e => e.Naziv).HasMaxLength(100);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasDefaultValueSql("((1))");
            entity.Property(e => e.Telefon).HasMaxLength(25);
            entity.Property(e => e.Web).HasMaxLength(100);
            entity.Property(e => e.ZiroRacun).HasMaxLength(255);
        });

        modelBuilder.Entity<Dogadjaji>(entity =>
        {
            entity.HasKey(e => e.DogadjajId);

            entity.ToTable("Dogadjaji");

            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.DatumDo).HasColumnType("datetime");
            entity.Property(e => e.DatumOd).HasColumnType("datetime");
            entity.Property(e => e.DobavljacId).HasColumnName("DobavljacID");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.Lokacija).HasMaxLength(200);
            entity.Property(e => e.Naziv).HasMaxLength(100);
            entity.Property(e => e.Opis).HasColumnType("text");
            entity.Property(e => e.Program).HasColumnType("text");
            entity.Property(e => e.Website).HasMaxLength(200);

            entity.HasOne(d => d.Dobavljac).WithMany(p => p.Dogadjajis)
                .HasForeignKey(d => d.DobavljacId)
                .HasConstraintName("FK_Dogadjaji_Dobavljaci");

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Dogadjajis)
                .HasForeignKey(d => d.KategorijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Dogadjaji_Kategorije");
        });

        modelBuilder.Entity<HistorijaPregledum>(entity =>
        {
            entity.HasKey(e => e.PregledId);

            entity.Property(e => e.PregledId).HasColumnName("PregledID");
            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Vrijeme).HasColumnType("datetime");

            entity.HasOne(d => d.Dogadjaj).WithMany(p => p.HistorijaPregleda)
                .HasForeignKey(d => d.DogadjajId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HistorijaPregleda_Dogadjaji");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.HistorijaPregleda)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HistorijaPregleda_Korisnici");
        });

        modelBuilder.Entity<Karte>(entity =>
        {
            entity.HasKey(e => e.KartaId);

            entity.ToTable("Karte");

            entity.Property(e => e.KartaId).HasColumnName("KartaID");
            entity.Property(e => e.Sifra).HasMaxLength(50);
            entity.Property(e => e.Sjediste).HasMaxLength(10);
            entity.Property(e => e.TipKarteId).HasColumnName("TipKarteID");

            entity.HasOne(d => d.TipKarte).WithMany(p => p.Kartes)
                .HasForeignKey(d => d.TipKarteId)
                .HasConstraintName("FK_Karte_TipKarte");
        });

        modelBuilder.Entity<Kategorije>(entity =>
        {
            entity.HasKey(e => e.KategorijaId);

            entity.ToTable("Kategorije");

            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(1000);
        });

        modelBuilder.Entity<Komentari>(entity =>
        {
            entity.HasKey(e => e.KomentarId);

            entity.ToTable("Komentari");

            entity.Property(e => e.KomentarId).HasColumnName("KomentarID");
            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.Komentar).HasMaxLength(1000);
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Vrijeme).HasColumnType("datetime");

            entity.HasOne(d => d.Dogadjaj).WithMany(p => p.Komentaris)
                .HasForeignKey(d => d.DogadjajId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Komentari_Dogadjaji");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Komentaris)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Komentari_Korisnici");
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId);

            entity.ToTable("Korisnici");

            entity.HasIndex(e => e.Email, "CS_Email").IsUnique();

            entity.HasIndex(e => e.KorisnickoIme, "CS_KorisnickoIme").IsUnique();

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Adresa).HasMaxLength(100);
            entity.Property(e => e.Created).HasColumnType("datetime");
            entity.Property(e => e.Drzava).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.LozinkaHash).HasMaxLength(500);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(500);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasDefaultValueSql("((1))");
            entity.Property(e => e.Telefon).HasMaxLength(20);
        });

        modelBuilder.Entity<KorisniciUloge>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId);

            entity.ToTable("KorisniciUloge");

            entity.Property(e => e.KorisnikUlogaId).HasColumnName("KorisnikUlogaID");
            entity.Property(e => e.DatumIzmjene).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KorisniciUloge_Korisnici");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KorisniciUloge_Uloge");
        });

        modelBuilder.Entity<NarudzbaStavke>(entity =>
        {
            entity.HasKey(e => e.NarudzbaStavkaId);

            entity.ToTable("NarudzbaStavke");

            entity.Property(e => e.NarudzbaStavkaId).HasColumnName("NarudzbaStavkaID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.TipKarteId).HasColumnName("TipKarteID");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.NarudzbaStavkes)
                .HasForeignKey(d => d.NarudzbaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NarudzbaStavke_Narudzbe");

            entity.HasOne(d => d.TipKarte).WithMany(p => p.NarudzbaStavkes)
                .HasForeignKey(d => d.TipKarteId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NarudzbaStavke_TipKarte");
        });

        modelBuilder.Entity<Narudzbe>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId);

            entity.ToTable("Narudzbe");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.Adresa).HasMaxLength(100);
            entity.Property(e => e.BrojNarudzbe).HasMaxLength(20);
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.Drzava).HasMaxLength(50);
            entity.Property(e => e.IznosBezPdv)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("IznosBezPDV");
            entity.Property(e => e.IznosSaPdv)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("IznosSaPDV");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Tip).HasMaxLength(20);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Narudzbe_Korisnici");
        });

        modelBuilder.Entity<Podkategorije>(entity =>
        {
            entity.HasKey(e => e.PodkategorijaId);

            entity.ToTable("Podkategorije");

            entity.Property(e => e.PodkategorijaId).HasColumnName("PodkategorijaID");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Podkategorijes)
                .HasForeignKey(d => d.KategorijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Podkategorije_Kategorije");
        });

        modelBuilder.Entity<Pracenje>(entity =>
        {
            entity.ToTable("Pracenje");

            entity.Property(e => e.PracenjeId).HasColumnName("PracenjeID");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Vrijeme).HasColumnType("datetime");

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Pracenjes)
                .HasForeignKey(d => d.KategorijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pracenje_Kategorije");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Pracenjes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pracenje_Korisnici");
        });

        modelBuilder.Entity<Saving>(entity =>
        {
            entity.HasKey(e => e.SaveId);

            entity.ToTable("Saving");

            entity.Property(e => e.SaveId).HasColumnName("SaveID");
            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Vrijeme).HasColumnType("datetime");

            entity.HasOne(d => d.Dogadjaj).WithMany(p => p.Savings)
                .HasForeignKey(d => d.DogadjajId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Saving_Dogadjaji");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Savings)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Saving_Korisnici");
        });

        modelBuilder.Entity<Slike>(entity =>
        {
            entity.HasKey(e => e.SlikaId);

            entity.ToTable("Slike");

            entity.Property(e => e.SlikaId).HasColumnName("SlikaID");
            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.Opis).HasMaxLength(50);

            entity.HasOne(d => d.Dogadjaj).WithMany(p => p.Slikes)
                .HasForeignKey(d => d.DogadjajId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Slike_Dogadjaji");
        });

        modelBuilder.Entity<TipKarte>(entity =>
        {
            entity.ToTable("TipKarte");

            entity.Property(e => e.TipKarteId).HasColumnName("TipKarteID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.DogadjajId).HasColumnName("DogadjajID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Dogadjaj).WithMany(p => p.TipKartes)
                .HasForeignKey(d => d.DogadjajId)
                .HasConstraintName("FK_TipKarte_Dogadjaji");
        });

        modelBuilder.Entity<UlazStavke>(entity =>
        {
            entity.HasKey(e => e.UlazStavkaId);

            entity.ToTable("UlazStavke");

            entity.Property(e => e.UlazStavkaId).HasColumnName("UlazStavkaID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TipKarteId).HasColumnName("TipKarteID");
            entity.Property(e => e.UlazId).HasColumnName("UlazID");

            entity.HasOne(d => d.TipKarte).WithMany(p => p.UlazStavkes)
                .HasForeignKey(d => d.TipKarteId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UlazStavke_TipKarte");

            entity.HasOne(d => d.Ulaz).WithMany(p => p.UlazStavkes)
                .HasForeignKey(d => d.UlazId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UlazStavke_Ulazi");
        });

        modelBuilder.Entity<Ulazi>(entity =>
        {
            entity.HasKey(e => e.UlazId);

            entity.ToTable("Ulazi");

            entity.Property(e => e.UlazId).HasColumnName("UlazID");
            entity.Property(e => e.BrojFakture).HasMaxLength(20);
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.DobavljacId).HasColumnName("DobavljacID");
            entity.Property(e => e.IznosRacuna).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Napomena).HasMaxLength(500);
            entity.Property(e => e.Pdv)
                .HasColumnType("numeric(18, 2)")
                .HasColumnName("PDV");

            entity.HasOne(d => d.Dobavljac).WithMany(p => p.Ulazis)
                .HasForeignKey(d => d.DobavljacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ulazi_Dobavljaci");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Ulazis)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ulazi_Korisnici");
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId);

            entity.ToTable("Uloge");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(200);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
