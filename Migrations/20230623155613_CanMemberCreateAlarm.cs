using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class CanMemberCreateAlarm : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "CanMemberCreateAlarm",
                table: "Groups",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CanMemberCreateAlarm",
                table: "Groups");
        }
    }
}
