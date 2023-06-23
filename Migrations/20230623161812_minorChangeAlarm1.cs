using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class minorChangeAlarm1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "vibrate",
                table: "Alarms",
                newName: "Vibrate");

            migrationBuilder.RenameColumn(
                name: "loopAudio",
                table: "Alarms",
                newName: "LoopAudio");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Vibrate",
                table: "Alarms",
                newName: "vibrate");

            migrationBuilder.RenameColumn(
                name: "LoopAudio",
                table: "Alarms",
                newName: "loopAudio");
        }
    }
}
