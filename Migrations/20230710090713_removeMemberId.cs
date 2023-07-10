using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class removeMemberId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_OptOuts_Members_MemberId",
                table: "OptOuts");

            migrationBuilder.DropIndex(
                name: "IX_OptOuts_MemberId",
                table: "OptOuts");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_OptOuts_MemberId",
                table: "OptOuts",
                column: "MemberId");

            migrationBuilder.AddForeignKey(
                name: "FK_OptOuts_Members_MemberId",
                table: "OptOuts",
                column: "MemberId",
                principalTable: "Members",
                principalColumn: "MemberGroupId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
