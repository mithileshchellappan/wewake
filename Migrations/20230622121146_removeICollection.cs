using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeWakeAPI.Migrations
{
    /// <inheritdoc />
    public partial class removeICollection : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GroupUser");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GroupUser",
                columns: table => new
                {
                    MembersUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MembershipsGroupId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GroupUser", x => new { x.MembersUserId, x.MembershipsGroupId });
                    table.ForeignKey(
                        name: "FK_GroupUser_Groups_MembershipsGroupId",
                        column: x => x.MembershipsGroupId,
                        principalTable: "Groups",
                        principalColumn: "GroupId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_GroupUser_Users_MembersUserId",
                        column: x => x.MembersUserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GroupUser_MembershipsGroupId",
                table: "GroupUser",
                column: "MembershipsGroupId");
        }
    }
}
