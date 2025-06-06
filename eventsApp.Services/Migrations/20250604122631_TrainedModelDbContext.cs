using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eventsApp.Services.Migrations
{
    /// <inheritdoc />
    public partial class TrainedModelDbContext : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_TrainedModels",
                table: "TrainedModels");

            migrationBuilder.RenameTable(
                name: "TrainedModels",
                newName: "TrainedModel");

            migrationBuilder.RenameColumn(
                name: "TrainedModelId",
                table: "TrainedModel",
                newName: "TrainedModelID");

            migrationBuilder.AlterColumn<DateTime>(
                name: "Created",
                table: "TrainedModel",
                type: "datetime",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AddPrimaryKey(
                name: "PK_TrainedModel",
                table: "TrainedModel",
                column: "TrainedModelID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_TrainedModel",
                table: "TrainedModel");

            migrationBuilder.RenameTable(
                name: "TrainedModel",
                newName: "TrainedModels");

            migrationBuilder.RenameColumn(
                name: "TrainedModelID",
                table: "TrainedModels",
                newName: "TrainedModelId");

            migrationBuilder.AlterColumn<DateTime>(
                name: "Created",
                table: "TrainedModels",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime");

            migrationBuilder.AddPrimaryKey(
                name: "PK_TrainedModels",
                table: "TrainedModels",
                column: "TrainedModelId");
        }
    }
}
