using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class RemoveAlarmOptions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AlarmOptions");

            migrationBuilder.AddColumn<string>(
                name: "AudioURL",
                table: "Alarms",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "InternalAudioFile",
                table: "Alarms",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "NotificationBody",
                table: "Alarms",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "NotificationTitle",
                table: "Alarms",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "UseExternalAudio",
                table: "Alarms",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "loopAudio",
                table: "Alarms",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "vibrate",
                table: "Alarms",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AudioURL",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "InternalAudioFile",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "NotificationBody",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "NotificationTitle",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "UseExternalAudio",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "loopAudio",
                table: "Alarms");

            migrationBuilder.DropColumn(
                name: "vibrate",
                table: "Alarms");

            migrationBuilder.CreateTable(
                name: "AlarmOptions",
                columns: table => new
                {
                    AlarmOptionsId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AlarmId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AudioURL = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    InternalAudioFile = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NotificationBody = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NotificationTitle = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UseExternalAudio = table.Column<bool>(type: "bit", nullable: false),
                    loopAudio = table.Column<bool>(type: "bit", nullable: false),
                    vibrate = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AlarmOptions", x => x.AlarmOptionsId);
                    table.ForeignKey(
                        name: "FK_AlarmOptions_Alarms_AlarmId",
                        column: x => x.AlarmId,
                        principalTable: "Alarms",
                        principalColumn: "AlarmId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AlarmOptions_AlarmId",
                table: "AlarmOptions",
                column: "AlarmId");
        }
    }
}
